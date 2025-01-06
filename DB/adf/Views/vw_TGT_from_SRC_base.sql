







CREATE  view [adf].[vw_TGT_from_SRC_base] as


with  TGT as (
	select [TGT] , SRC_BK_DataSet, SRC_Dataset, [SRC_ShortName],SRC_Group, SRC_Schema, SRC_Layer, SRC_SourceName, SRC_DatasetType, TGT_DatasetType, generation_number, DependencyType, [RepositoryStatusName], [RepositoryStatusCode] from [adf].[vw_TGT_DWH_from_SRC]					union all																									
	select [TGT] , SRC_BK_DataSet, SRC_Dataset, [SRC_ShortName],SRC_Group, SRC_Schema, SRC_Layer, SRC_SourceName, SRC_DatasetType, TGT_DatasetType, generation_number, DependencyType, [RepositoryStatusName], [RepositoryStatusCode] from [adf].[vw_TGT_Layer_from_SRC]				union all																									
	select [TGT] , SRC_BK_DataSet, SRC_Dataset, [SRC_ShortName],SRC_Group, SRC_Schema, SRC_Layer, SRC_SourceName, SRC_DatasetType, TGT_DatasetType, generation_number, DependencyType, [RepositoryStatusName], [RepositoryStatusCode] from [adf].[vw_TGT_LayerGroup_from_SRC]			union all	
	select [TGT] , SRC_BK_DataSet, SRC_Dataset, [SRC_ShortName],SRC_Group, SRC_Schema, SRC_Layer, SRC_SourceName, SRC_DatasetType, TGT_DatasetType, generation_number, DependencyType, [RepositoryStatusName], [RepositoryStatusCode] from [adf].[vw_TGT_Schema_from_SRC]				union all		
	select [TGT] , SRC_BK_DataSet, SRC_Dataset, [SRC_ShortName],SRC_Group, SRC_Schema, SRC_Layer, SRC_SourceName, SRC_DatasetType, TGT_DatasetType, generation_number, DependencyType, [RepositoryStatusName], [RepositoryStatusCode] from [adf].[vw_TGT_Group_from_SRC]				union all																									
	select [TGT] , SRC_BK_DataSet, SRC_Dataset, [SRC_ShortName],SRC_Group, SRC_Schema, SRC_Layer, SRC_SourceName, SRC_DatasetType, TGT_DatasetType, generation_number, DependencyType, [RepositoryStatusName], [RepositoryStatusCode] from [adf].[vw_TGT_Dataset_from_SRC]				union all
	select [TGT] , SRC_BK_DataSet, SRC_Dataset, [SRC_ShortName],SRC_Group, SRC_Schema, SRC_Layer, SRC_SourceName, SRC_DatasetType, TGT_DatasetType, generation_number, DependencyType, [RepositoryStatusName], [RepositoryStatusCode] from [adf].[vw_TGT_ShortNameGroup_from_SRC]		union all
	select [TGT] , SRC_BK_DataSet, SRC_Dataset, [SRC_ShortName],SRC_Group, SRC_Schema, SRC_Layer, SRC_SourceName, SRC_DatasetType, TGT_DatasetType, generation_number, DependencyType, [RepositoryStatusName], [RepositoryStatusCode] from [adf].[vw_TGT_ShortNameGroupLayer_from_SRC]	union all
	select [TGT] , SRC_BK_DataSet, SRC_Dataset, [SRC_ShortName],SRC_Group, SRC_Schema, SRC_Layer, SRC_SourceName, SRC_DatasetType, TGT_DatasetType, generation_number, DependencyType, [RepositoryStatusName], [RepositoryStatusCode] from [adf].[vw_TGT_Export_from_SRC]				union all
	select [TGT] , SRC_BK_DataSet, SRC_Dataset, [SRC_ShortName],SRC_Group, SRC_Schema, SRC_Layer, SRC_SourceName, SRC_DatasetType, TGT_DatasetType, generation_number, DependencyType, [RepositoryStatusName], [RepositoryStatusCode] from [adf].[vw_TGT_GroupSRCLayer_from_SRC]

	
)

select 
	  TGT.[TGT]
	, TGT.SRC_BK_DataSet
	, TGT.SRC_Dataset
	, TGT.[SRC_ShortName]
	, TGT.SRC_Group
	, TGT.SRC_Schema
	, TGT.SRC_Layer
	, TGT.SRC_SourceName as [Source]
	, TGT.SRC_DatasetType
	, TGT.TGT_DatasetType
	, TGT.generation_number
	, TGT.DependencyType
	, TGT.[RepositoryStatusName]
	, TGT.[RepositoryStatusCode]
	, env.Environment
	
from  TGT 
Cross join [adf].[vw_SDTAP]  env
--where TGT.SRC_Layer != 'src' -- sources are no entities from where actions are triggered on in ADF
--and env.Environment = 'PRD' -- 4387