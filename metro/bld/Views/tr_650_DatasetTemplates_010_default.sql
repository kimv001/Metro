







CREATE view [bld].[tr_650_DatasetTemplates_010_default] as
With AllDefaultTemplates as (
	Select 
		  BK_Template		= D.[BK_Template_Create]
		  , D.BK
		  , D.Code
		  , TemplateType	= 'Create'
		  , TemplateSource	= 'Dataset'
		  , TemplateOrder	= 1
		  , T.BK_RefType_ObjectType
		  , TemplateScript	= T.Script
	From bld.vw_Dataset			D
	join bld.vw_Template		T on T.bk	 = D.BK_Template_Create
									and D.BK_RefType_ObjectType = t.BK_RefType_ObjectType
	where 1=1
	

	union all
	
	Select 
		  BK_Template		= FL.BK_Template_create
		  , D.BK
		  , D.Code
		  , TemplateType	= 'Create'
		  , TemplateSource	= 'FlowLayer'
		  , TemplateOrder	= 2
		  , T.BK_RefType_ObjectType
		  , TemplateScript	= T.Script
	From bld.vw_Dataset			D
	join bld.vw_Schema			S	on s.BK				= d.BK_Schema
	join rep.vw_FlowLayer		FL	on FL.BK_Flow		= D.BK_Flow and ((FL.BK_Layer = s.BK_Layer and fl.BK_Schema = d.BK_Schema) OR (FL.BK_Layer = s.BK_Layer and fl.BK_Schema is null))
	join bld.vw_Template		T	on T.bk				= FL.BK_Template_create 
									and d.[BK_RefType_ObjectType]= t.BK_RefType_ObjectType
	where 1=1

	union all 

		Select 
		  BK_Template		=S.BK_Template_Create
		  , D.BK
		  , D.Code

		  , TemplateType	= 'Create'
		  , TemplateSource	= 'Schema'
		  , TemplateOrder	= 3
		  , T.BK_RefType_ObjectType
		  , TemplateScript	= T.Script
		 -- ,D.BK_RefType_ObjectType , t.BK_RefType_ObjectType
		 
	From bld.vw_Dataset			D
	join bld.vw_Schema			S	on S.BK		= D.BK_Schema
	join bld.vw_Template		T	on T.bk		= S.BK_Template_Create
									and D.BK_RefType_ObjectType = t.BK_RefType_ObjectType
								
	where 1=1
	and d.BK <> d.Code -- Source Datasets and Transformation Views must not be (re)created
	

	
	union all
	
		Select 
		  BK_Template		= D.[BK_Template_Load]
		  , D.BK
		  , D.Code
		  , TemplateType	= 'Load'
		  , TemplateSource	= 'Dataset'
		  , TemplateOrder	= 1
		  , T.BK_RefType_ObjectType
		  , TemplateScript	= T.Script
	From bld.vw_Dataset			D
	join bld.vw_Template		T on T.bk	 = D.[BK_Template_Load] 
									and D.BK_RefType_ObjectType = t.BK_RefType_ObjectType_BasedOn
									-- and d.[BK_RefType_ObjectType]= 'OT|T|Table'
	where 1=1


	union all 

		Select 
		  BK_Template		= FL.BK_Template_Load
		  , D.BK
		  , D.Code
		  , TemplateType	= 'Load'
		  , TemplateSource	= 'FlowLayer'
		  , TemplateOrder	= 2
		  , T.BK_RefType_ObjectType
		  , TemplateScript	= T.Script
	From bld.vw_Dataset			D
	join bld.vw_Schema			S	on s.BK				= d.BK_Schema
	join rep.vw_FlowLayer		FL	on FL.BK_Flow		= D.BK_Flow and ((FL.BK_Layer = s.BK_Layer and fl.BK_Schema = d.BK_Schema) OR (FL.BK_Layer = s.BK_Layer and fl.BK_Schema is null))
	join bld.vw_Template		T	on T.bk				= FL.BK_Template_Load 
									and d.[BK_RefType_ObjectType]= 'OT|T|Table'
	where 1=1

	union all 

		Select 
		  BK_Template		= S.BK_Template_Load
		  , D.BK
		  , D.Code
		  , TemplateType	= 'Load'
		  , TemplateSource	= 'Schema'
		  , TemplateOrder	= 3
		  , T.BK_RefType_ObjectType
		  , TemplateScript	= T.Script
	From bld.vw_Dataset			D
	join bld.vw_Schema			S	on S.BK		= D.BK_Schema
	join bld.vw_Template		T	on T.bk	 = S.BK_Template_Load and d.[BK_RefType_ObjectType]= 'OT|T|Table'
	where 1=1



	)
, TemplateOrder as (
select 
	BK						= src.BK_Template+'|'+src.BK
	, Code					= src.Code
	, BK_Template			= src.BK_Template
	, BK_Dataset			= src.BK
	, TemplateType			= src.TemplateType
	, TemplateSource		= src.TemplateSource
	, BK_RefType_ObjectType	= src.BK_RefType_ObjectType
	, TemplateScript		= src.TemplateScript
	, RowNum				= ROW_NUMBER() over (partition by src.TemplateType+'|'+src.BK order by TemplateOrder asc)
	--, RowNum				= ROW_NUMBER() over (partition by BK_Template+'|'+src.BK order by TemplateOrder asc)
from AllDefaultTemplates src
)
Select
	BK
	, Code
	, BK_Template
	, BK_Dataset
	, TemplateType
	, TemplateSource
	, BK_RefType_ObjectType
	, TemplateScript			= case 
									when right(BK_Dataset, 6) = 'custom' then '/* User defined view on the database, no deployment desirable. */'
									
									 else TemplateScript
									 end
	, RowNum
From TemplateOrder
Where 1=1
 and RowNum = 1
 --and code = 'SF|SF_API||SF|Netcode__c|'
  --and code = 'DWH|dim|trvs_|Wes|LocationType|'
  --order by 4,1

--and BK_Dataset = 'DWH|stg|vw_|REF|Addresses|Custom'