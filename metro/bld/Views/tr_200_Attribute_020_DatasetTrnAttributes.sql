
CREATE VIEW [bld].[tr_200_attribute_020_datasettrnattributes] AS /*
=== Comments =========================================

Description:
	Get all attributes for Transformation view Datasets

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230301	0845		K. Vermeij				Made a case statement if maximum length = '-1'
20230301	1230		K. Vermeij				Replace the attributename with alias view name
=======================================================
*/ WITH prep AS

        (SELECT [bk] ,

               [code] ,

               [name] ,

               [bk_datasettrn] ,

               [datasettrn] ,

               [attributename] ,

               [description] ,

               [active] ,

               [distributionhashkey] ,

               [expression] ,

               [notinrh] ,

               [businesskey] ,

               [srcname] ,

               [bk_reftype_datatype] ,

               try_cast(replace([isnullable], ' ', '') AS int) AS [isnullable] ,

               try_cast(replace([ordinalposition], ' ', '') AS int) AS [ordinalposition] ,

               try_cast(replace([maximumlength], ' ', '') AS int) AS [maximumlength] ,

               try_cast(replace([precision], ' ', '') AS int) AS [precision] ,

               try_cast(replace([scale], ' ', '') AS int) AS [scale] ,

               [collation] ,

               [defaultvalue] ,

               [mta_rownum] ,

               [mta_bk] ,

               [mta_bkh] ,

               [mta_rh] ,

               [mta_source] ,

               [mta_loaddate]

          FROM [rep].[vw_datasettrnattribute] src
       ) ,

       base AS

        (SELECT bk = concat(d.[bk], '|', iif(d.[replaceattributenames] = '1', replace(src.[attributename], d.shortname, d.dwhtargetshortname), src.[attributename])) ,

               [code] = d.[code] ,

               [name] = d.datasetname + '.[' + iif(d.[replaceattributenames] = '1', replace(src.[attributename], d.shortname, d.dwhtargetshortname), src.[attributename]) + ']' ,

               [bk_dataset] = d.bk ,

               [dataset] = d.datasetname ,

               [attributename] = iif(d.[replaceattributenames] = '1', replace(src.[attributename], d.shortname, d.dwhtargetshortname), src.[attributename]) ,

               src.[description] ,

               src.[expression] ,

               src.[distributionhashkey] ,

               [notinrh] = isnull(src.[notinrh], 0) ,

               [businesskey] = cast(isnull(src.[businesskey], 0) AS int) ,

               src.[srcname] ,

               src.[bk_reftype_datatype] ,

               datatype = dtm.datatypemapped ,

               fixedschemadatatype = cast(dtm.fixedschemadatatype AS varchar(1)) ,

               orgmappeddatatype = dtm.orgmappeddatatype ,

               [isnullable] = cast(isnull(iif(dtm.fixedschemadatatype = 1, 1, src.[isnullable]), 1) AS varchar(1)) ,

               [ordinalposition] = cast(row_number() OVER (PARTITION BY d.bk
                                                      ORDER BY cast(src.[ordinalposition] AS int) ASC) AS varchar(3)) ,

               [maximumlength] = cast(CASE
                                     WHEN dtm.fixedschemadatatype = 1 THEN CASE
                                                                               WHEN (src.maximumlength = -1
                                                                                     OR src.maximumlength > 255)
                                                                                    AND isnull(src.[notinrh], 0) = '1' THEN 'max'
                                                                               WHEN (src.maximumlength = -1
                                                                                     OR src.maximumlength > 255)
                                                                                    AND dtm.datatypemapped = 'varchar' THEN '8000'
                                                                               WHEN (src.maximumlength = -1
                                                                                     OR src.maximumlength > 255)
                                                                                    AND dtm.datatypemapped = 'nvarchar' THEN '4000'
                                                                               ELSE '255'
                                                                           END
                                     ELSE CASE
                                              WHEN src.maximumlength = -1
                                                   AND isnull(src.[notinrh], 0) = '1' THEN 'max'
                                              WHEN src.maximumlength = -1
                                                   AND dtm.datatypemapped = 'varchar' THEN '8000'
                                              WHEN src.maximumlength = -1
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
            ON d.code = src.bk_datasettrn

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

       src.[expression] ,

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

       src.[defaultvalue] ,

       ddl_type1 = CASE
                       WHEN (src.[datatype] IN ('nchar',
                                                'nvarchar',
                                                'char',
                                                'varchar',
                                                'varbinary'))                                                                                                                                                                                                                                                                                                                                                                                                                           THEN concat(quotename(src.[datatype]), '(', src.[maximumlength], ')')

            WHEN (src.[datatype] IN ('numeric',
                                                'decimal'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             THEN concat(quotename(src.[datatype]), '(', src.[precision], ',', src.[scale], ')')

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
                                                            'varbinary'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               THEN concat(quotename(src.[datatype]), '(', src.[maximumlength], ')')

            WHEN (src.[datatype] IN ('numeric',
                                                            'decimal'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     THEN concat(quotename(src.[datatype]), '(', src.[precision], ',', src.[scale], ')')

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

       ddl_type3 = 'AS ' + CASE
                                                             WHEN (src.[datatype] IN ('nchar',
                                                                                      'nvarchar',
                                                                                      'char',
                                                                                      'varchar',
                                                                                      'varbinary'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     THEN concat(quotename(src.[datatype]), '(', src.[maximumlength], ')')

            WHEN (src.[datatype] IN ('numeric',
                                                                                      'decimal'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         THEN concat(quotename(src.[datatype]), '(', [precision], ',', [scale], ')')

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

       ddl_type4 = 'AS ' + CASE
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

  FROM base src

 WHERE 1 = 1 --and src.bk_dataset = 'DWH|fct||monitor|sourcefilesdelivered|'
 --and code = 'DWH|dim|trvs|Common|Date|'
  --and bk_dataset = 'DWH|dim|vw|Common|StartDate|'
 --and bk_dataset = 'DWH|dim|vw|Common|EndDate|'
