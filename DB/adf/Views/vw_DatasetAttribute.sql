 CREATE view adf.vw_DatasetAttribute as 

select
	 [attribute_id]					= src.[AttributeId]
	,[bk_attribute]					= src.[BK]
	,[code]							= src.[Code]
	
	,[bk_dataset]					= src.[BK_Dataset]
	,[dataset]						= src.[Dataset]
	,[bk_objecttype]				= src.[BK_RefType_ObjectType]
	
	,[dataset_attribute_name]		= src.[Name]
	,[expression]					= src.[Expression]
	,[attribute_name_in_source]		= src.[SrcName]
	,[attribute_name]				= src.[AttributeName]
	,[attribute_description]		= src.[Description]
	
	,[distributionhashkey]			= src.[DistributionHashKey]
	,[notinrh]						= src.[NotInRH]
	,[businesskey]					= src.[BusinessKey]
	,[ismta]						= src.[isMta]
	
	
	,[data_type]					= src.[DataType]
	,[is_nullable]					= src.[Isnullable]
	,[ordinal_position]				= src.[OrdinalPosition]
	,[maximum_length]				= src.[MaximumLength]
	,[precision]					= src.[Precision]
	,[scale]						= src.[Scale]
	,[collation]					= src.[Collation]
	,[ddl_type1]					= src.[DDL_Type1]
	,[ddl_type2]					= src.[DDL_Type2]
	,[ddl_type3]					= src.[DDL_Type3]
	,[ddl_type4]					= src.[DDL_Type4]
	,[default_value]				= src.[DefaultValue]
	
	,[active]						= src.[Active]
	
	,[bk_reftype_repositorystatus]	= src.[BK_RefType_RepositoryStatus]
	,[RepositoryStatusName]			= rt.[name]
	,[RepositoryStatusCode]			= rt.[code]


	,[mta_RecType]					= src.[mta_RecType]
	,[mta_CreateDate]				= src.[mta_CreateDate]
	,[mta_Source]					= src.[mta_Source]
	,[mta_BK]						= src.[mta_BK]
	,[mta_BKH]						= src.[mta_BKH]
	,[mta_RH]						= src.[mta_RH]
	,[environment]					= env.Environment
	-- not relevant
	--,[FlowOrder]
	--,[bk_reftype_datatype]			= src.[BK_RefType_DataType]
	--,[FixedSchemaDataType]
	--,[OrgMappedDataType]

from [bld].[vw_Attribute] src
join bld.vw_RefType rt on rt.bk = src.[BK_RefType_RepositoryStatus]
Cross join [adf].[vw_SDTAP]  env
where 1=1
--   and isnull(src.[Expression],'') != ''
--  and src.[SrcName] != [attributename]