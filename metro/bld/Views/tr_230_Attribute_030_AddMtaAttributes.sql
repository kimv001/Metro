
CREATE VIEW [bld].[tr_230_attribute_030_addmtaattributes] AS /*
=== Comments =========================================

Description:
	creates mta_attributes for all datasets

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230226	1400		K. Vermeij				Add column [mta_rectype] to Activate SmartLoad
20230326	1315		K. Vermeij				removed join with layer
=======================================================
*/ WITH max_ordinal AS

        (SELECT bk_dataset = d.bk ,

               datasetname = d.datasetname ,

               code = d.code ,

               bk_schema = d.bk_schema ,

               floworder = d.floworder ,

               bk_reftype_objecttype = d.bk_reftype_objecttype ,

               bk_reftype_repositorystatus = d.bk_reftype_repositorystatus ,

               max_ordinal = max(cast(a.ordinalposition AS INT))

          FROM bld.vw_attribute a

          JOIN bld.vw_dataset d
            ON d.bk = a.bk_dataset

         WHERE a.ismta = 0

           AND d.isdwh = 1

         GROUP BY d.bk ,

                  d.code ,

                  d.bk_schema ,

                  d.floworder ,

                  d.datasetname ,

                  d.[bk_reftype_objecttype] ,

                  d.bk_reftype_repositorystatus
       ) --, DataTypeMapping as (

SELECT bk = concat(o.bk_dataset, '|', ma.[name]) ,

       [code] = o.[code] ,

       [name] = o.datasetname + '.[' + ma.[name] + ']' ,

       [bk_dataset] = o.bk_dataset ,

       [dataset] = o.datasetname ,

       [attributename] = ma.[name] ,

       [description] = isnull(ma.[description], '') ,

       [expression] = '' ,

       [distributionhashkey] = '' ,

       [notinrh] = 1 ,

       [businesskey] = 0 ,

       [ismta] = 1 ,

       [srcname] = ma.[name] ,

       [bk_reftype_datatype] = ma.bk_reftype_datatype ,

       datatype = ma.bk_reftype_datatype ,

       fixedschemadatatype = 0 ,

       orgmappeddatatype = ma.bk_reftype_datatype ,

       [isnullable] = ma.isnullable ,

       [ordinalposition] = o.max_ordinal + ma.ordinalposition ,

       [maximumlength] = isnull(ma.maximumlength, '') ,

       [precision] = isnull(ma.[precision], '') ,

       [scale] = isnull(ma.[scale], '') ,

       [collation] = '' ,

       defaultvalue = ma.[default] ,

       [active] = ma.active ,

       floworder = o.floworder ,

       [bk_reftype_objecttype] = o.[bk_reftype_objecttype] ,

       bk_reftype_repositorystatus = o.bk_reftype_repositorystatus ,

       ddl_type1 = CASE
                       WHEN (ma.[bk_reftype_datatype] IN ('nchar',
                                                          'nvarchar',
                                                          'char',
                                                          'varchar',
                                                          'varbinary'))                                                                                                                                                                                                                                                                                                                                                                                                                             THEN concat(quotename(ma.[bk_reftype_datatype]), '(', ma.[maximumlength], ')')

            WHEN (ma.[bk_reftype_datatype] IN ('numeric',
                                                          'decimal'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             THEN concat(quotename(ma.[bk_reftype_datatype]), '(', ma.[precision], ',', ma.[scale], ')')

            WHEN (ma.[bk_reftype_datatype] IN ('date',
                                                          'datetime',
                                                          'datetime2',
                                                          'time',
                                                          'smallint',
                                                          'int',
                                                          'bigint',
                                                          'tinyint',
                                                          'uniqueidentifier',
                                                          'xml',
                                                          'bit')) THEN quotename(ma.[bk_reftype_datatype])

             END ,

       ddl_type2 = CASE
                                   WHEN (ma.[bk_reftype_datatype] IN ('nchar',
                                                                      'nvarchar',
                                                                      'char',
                                                                      'varchar',
                                                                      'varbinary'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     THEN concat(quotename(ma.[bk_reftype_datatype]), '(', ma.[maximumlength], ')')

            WHEN (ma.[bk_reftype_datatype] IN ('numeric',
                                                                      'decimal'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         THEN concat(quotename(ma.[bk_reftype_datatype]), '(', ma.[precision], ',', ma.[scale], ')')

            WHEN (ma.[bk_reftype_datatype] IN ('date',
                                                                      'datetime',
                                                                      'datetime2',
                                                                      'time',
                                                                      'smallint',
                                                                      'int',
                                                                      'bigint',
                                                                      'tinyint',
                                                                      'uniqueidentifier',
                                                                      'xml',
                                                                      'bit')) THEN quotename(ma.[bk_reftype_datatype])

             END + iif(ma.isnullable = 1, ' NULL ', ' NOT NULL ') ,

       ddl_type3 = 'AS ' + CASE
                                                             WHEN (ma.[bk_reftype_datatype] IN ('nchar',
                                                                                                'nvarchar',
                                                                                                'char',
                                                                                                'varchar',
                                                                                                'varbinary'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 THEN concat(quotename(ma.[bk_reftype_datatype]), '(', ma.[maximumlength], ')')

            WHEN (ma.[bk_reftype_datatype] IN ('numeric',
                                                                                                'decimal'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   THEN concat(quotename(ma.[bk_reftype_datatype]), '(', [precision], ',', [scale], ')')

            WHEN (ma.[bk_reftype_datatype] IN ('date',
                                                                                                'datetime',
                                                                                                'datetime2',
                                                                                                'time',
                                                                                                'smallint',
                                                                                                'int',
                                                                                                'bigint',
                                                                                                'tinyint',
                                                                                                'uniqueidentifier',
                                                                                                'xml',
                                                                                                'bit')) THEN quotename(ma.[bk_reftype_datatype])

             END ,

       ddl_type4 = 'AS ' + CASE
                                                                                 WHEN (ma.[bk_reftype_datatype] IN ('nchar',
                                                                                                                    'nvarchar',
                                                                                                                    'char',
                                                                                                                    'varchar',
                                                                                                                    'varbinary'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         THEN concat(quotename(ma.[bk_reftype_datatype]), '(', ma.[maximumlength], ')')

            WHEN (ma.[bk_reftype_datatype] IN ('numeric',
                                                                                                                    'decimal'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       THEN concat(quotename(ma.[bk_reftype_datatype]), '(', ma.[precision], ',', ma.[scale], ')')

            WHEN (ma.[bk_reftype_datatype] IN ('date',
                                                                                                                    'datetime',
                                                                                                                    'datetime2',
                                                                                                                    'time',
                                                                                                                    'smallint',
                                                                                                                    'int',
                                                                                                                    'bigint',
                                                                                                                    'tinyint',
                                                                                                                    'uniqueidentifier',
                                                                                                                    'xml',
                                                                                                                    'bit')) THEN quotename(ma.[bk_reftype_datatype])

             END + iif(ma.isnullable = 1, ' NULL ', ' NOT NULL ') ,

       mta_rectype = diff.rectype

  FROM max_ordinal o

  JOIN rep.vw_mtaattribute ma
    ON ma.bk_reftype_objecttype = o.[bk_reftype_objecttype]

   AND ma.bk_schema = o.bk_schema

  LEFT JOIN [bld].[vw_attributesmartload] diff
    ON o.code = diff.code
