





CREATE VIEW [adf].[vw_Dataset] AS
SELECT 

	 src.BK
	,src.Code
	,src.DatasetName AS DatasetName_old
	, CASE WHEN src.LayerName = 'src' THEN concat('[',src.SchemaName,'].[',src.BK_Group,'_',SRC_ShortName,']') ELSE src.DatasetName END AS DatasetName
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
	,src.[Description] AS dataset_description
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
  FROM bld.vw_Dataset src
  CROSS JOIN [adf].[vw_SDTAP]  env
  LEFT JOIN bld.vw_FileProperties FP ON FP.bk = src.bk 
	--where datasetname = '[sto].[FactMomsMdf]' 