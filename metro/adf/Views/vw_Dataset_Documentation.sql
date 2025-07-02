



CREATE view [adf].[vw_Dataset_Documentation] as 

with base as (
	SELECT 
	ds.bk_layer
	,  dd.[bk_parent] as src_bk
		  , ds.DatasetName as src_dataset
		  , ds.BK_Group as src_group
		  , dd.[bk_child] as tgt_bk
		  , dt.DatasetName as tgt_dataset
		  ,dd.[Code]
		  ,dd.[tabletypeparent]
		  ,dd.[tabletypechild]
		  ,dd.[dependencytype] 
		  , rn_code_flow =  row_number() over (partition by  ds.code  order by dt.floworder asc)
		  --, dd.*
		  --, dt.*
	FROM [bld].[vw_DatasetDependency] DD
	join bld.vw_Dataset ds on dd.[bk_parent]	= ds.BK
	left join bld.vw_Dataset dt on dd.[bk_child]	= dt.BK
	where  1=1
	--order by ds.code, dt.floworder
	--and dd.[bk_parent] = 'SRC'
	--and dt.bk_layer = 'src'
	-- and ds.DatasetName = '[stg].[TeradataFixed_WbaMain]'
	--and ds.code = 'TeradataFixed|Teradata||TeradataFixed|IB_WBA_MAIN_WS_V|'
	--and ds.DatasetName IN (SELECT dt.DatasetName FROM  [bld].[vw_DatasetDependency])
)

, Hierarchy AS (
    SELECT 
		src_dataset,
		rn_code_flow,
        src_dataset AS parent_dataset,
		src_group,
        tgt_dataset AS child_dataset,
		tgt_bk,
        1 AS level,
        CAST(src_dataset AS NVARCHAR(MAX)) AS path_trace

    FROM base
   where 1=1 
   and rn_code_flow = 1
   and bk_layer = 'src'
   --and src_dataset is not null

    UNION ALL

    SELECT 
		h.src_dataset,
		ld.rn_code_flow,
        h.child_dataset AS parent_dataset,
		h.src_group,
        ld.tgt_dataset AS child_dataset,
		ld.tgt_bk,
        h.level + 1 AS level,
        CAST(h.path_trace + ' -> ' + ld.tgt_dataset AS NVARCHAR(MAX)) AS path_trace
    FROM Hierarchy h
    INNER JOIN base ld
        ON h.child_dataset = ld.src_dataset
    WHERE h.level < 50  -- Prevent infinite loops
	
)
SELECT 
	src_dataset,
    REPLICATE('   ', level - 1) + parent_dataset AS hierarchy_view,
    child_dataset,
	--tgt_bk as child_bk,
	rn_code_flow,
	src_group,
    level,
	path_trace
	, coalesce(ds_s.[TEMPLATESCRIPT],ds.[view_defintion]) as dataset_create_script
	, coalesce(ds.[view_defintion_contains_business_logic],0) as [view_defintion_contains_business_logic]
	, coalesce(ds_p.[TEMPLATESCRIPT],'') as dataset_logistic_create_script
,ds.[isDWH]
,ds.[isSRC]
,ds.[isTGT]
,ds.[isRep]
,ds.[SchemaName]
,ds.[DataSource]
,ds.[ShortName]
,ds.[Description]
,ds.[BK_ContactGroup]
,ds.[bk_ContactGroup_Data_Logistics]
,ds.[Data_Logistics_Info]
,ds.[bk_ContactGroup_Data_Supplier]
,ds.[Data_Supplier_Info]
,ds.[BK_Flow]
,ds.[TimeStamp]
,ds.[TimeStamp_Group]
,ds.[BusinessDate]
,ds.[RecordSrcDate]
,ds.[WhereFilter]
,ds.[SCD]
,ds.[DistinctValues]
,ds.[PartitionStatement]
,ds.[BK_RefType_ObjectType]
,ds.[FullLoad]
,ds.[InsertOnly]
,ds.[InsertNoCheck]
,ds.[BigData]
,ds.[CustomStagingView]
,ds.[BK_RefType_RepositoryStatus]
,ds.[IsSystem]
,ds.[LayerName]
,ds.[BK_LinkedService]
,ds.[LinkedServiceName]
,ds.[BK_DataSource]
,ds.[BK_Layer]
,ds.[CreateDummies]
,ds.[DatasetType]
,ds.[ObjectType]
,ds.[SRC_ObjectType]
,ds.[TGT_ObjectType]
,ds.[RepositoryStatusName]
,ds.[RepositoryStatusCode]

,ds.[ToDeploy]
, env.Environment
FROM Hierarchy
 join [bld].[vw_Dataset] ds on ds.bk = tgt_bk
 left join [bld].[vw_DeployScripts] ds_s on ds.bk = ds_s.[BK_DATASET] and ds_s.[OBJECTTYPE] != 'Procedure'
 left join [bld].[vw_DeployScripts] ds_p on ds.bk = ds_p.[BK_DATASET] and ds_p.[OBJECTTYPE] = 'Procedure'
 join [adf].[vw_SDTAP]  env  on ds.RepositoryStatusCode >= env.RepositoryStatusCode

  where env.RepositoryStatusCode > -2