
CREATE VIEW [bld].[tr_400_DatasetDependency_010_SrcToTgt] AS
/* 
=== Comments =========================================

Description:
    This view builds up dataset dependencies from source to target. It identifies the parent-child relationships between datasets and their dependencies.

Columns:
    - bk: The business key of the dependency.
    - bk_parent: The business key of the parent dataset.
    - bk_child: The business key of the child dataset.
    - code: The code of the dataset.
    - tabletypeparent: The type of the parent dataset.
    - tabletypechild: The type of the child dataset.
    - dependencytype: The type of the dependency (SrcToTgt).

Example Usage:
    SELECT * FROM [bld].[tr_400_DatasetDependency_010_SrcToTgt]

Logic:
    1. Selects base dataset dependencies.
    2. Recursively builds the hierarchy of dependencies.
    3. Selects and formats the final dataset dependencies.

Source Data:
    - [rep].[vw_Dataset]: Contains dataset definitions.
    - [rep].[vw_RefType]: Contains reference types used in the data warehouse.
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/
WITH base AS 
	(
	SELECT 
		  d.[BK]
		, d.[Code]

		, d.[DatasetName]
      
		, [FlowOrder]					= CAST(d.[FlowOrder] AS int)
		, [DependencyOrder]				= CAST(RANK() OVER (PARTITION BY d.[Code]  ORDER BY CAST(d.[FlowOrder] AS int) ASC) AS int)
		--, [DependencyOrder]				= cast(dense_RANK() over (partition by d.[Code]  order by cast(d.[FlowOrder] as int) asc) as int)
		, d.[BK_RefType_ObjectType]
		, d.[BK_RefType_RepositoryStatus]
		
		, d.[mta_BKH]
      
	  FROM [bld].[vw_Dataset] d
	WHERE 1=1
	--and d.code = 'BI|Base||IB|AggregatedPc4|'
	--and d.bk = 'DWH|stg||IB|AggregatedPc4|'
	--and d.code = 'DWH|aud_dim|trvs|monitor|schedule|'
	--and d.bk = 'DWH|csl|dim_vw|monitor|schedule|'
	--  and d.code  = 'BI|Base||IB|AggregatedPc4|'
	  --and d.[BK_RefType_TableType] != 'OT|V|View'
	  
	  )
,  hierarchie AS (
	-- 
	SELECT 
		
		  bk_child			= CAST('SRC' AS varchar(255))
		, bk_parent			= p.[BK] 
		, code				= p.code
		, tabletypechild	= CAST('SRC' AS varchar(255))
		, tabletypeparent	= p.[BK_RefType_ObjectType]
		, p.[DependencyOrder] 
		
	FROM base p
	WHERE [DependencyOrder] = 1
	UNION ALL

	SELECT 
		   
		bk_child			= p.bk_parent
		, bk_parent			= c.bk
		, code				= c.code
		, tabletypesource	= p.tabletypeparent
		, tabletypeparent	= c.[BK_RefType_ObjectType]
		, c.[DependencyOrder]
	FROM base c
	JOIN hierarchie p ON c.code = p.code
					
					AND c.[DependencyOrder] = p.[DependencyOrder] +1
	)
	--select * from Hierarchie
SELECT 
	bk			= h.bk_child+'|'+bk_parent
	
	, bk_parent	 = bk_child
	, bk_child	 = bk_parent
	, [Code]
	, tabletypeparent = tabletypechild
	, tabletypechild = tabletypeparent

	
	, dependencytype = 'SrcToTgt'

FROM hierarchie h