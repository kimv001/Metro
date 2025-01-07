CREATE VIEW [adf].[vw_TGT_from_SRC] AS
WITH base AS (
SELECT
	TGT 
	, SRC_BK_DataSet
	, SRC_Dataset
	, SRC_ShortName
	, SRC_Group
	, SRC_Schema
	, SRC_Layer
	, [Source]
	, SRC_DatasetType
	, TGT_DatasetType
	, generation_number
	, DependencyType
	, RepositoryStatusName
	, RepositoryStatusCode
	, Environment
FROM [adf].[vw_TGT_from_SRC_base]

UNION ALL 

SELECT
	TGT 
	, SRC_BK_DataSet
	, SRC_Dataset
	, SRC_ShortName
	, SRC_Group
	, SRC_Schema
	, SRC_Layer
	, [Source]
	, SRC_DatasetType
	, TGT_DatasetType
	, generation_number
	, DependencyType
	, RepositoryStatusName
	, RepositoryStatusCode
	, Environment
FROM [adf].[vw_TGT_from_SRC_schedules]
), final AS (
SELECT
	
	TGT							= CAST(src.TGT					AS varchar(1000))
	, SRC_BK_DataSet			= CAST(src.SRC_BK_DataSet		AS varchar(255))
	, SRC_Dataset				= CAST(src.SRC_Dataset			AS varchar(255))
	, SRC_ShortName				= CAST(src.SRC_ShortName		AS varchar(255))
	, SRC_Group					= CAST(src.SRC_Group			AS varchar(255))
	, SRC_Schema				= CAST(src.SRC_Schema			AS varchar(255))
	, SRC_Layer					= CAST(src.SRC_Layer			AS varchar(255))
	, [Source]					= CAST(src.[Source]				AS varchar(1000))
	, SRC_DatasetType			= CAST(src.SRC_DatasetType		AS varchar(255))
	, TGT_DatasetType			= CAST(src.TGT_DatasetType		AS varchar(255))
	, generation_number_old			= CAST(src.generation_number	AS bigint)
	, generation_number				= CAST(
									CASE 
										WHEN s.ProcessParallel = 1 THEN concat(d.FlowOrder,'00000') 
										ELSE concat(d.FlowOrder,  RIGHT('00000'+CAST(src.generation_number AS varchar),5))
									END
									AS bigint)

	, ProcessParallel			= CAST(s.ProcessParallel		AS varchar(255))
	, DependencyType			= CAST(src.DependencyType		AS varchar(255))
	, RepositoryStatusName		= CAST(src.RepositoryStatusName	AS varchar(255))
	, RepositoryStatusCode		= CAST(src.RepositoryStatusCode	AS varchar(255))
	, Environment				= CAST(src.Environment			AS varchar(255))
FROM base src
LEFT JOIN bld.vw_dataset	d ON src.SRC_BK_DataSet = d.BK
LEFT JOIN bld.vw_schema		s ON d.bk_schema = s.bk


)
SELECT * FROM final
WHERE 1=1
--and Environment = 'prd'
--and TGT = '[fct].[IB_ODF_monthly]'
--and TGT = '[fct].[IB_WEAS]'
--and TGT = '[dim].[Common_CustomerProduct]'
--and TGT = ' Percentiel-WAP-pub]'
--order by cast(d.FlowOrder as int) desc
--order by JobOrder desc
--order by JobOrder desc