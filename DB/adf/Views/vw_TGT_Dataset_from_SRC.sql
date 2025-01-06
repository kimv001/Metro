






CREATE view [adf].[vw_TGT_Dataset_from_SRC] as
With base as (
	Select 
		  TGT				= src.TGT_DatasetName
		, TGT_BK_Dataset	= src.BK_Target	
		, TGT_Group
		, TGT_Schema
		, TGT_Layer
		, TGT_DWH			= 'All'
		, SRC_BK_DataSet	= src.BK_Source
		, SRC_DataSet		= src.SRC_DatasetName
		, SRC_ShortName
		, SRC_Group
		, SRC_Schema
		, SRC_Layer
		, DependencyType  
		,[generation_number]
	From bld.vw_LoadDependency src
	where DependencyType = 'TgtFromSrc'
	  
)

select distinct 
	  TGT_Dataset				= b.TGT
	, TGT_BK_Dataset			= b.TGT_BK_Dataset
	, TGT						= b.TGT
	, TGT_Group
	, TGT_Schema
	, TGT_Layer
	, SRC_BK_DataSet			= b.SRC_BK_DataSet
	, SRC_DataSet				= b.SRC_DataSet
	, SRC_ShortName				= b.SRC_ShortName
	, SRC_Group					= b.SRC_Group
	, SRC_Schema				= b.SRC_Schema
	, SRC_Layer					= b.SRC_Layer
	, SRC_SourceName			= b.SRC_Group + '_' + iif(b.SRC_Schema = 'stg',d.SRC_ShortName, b.SRC_ShortName)
	, SRC_DatasetType			= D.SRC_ObjectType
	, TGT_DatasetType			= D.TGT_ObjectType
	, generation_number			= b.Generation_Number
	, DependencyType			= 'Dataset'
	, RepositoryStatusName		= d.RepositoryStatusName
	, RepositoryStatusCode		= d.RepositoryStatusCode
from base b
join bld.vw_Dataset d on b.SRC_BK_DataSet = d.BK