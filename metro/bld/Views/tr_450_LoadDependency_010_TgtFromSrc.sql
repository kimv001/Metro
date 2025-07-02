
CREATE VIEW [bld].[tr_450_LoadDependency_010_TgtFromSrc] AS
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

-- Step 1: Identify changed datasets based on rectype
with code_changes as (
    select distinct code, rectype
    from [bld].[vw_LoadDependencySmartLoad]
    where isnull(rectype, 0) > -99
),

-- Step 2: Map changed codes to business keys and generate cleaned keys
changed_bks as (
    select 
        bk,
        CleanKey = concat(bk_schema, '||', bk_group, '|', shortname, '|')
    from bld.vw_Dataset
    where code in (select code from code_changes)
),

-- Step 3: Build base dependency list with cleaned keys
base as (
    select 
        BK_Target = dd.BK_Child,
        BK_Source = dd.BK_Parent,
        BK_TargetClean = concat(tgt.BK_Schema, '||', tgt.BK_Group, '|', tgt.ShortName, '|'),
        BK_SourceClean = concat(src.BK_Schema, '||', src.BK_Group, '|', src.ShortName, '|')
    from bld.vw_DatasetDependency dd
    join bld.vw_Dataset src on src.bk = dd.BK_Parent
    join bld.vw_Dataset tgt on tgt.bk = dd.BK_Child
    where DependencyType = 'SrcToTgt'
),

-- Step 4: Rejoin cleaned keys to actual BKs
rebase as (
    select 
        BK_Target = tgt.bk,
        BK_Source = src.bk
    from base b
    join bld.vw_Dataset src on src.bk = b.BK_SourceClean
    join bld.vw_Dataset tgt on tgt.bk = b.BK_TargetClean
    where src.bk <> tgt.bk
),

-- Step 5: Recursive CTE to walk the dependency tree from changed sources
TgtFromSrc as (
    select BK_Target, BK_Source, 1 as lvl
    from rebase
    where BK_Source in (select bk from changed_bks)

    union all

    select d.BK_Target, s.BK_Source, d.lvl + 1
    from TgtFromSrc d
    join rebase s on d.BK_Source = s.BK_Target
),

-- Step 6: Deduplicate and add self-dependencies
UniqueTgtFromSrc as (
    select BK_Target, BK_Source, max(lvl) lvl
    from TgtFromSrc
    group by BK_Target, BK_Source

    union all

    select distinct src.BK_Target, src.BK_Target, -100
    from TgtFromSrc src
    where src.lvl = 1
)

-- Step 7: Final output with all required metadata
select
      BK                = 'TgtFromSrc' + '|' + tgt.BK + '|' + src.BK
    , Code              = tgt.Code
    , BK_Target         = tgt.BK
    , TGT_Layer         = tgt.LayerName    
    , TGT_Schema        = tgt.SchemaName
    , TGT_Group         = tgt.BK_Group
    , TGT_ShortName     = tgt.ShortName
    , TGT_Code          = tgt.Code
    , TGT_DatasetName   = tgt.DatasetName

    , BK_Source         = src.BK
    , SRC_Layer         = src.LayerName    
    , SRC_Schema        = src.SchemaName
    , SRC_Group         = src.BK_Group
    , SRC_ShortName     = src.ShortName
    , SRC_Code          = src.Code
    , SRC_DatasetName   = src.DatasetName

    , lvl               = b.lvl
    , dependencytype    = 'TgtFromSrc'
    , mta_rectype       = coalesce(cc.rectype, 0)
    , Generation_Number = ROW_NUMBER() over (partition by tgt.BK order by b.lvl desc) 
from UniqueTgtFromSrc b
join bld.vw_Dataset src on src.bk = b.BK_Source
join bld.vw_Dataset tgt on tgt.bk = b.BK_Target
left join code_changes cc on cc.code = tgt.Code
where 1=1
-- and src.LayerName != 'src'
-- Optional filters for debugging:
-- and tgt.code = 'DWH|sto|trvs|SF_Customers|Leaf|'
 --and tgt.code = 'SF|SF_API||SF|Product2|'
 --and tgt.DatasetName = '[pst].[SF_Product]'