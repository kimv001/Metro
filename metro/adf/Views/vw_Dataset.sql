




CREATE view [adf].[vw_Dataset] as
with deploy_scripts as (
 select bk_dataset, TEMPLATESCRIPT 
   , row_number() over (partition by bk_dataset order by mta_createdate desc) as rn   
   from  bld.vw_DeployScripts 
   )
SELECT 
	 src.BK
	,src.Code
	,src.DatasetName as DatasetName_old
	, case when src.LayerName = 'src' then concat('[',src.SchemaName,'].[',src.BK_Group,'_',SRC_ShortName,']') else src.DatasetName end as DatasetName
	,src.SchemaName
	,src.LayerName
	,src.DataSource
	,src.BK_LinkedService
	,src.LinkedServiceName
	,src.BK_DataSource
	,src.BK_Layer
	,src.BK_Schema
	,src.BK_Group
	,src.ShortName
	,src.SRC_ShortName
	,src.SRC_ObjectType
	,src.dwhTargetShortName
	,src.Prefix
	,src.PostFix
	,src.[Description]
	,src.[Description] as dataset_description
	,src.[bk_ContactGroup]
	,src.[bk_ContactGroup_Data_Logistics]
    ,src.[Data_Logistics_Info]
    ,src.[bk_ContactGroup_Data_Supplier]
    ,src.[Data_Supplier_Info]
	,src.[view_defintion_contains_business_logic]
    ,src.[view_defintion]
	,src.BK_Flow
	,src.FlowOrder
	,src.[TimeStamp]
	,src.BusinessDate
	,src.WhereFilter
	,src.PartitionStatement
	,src.BK_RefType_ObjectType
	,src.FullLoad
	,src.InsertOnly
	,src.BigData
	,src.BK_Template_Load
	,src.BK_Template_Create
	,src.CustomStagingView
	,src.BK_RefType_RepositoryStatus
	,src.IsSystem
	,src.FirstDefaultDWHView
	,src.ReplaceAttributeNames
	,src.DatasetType
	,src.ObjectType
	,src.RepositoryStatusName
	,src.RepositoryStatusCode
	,src.isDWH
	,src.isSRC
	,src.isTGT
	-- filesource properties
	,fp.[FileMask]
    ,fp.[Filename]
    ,fp.[FileSystem]
    ,fp.[Folder]
    ,fp.[isPGP]
	,fp.ExpectedFileCount
    ,fp.[ExpectedFileSize]
    ,fp.[bk_schedule_FileExpected]
    ,fp.[DateInFileNameFormat]
    ,fp.[DateinFileNameLength]
    ,fp.[DateInFileNameStartPos]
    ,fp.[DateInFileNameExpression]

	-- meta data
	,src.mta_RecType
	,src.mta_CreateDate
	,src.mta_Source
	,src.mta_BK
	,src.mta_BKH
	,src.mta_RH
	,src.mta_IsDeleted
	, env.Environment
	, (
        SELECT '[' + STRING_AGG('{"view_definition":"' + REPLACE([view_defintion], '"', '\"') + '"}', ',') + ']' 
        FROM bld.[vw_Dataset] T 
        WHERE T.[BK] = src.[BK]
    ) AS JsonScript
	,
	CAST(
    CAST(
        REPLACE(
            REPLACE(
                REPLACE(
                    [view_defintion], '&', '&amp;'
                ), '<', '&lt;'
            ), '>', '&gt;'
        ) AS XML
    ) AS NVARCHAR(MAX)
) AS xml_script,
deploy_script = ds.TEMPLATESCRIPT

	
  FROM bld.vw_Dataset src
  join [adf].[vw_SDTAP]  env  on src.RepositoryStatusCode >= env.[RepositoryStatusCode]
  left join bld.vw_FileProperties FP on FP.bk = src.bk 
  left join deploy_scripts ds on ds.bk_dataset = src.BK and ds.rn = 1
  where env.RepositoryStatusCode > -2
 -- and src.code = 'DWH|dim|trvs|Mobile|2GSunset|'
 -- and env.Environment = 'PRD'