
CREATE view [adf].[vw_Dataset_Documentation_src_to_tgt] as 
-- Description:
-- This query constructs a hierarchical dependency tree of datasets based on their relationships.
-- It helps to analyze dataset dependencies, lineage, and flow within a data warehouse.
-- The output includes hierarchy levels, dependency paths, and dataset metadata.

WITH base AS (
    -- Extract base dataset dependencies
    SELECT 
        ds.bk_layer AS src_layer,
        dd.bk_parent AS src_bk,
        ds.DatasetName AS src_dataset,
        ds.BK_Group AS src_group,
        dt.bk_layer AS tgt_layer,
        dd.bk_child AS tgt_bk,
        dt.DatasetName AS tgt_dataset,
        dd.Code,
        dd.tabletypeparent,
        dd.tabletypechild,
        dd.dependencytype, 
        ROW_NUMBER() OVER (PARTITION BY ds.Code ORDER BY dt.floworder ASC) AS rn_code_flow
    FROM [bld].[vw_DatasetDependency] DD
    JOIN [bld].[vw_Dataset] ds ON dd.bk_parent = ds.BK
    LEFT JOIN [bld].[vw_Dataset] dt ON dd.bk_child = dt.BK
    WHERE 1 = 1
	--and ds.DatasetName = '[cds].[HIO_HIOCompletion]'
),

Hierarchy AS (
    -- Recursive CTE to build dataset hierarchy
    SELECT 
        src_dataset,
        rn_code_flow,
        src_layer, 
        src_dataset AS parent_dataset,
        src_group,
        tgt_dataset AS child_dataset,
        tgt_bk,
        tgt_layer,
        1 AS level,
        CAST(src_dataset AS NVARCHAR(MAX)) AS path_trace
    FROM base
    WHERE 1 = 1
    
    UNION ALL
    
    SELECT 
        h.src_dataset,
        ld.rn_code_flow,
        h.src_layer,
        h.child_dataset AS parent_dataset,
        h.src_group,
        ld.tgt_dataset AS child_dataset,
        ld.tgt_bk,
        ld.tgt_layer,
        h.level + 1 AS level,
        CAST(h.path_trace + ' -> ' + ld.tgt_dataset AS NVARCHAR(MAX)) AS path_trace
    FROM Hierarchy h
    INNER JOIN base ld ON h.child_dataset = ld.src_dataset
    WHERE h.level < 50  -- Prevent infinite loops in case of circular dependencies
)
--select * from Hierarchy
-- Final dataset hierarchy selection
SELECT 
    src_layer,
    src_dataset,
    REPLICATE('   ', level - 1) + parent_dataset AS hierarchy_view,
    child_dataset,
    tgt_layer AS child_layer,
    rn_code_flow,
    src_group,
    level,
    path_trace,
    COALESCE(ds_s.TEMPLATESCRIPT, ds.view_defintion) AS dataset_create_script,
    COALESCE(ds.view_defintion_contains_business_logic, 0) AS view_defintion_contains_business_logic,
    COALESCE(ds_p.TEMPLATESCRIPT, '') AS dataset_logistic_create_script,
    ds.isDWH,
    ds.isSRC,
    ds.isTGT,
    ds.isRep,
    ds.SchemaName,
    ds.DataSource,
    ds.ShortName,
    ds.Description,
    ds.BK_ContactGroup,
    ds.bk_ContactGroup_Data_Logistics,
    ds.Data_Logistics_Info,
    ds.bk_ContactGroup_Data_Supplier,
    ds.Data_Supplier_Info,
    ds.BK_Flow,
    ds.TimeStamp,
    ds.TimeStamp_Group,
    ds.BusinessDate,
    ds.RecordSrcDate,
    ds.WhereFilter,
    ds.SCD,
    ds.DistinctValues,
    ds.PartitionStatement,
    ds.BK_RefType_ObjectType,
    ds.FullLoad,
    ds.InsertOnly,
    ds.InsertNoCheck,
    ds.BigData,
    ds.CustomStagingView,
    ds.BK_RefType_RepositoryStatus,
    ds.IsSystem,
    ds.LayerName,
    ds.BK_LinkedService,
    ds.LinkedServiceName,
    ds.BK_DataSource,
    ds.BK_Layer,
    ds.CreateDummies,
    ds.DatasetType,
    ds.ObjectType,
    ds.SRC_ObjectType,
    ds.TGT_ObjectType,
    ds.RepositoryStatusName,
    ds.RepositoryStatusCode,
    ds.ToDeploy
	, env.Environment
FROM Hierarchy

 JOIN [bld].[vw_Dataset] ds ON ds.bk = Hierarchy.tgt_bk
LEFT JOIN [bld].[vw_DeployScripts] ds_s ON ds.bk = ds_s.BK_DATASET AND ds_s.OBJECTTYPE != 'Procedure'
LEFT JOIN [bld].[vw_DeployScripts] ds_p ON ds.bk = ds_p.BK_DATASET AND ds_p.OBJECTTYPE = 'Procedure'
 join [adf].[vw_SDTAP]  env  on ds.RepositoryStatusCode >= env.RepositoryStatusCode
where env.RepositoryStatusCode > -2