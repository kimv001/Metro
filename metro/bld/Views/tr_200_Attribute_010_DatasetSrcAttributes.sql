
CREATE VIEW [bld].[tr_200_attribute_010_datasetsrcattributes] AS /*
=== Comments =========================================

Description:
	Get all attributes for Source Datasets

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230301	0845		K. Vermeij				Made a case statement if maximum length = '-1'
=======================================================
*/ WITH prep AS

        (SELECT [bk] ,

               [code] ,

               [name] ,

               [datasetsrc] ,

               [attributename] ,

               [bk_datasetsrc] ,

               [description] ,

               [active] ,

               [distributionhashkey] ,

               [expression] ,

               [dwhname] ,

               [notinrh] ,

               [businesskey] ,

               [defaultvalue] ,

               [srcname] ,

               [bk_reftype_datatype] ,

               try_cast(replace([isnullable], ' ', '') AS int) AS [isnullable] ,

               try_cast(replace([ordinalposition], ' ', '') AS int) AS [ordinalposition] --,try_cast(replace([MaximumLength],' ','')  as int) as [MaximumLength]
 ,

               [maximumlength] ,

               try_cast(replace([precision], ' ', '') AS int) AS [precision] ,

               try_cast(replace([scale], ' ', '') AS int) AS [scale] ,

               [collation] ,

               [mta_rownum] ,

               [mta_bk] ,

               [mta_bkh] ,

               [mta_rh] ,

               [mta_source] ,

               [mta_loaddate]

          FROM [rep].[vw_datasetsrcattribute]
       ) ,

       base AS

        (SELECT bk = concat(d.[bk], '|', src.[attributename]) ,

               [code] = src.[bk_datasetsrc] ,

               [name] = d.datasetname + '.[' + src.[attributename] + ']' ,

               [bk_dataset] = d.bk ,

               [dataset] = d.datasetname ,

               src.[attributename] ,

               src.[description] ,

               src.[expression] ,

               src.[distributionhashkey] ,

               [notinrh] = isnull(src.[notinrh], 0) ,

               [businesskey] = cast(isnull(iif(ltrim(rtrim(src.[businesskey])) = '', NULL, ltrim(rtrim(src.[businesskey]))) , 0) AS varchar(3)) ,

               src.[srcname] ,

               src.[bk_reftype_datatype] ,

               datatype = dtm.datatypemapped ,

               fixedschemadatatype = cast(dtm.fixedschemadatatype AS varchar(1)) ,

               orgmappeddatatype = dtm.orgmappeddatatype ,

               [isnullable] = cast(isnull(iif(dtm.fixedschemadatatype = 1, 1, src.[isnullable]), 1) AS varchar(1)) ,

               [ordinalposition] = cast(row_number() OVER (PARTITION BY d.bk
                                                      ORDER BY cast(ltrim(rtrim(src.[ordinalposition])) AS int) ASC) AS varchar(3)) ,

               [maximumlength] = cast(CASE
                                     WHEN dtm.fixedschemadatatype = '1' THEN CASE
                                                                                 WHEN isnull(iif(ltrim(rtrim(src.[notinrh])) = '', '0', src.[notinrh]), 0) = '1' THEN 'max'
                                                                                 WHEN /*(src.MaximumLength = -1 OR src.MaximumLength > 255) and*/ dtm.datatypemapped = 'varchar' THEN '8000' --When /*(src.MaximumLength = -1 OR src.MaximumLength > 255) and*/ dtm.DataTypeMapped = 'nvarchar'	Then '4000'

                                                                                 ELSE '4000'
                                                                             END
                                     ELSE CASE
                                              WHEN src.maximumlength = '-1'
                                                   AND isnull(src.[notinrh], 0) = '1' THEN 'max'
                                              WHEN src.maximumlength = '-1'
                                                   AND dtm.datatypemapped = 'varchar' THEN '8000'
                                              WHEN src.maximumlength = '-1'
                                                   AND dtm.datatypemapped = 'nvarchar' THEN '4000'
                                              ELSE isnull(src.maximumlength, '')
                                          END
                                 END AS varchar(10)) ,

               [precision] = iif(dtm.fixedschemadatatype = 1, '', isnull(src.[precision], '')) ,

               [scale] = iif(dtm.fixedschemadatatype = 1, '', isnull(src.[scale], '')) ,

               src.[collation] ,

               [defaultvalue] = coalesce(src.[defaultvalue], dtm.defaultvalue) ,

               src.[active] ,

               floworder = d.floworder ,

               d.[bk_reftype_objecttype] ,

               d.bk_reftype_repositorystatus

          FROM prep src

          JOIN bld.vw_dataset d
            ON d.code = src.bk_datasetsrc

          JOIN [bld].[vw_datatypesbyschema] dtm
            ON d.bk_schema = dtm.bk_schema

           AND src.bk_reftype_datatype = dtm.datatypeinrep

         WHERE 1 = 1
       )
SELECT src.[bk] ,

       src.[code] ,

       src.[name] ,

       src.[bk_dataset] ,

       src.[dataset] ,

       src.[attributename] ,

       src.[description] ,

       [expression] = cast(src.[expression] AS varchar(MAX)) ,

       src.[distributionhashkey] ,

       src.[notinrh] ,

       src.[businesskey] ,

       ismta = 0 ,

       src.[srcname] ,

       src.[bk_reftype_datatype] ,

       src.[datatype] ,

       src.[fixedschemadatatype] ,

       src.[orgmappeddatatype] ,

       src.[isnullable] ,

       src.[ordinalposition] ,

       src.[maximumlength] ,

       src.[precision] ,

       src.[scale] ,

       src.[collation] ,

       src.[active] ,

       src.[floworder] ,

       src.[bk_reftype_objecttype] ,

       src.bk_reftype_repositorystatus ,

       defaultvalue = src.[defaultvalue] ,

       ddl_type1 = CASE
                       WHEN (src.[datatype] IN ('nchar',
                                                'nvarchar',
                                                'char',
                                                'varchar',
                                                'varbinary'))                                                                                                                                                                                                                                                                                                                                                                                                                          THEN concat(quotename(src.[datatype]), '(', src.[maximumlength], ')')

            WHEN (src.[datatype] IN ('numeric',
                                                'decimal'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            THEN concat(quotename(src.[datatype]), '(', src.[precision], ',', src.[scale], ')')

            WHEN (src.[datatype] IN ('date',
                                                'datetime',
                                                'datetime2',
                                                'time',
                                                'smallint',
                                                'float',
                                                'int',
                                                'bigint',
                                                'tinyint',
                                                'uniqueidentifier',
                                                'xml',
                                                'bit')) THEN quotename(src.[datatype])

             END ,

       ddl_type2 = CASE
                                   WHEN (src.[datatype] IN ('nchar',
                                                            'nvarchar',
                                                            'char',
                                                            'varchar',
                                                            'varbinary'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              THEN concat(quotename(src.[datatype]), '(', src.[maximumlength], ')')

            WHEN (src.[datatype] IN ('numeric',
                                                            'decimal'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    THEN concat(quotename(src.[datatype]), '(', src.[precision], ',', src.[scale], ')')

            WHEN (src.[datatype] IN ('date',
                                                            'datetime',
                                                            'datetime2',
                                                            'time',
                                                            'smallint',
                                                            'float',
                                                            'int',
                                                            'bigint',
                                                            'tinyint',
                                                            'uniqueidentifier',
                                                            'xml',
                                                            'bit')) THEN quotename(src.[datatype])

             END + iif(src.isnullable = 1, ' NULL ', ' NOT NULL ') ,

       ddl_type3 = 'as ' + CASE
                                                             WHEN (src.[datatype] IN ('nchar',
                                                                                      'nvarchar',
                                                                                      'char',
                                                                                      'varchar',
                                                                                      'varbinary'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    THEN concat(quotename(src.[datatype]), '(', src.[maximumlength], ')')

            WHEN (src.[datatype] IN ('numeric',
                                                                                      'decimal'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        THEN concat(quotename(src.[datatype]), '(', [precision], ',', [scale], ')')

            WHEN (src.[datatype] IN ('date',
                                                                                      'datetime',
                                                                                      'datetime2',
                                                                                      'time',
                                                                                      'smallint',
                                                                                      'float',
                                                                                      'int',
                                                                                      'bigint',
                                                                                      'tinyint',
                                                                                      'uniqueidentifier',
                                                                                      'xml',
                                                                                      'bit')) THEN quotename(src.[datatype])

             END ,

       ddl_type4 = 'as ' + CASE
                                                                                 WHEN (src.[datatype] IN ('nchar',
                                                                                                          'nvarchar',
                                                                                                          'char',
                                                                                                          'varchar',
                                                                                                          'varbinary'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                THEN concat(quotename([datatype]), '(', src.[maximumlength], ')')

            WHEN (src.[datatype] IN ('numeric',
                                                                                                          'decimal'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                THEN concat(quotename(src.[datatype]), '(', src.[precision], ',', src.[scale], ')')

            WHEN (src.[datatype] IN ('date',
                                                                                                          'datetime',
                                                                                                          'datetime2',
                                                                                                          'time',
                                                                                                          'smallint',
                                                                                                          'float',
                                                                                                          'int',
                                                                                                          'bigint',
                                                                                                          'tinyint',
                                                                                                          'uniqueidentifier',
                                                                                                          'xml',
                                                                                                          'bit')) THEN quotename(src.[datatype])

             END + iif(src.isnullable = 1, ' NULL ', ' NOT NULL ')

  FROM base src --where dataset = '[stg].[SF_Netcodec]'
--where bk = 'DWH|pst||AuraPortal|ClaseProcesoPtr15General||3_ETNN_EXT_BssEneId'
