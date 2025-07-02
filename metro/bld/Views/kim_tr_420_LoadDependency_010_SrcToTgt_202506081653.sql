
create VIEW [bld].[kim_tr_420_LoadDependency_010_SrcToTgt_202506081653] AS
/* 
=== Comments =========================================

Description:
    Get all source dependencies for one target.

Columns:
    - bk_source: The business key of the source dataset.
    - bk_target: The business key of the target dataset.
    - bk_targetclean: The cleaned business key of the target dataset.
    - bk_sourceclean: The cleaned business key of the source dataset.
    - dependencytype: The type of the dependency (SrcToTgt).

Example Usage:
    SELECT * FROM [bld].[tr_420_LoadDependency_010_SrcToTgt]

Logic:
    1. Retrieves the full list of dependencies.
    2. Cleans the business keys to make views look like tables.
    3. Joins the cleaned business keys to get the final dependencies.

Source Data:
    - [bld].[vw_DatasetDependency]: Contains dataset dependencies.
    - [bld].[vw_Dataset]: Contains dataset definitions.
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20240424	1430		K. Vermeij				Added DependencyType
20240424	1730		K. Vermeij				Removed filter "and src.LayerName != 'src'"
=======================================================
*/
  with code_changes as (
		select 
			distinct code, rectype
		from [bld].[vw_LoadDependencySmartLoad]
		where isnull(rectype,0) > -99
		)
, base AS (
	 -- get the full list of dependencies
	SELECT 
			   bk_source		= dd.bk_parent
			 , bk_target		= dd.bk_child

			 -- make the views look like tables (remove prefix and postfix)
			 , bk_targetclean	= concat(tgt.bk_schema,'||',tgt.bk_group, '|', tgt.shortname, '|')
			 , bk_sourceclean	= concat(src.bk_schema,'||',src.bk_group, '|', src.shortname, '|')
			 , dependencytype	= dd.dependencytype
	FROM bld.vw_datasetdependency dd
	JOIN bld.vw_dataset src ON src.bk = dd.bk_child
	left join code_changes cc_src on cc_src.code = src.code
	JOIN bld.vw_dataset tgt ON tgt.bk = dd.bk_parent
	left join code_changes cc_tgt on cc_tgt.code = tgt.code
	WHERE 1=1
	AND dependencytype = 'SrcToTgt'
	and (cc_src.code is not null or cc_tgt.code is not null)
	)
, rebase AS (
	-- join the "cleaned" businesskeys
	SELECT distinct
		  bk_target			= tgt.bk
		, bk_source			= src.bk
		, dependencytype	= b.dependencytype
		
	FROM base b
	JOIN bld.vw_dataset src ON src.bk = b.bk_sourceclean
	JOIN bld.vw_dataset tgt ON tgt.bk = b.bk_targetclean
	WHERE src.bk <> tgt.bk

	)
--select bk_target, bk_source
--from rebase
--group by bk_target, bk_source
--having count(1) >1



, tgtfromsrc

AS
  ( 
	SELECT bk_target bk_target, bk_source, 1 AS lvl, dependencytype
	FROM rebase

	UNION ALL
    
	SELECT d.bk_target, s.bk_source, d.lvl + 1 AS lvl, d.dependencytype
    FROM tgtfromsrc d
    JOIN rebase		s ON d.bk_source = s.bk_target
  ) 

, uniquetgtfromsrc AS (
	SELECT  
		bk_target, bk_source, max(lvl) lvl, dependencytype
	FROM tgtfromsrc 
	GROUP BY bk_target, bk_source, dependencytype
	
	-- add parents as source
	UNION ALL
	SELECT DISTINCT src.bk_target bk_target, src.bk_target bk_source, -100 AS lvl, dependencytype
	FROM tgtfromsrc src
	WHERE 1=1 AND src.lvl = 1

	

), final AS (
SELECT distinct
	  bk				= b.dependencytype+'|'+tgt.bk+'|'+src.bk
	, code				= tgt.code
	, bk_target			= tgt.bk
	, tgt_layer			= tgt.layername	
	, tgt_schema		= tgt.schemaname
	, tgt_group			= tgt.bk_group
	, tgt_shortname		= tgt.shortname
	, tgt_code			= tgt.code
	, tgt_datasetname	= tgt.datasetname

	, bk_source			= src.bk
	, src_layer			= src.layername	
	, src_schema		= src.schemaname
	, src_group			= src.bk_group
	, src_shortname		= src.shortname
	, src_code			= src.code
	, src_datasetname	= src.datasetname
	, dependencytype	= b.dependencytype
	, lvl				= b.lvl
	, mta_rectype		= coalesce(cc_src.rectype, cc_tgt.rectype,0)
FROM uniquetgtfromsrc b
JOIN bld.vw_dataset src ON src.bk = b.bk_source
left join code_changes cc_src on cc_src.code = src.code
JOIN bld.vw_dataset tgt ON tgt.bk = b.bk_target
left join code_changes cc_tgt on cc_tgt.code = tgt.code

 WHERE 1=1

 )
 SELECT *
 , generation_number	= ROW_NUMBER() OVER (PARTITION BY  bk_target ORDER BY lvl ASC) 
 FROM final