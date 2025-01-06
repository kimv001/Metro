
CREATE VIEW adf.vw_datasetattribute AS
SELECT [attribute_id] = src.[attributeid],

       [bk_attribute] = src.[bk],

       [code] = src.[code],

       [bk_dataset] = src.[bk_dataset],

       [dataset] = src.[dataset],

       [bk_objecttype] = src.[bk_reftype_objecttype],

       [dataset_attribute_name] = src.[name],

       [expression] = src.[expression],

       [attribute_name_in_source] = src.[srcname],

       [attribute_name] = src.[attributename],

       [attribute_description] = src.[description],

       [distributionhashkey] = src.[distributionhashkey],

       [notinrh] = src.[notinrh],

       [businesskey] = src.[businesskey],

       [ismta] = src.[ismta],

       [data_type] = src.[datatype],

       [is_nullable] = src.[isnullable],

       [ordinal_position] = src.[ordinalposition],

       [maximum_length] = src.[maximumlength],

       [precision] = src.[precision],

       [scale] = src.[scale],

       [collation] = src.[collation],

       [ddl_type1] = src.[ddl_type1],

       [ddl_type2] = src.[ddl_type2],

       [ddl_type3] = src.[ddl_type3],

       [ddl_type4] = src.[ddl_type4],

       [default_value] = src.[defaultvalue],

       [active] = src.[active],

       [bk_reftype_repositorystatus] = src.[bk_reftype_repositorystatus],

       [repositorystatusname] = rt.[name],

       [repositorystatuscode] = rt.[code],

       [mta_rectype] = src.[mta_rectype],

       [mta_createdate] = src.[mta_createdate],

       [mta_source] = src.[mta_source],

       [mta_bk] = src.[mta_bk],

       [mta_bkh] = src.[mta_bkh],

       [mta_rh] = src.[mta_rh],

       [environment] = env.environment -- not relevant
 --,[FlowOrder]
 --,[bk_reftype_datatype]			= src.[BK_RefType_DataType]
 --,[FixedSchemaDataType]
 --,[OrgMappedDataType]

  FROM [bld].[vw_attribute] src

  JOIN bld.vw_reftype rt
    ON rt.bk = src.[bk_reftype_repositorystatus]

 CROSS JOIN [adf].[vw_sdtap] env

 WHERE 1 = 1 --   and isnull(src.[Expression],'') != ''
--  and src.[SrcName] != [attributename]
