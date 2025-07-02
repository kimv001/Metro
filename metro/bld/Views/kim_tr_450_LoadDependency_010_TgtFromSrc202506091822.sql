
CREATE VIEW [bld].[kim_tr_450_LoadDependency_010_TgtFromSrc202506091822] AS
/*
=== Comments =========================================

Description:
    Get all source dependencies for one target, starting from changed tables.
    Note that the target itself is also noted as a source.

Changelog:
20220804    0000    K. Vermeij              Initial
20240424    1430    K. Vermeij              Added DependencyType
20240608    1230    Copilot                 Refactored to use starting_points for full tree expansion
=======================================================
*/

-- Stap 1: gewijzigde tabellen
with code_changes AS (
    SELECT DISTINCT code, rectype
    FROM [bld].[vw_LoadDependencySmartLoad]
    WHERE ISNULL(rectype, 0) > -99
)

-- Stap 2: startpunten voor de boom
, starting_points AS (
    SELECT DISTINCT code AS bk FROM code_changes
)

-- Stap 3: alle relevante afhankelijkheden (let op: tgt = child, src = parent)
, rebase AS (
    SELECT DISTINCT
          bk_target       = dd.bk_child
        , bk_source       = dd.bk_parent
        , dependencytype  = 'TgtFromSrc'
    FROM bld.vw_datasetdependency dd
    WHERE dd.dependencytype = 'SrcToTgt'
)

-- Stap 4: recursieve boom vanaf gewijzigde tabellen
, tgtfromsrc AS (
    SELECT 
          r.bk_target
        , r.bk_source
        , 1 AS lvl
        , r.dependencytype
    FROM rebase r
    JOIN starting_points sp ON r.bk_target = sp.bk

    UNION ALL

    SELECT 
          r.bk_target
        , r.bk_source
        , t.lvl + 1
        , r.dependencytype
    FROM rebase r
    JOIN tgtfromsrc t ON r.bk_target = t.bk_source
)

-- Stap 5: unieke paden + root als eigen parent
, uniquetgtfromsrc AS (
    SELECT  
          bk_target
        , bk_source
        , MAX(lvl) AS lvl
        , dependencytype
    FROM tgtfromsrc 
    GROUP BY bk_target, bk_source, dependencytype

    UNION ALL

    SELECT DISTINCT 
          bk_target
        , bk_target AS bk_source
        , -100 AS lvl
        , dependencytype
    FROM tgtfromsrc
    WHERE lvl = 1
)

-- Stap 6: final output met metadata
, final AS (
    SELECT DISTINCT
          bk                 = b.dependencytype + '|' + tgt.bk + '|' + src.bk
        , code               = tgt.code
        , bk_target          = tgt.bk
        , tgt_layer          = tgt.layername    
        , tgt_schema         = tgt.schemaname
        , tgt_group          = tgt.bk_group
        , tgt_shortname      = tgt.shortname
        , tgt_code           = tgt.code
        , tgt_datasetname    = tgt.datasetname

        , bk_source          = src.bk
        , src_layer          = src.layername    
        , src_schema         = src.schemaname
        , src_group          = src.bk_group
        , src_shortname      = src.shortname
        , src_code           = src.code
        , src_datasetname    = src.datasetname
        , dependencytype     = b.dependencytype
        , lvl                = b.lvl
        , mta_rectype        = COALESCE(cc_src.rectype, cc_tgt.rectype, 0)
    FROM uniquetgtfromsrc b
    JOIN bld.vw_dataset src ON src.bk = b.bk_source
    LEFT JOIN code_changes cc_src ON cc_src.code = src.code
    JOIN bld.vw_dataset tgt ON tgt.bk = b.bk_target
    LEFT JOIN code_changes cc_tgt ON cc_tgt.code = tgt.code
)

-- Stap 7: eindselectie met generatievolgorde
SELECT *
     , generation_number = ROW_NUMBER() OVER (PARTITION BY bk_target ORDER BY lvl ASC)
FROM final