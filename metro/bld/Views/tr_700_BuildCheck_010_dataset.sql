
CREATE VIEW [bld].[tr_700_buildcheck_010_dataset] AS /*
=== Comments =========================================

Description:
	The BuildChecks are the last step(s) before the templates get filled

	# Note
	Because of the recoding of Metro, the most checks need  a review before activating them.
	All old Checks are commented out

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/ WITH errorcodes AS

        (SELECT severity,

               code,

               error

          FROM (
         VALUES /*
				Severity:
						1	Blocking for ETL Generation
						2	Blocking for ETL Execution
						3	Warning or Consideration
				*/  (1,
         'U1',
         'Dataset has no BusinessKey defined') ,(1,
                                                 'U2',
                                                 '%File Dataset has no (valid) fileproperties defined') ,(1,
                                                                                                          'U3',
                                                                                                          '%File Dataset has no (valid) fileformat defined') ,(1,
                                                                                                                                                               'U4',
                                                                                                                                                               'Dataset has no correct BusinessKey order defined') ,(1,
                                                                                                                                                                                                                     'U5',
                                                                                                                                                                                                                     'Dataset has no atrributes defined') ,(1,
                                                                                                                                                                                                                                                            'U6',
                                                                                                                                                                                                                                                            'Dataset has attributes with the same ordinal position defined') ,(3,
                                                                                                                                                                                                                                                                                                                               'C1',
                                                                                                                                                                                                                                                                                                                               'Scale is set to 0, consider a (big)integer') ,(1,
                                                                                                                                                                                                                                                                                                                                                                               'U7',
                                                                                                                                                                                                                                                                                                                                                                               'DataType not defined') ,(1,
                                                                                                                                                                                                                                                                                                                                                                                                         'U8',
                                                                                                                                                                                                                                                                                                                                                                                                         'Datatype Length is not defined') ,(1,
                                                                                                                                                                                                                                                                                                                                                                                                                                             'U9',
                                                                                                                                                                                                                                                                                                                                                                                                                                             'Datatype Scale and/or Precesion is not set correct')) list (severity, code, error)
       ),

       all_checks AS

        (SELECT bk_dataset = a.bk_dataset ,

               code = a.code --, DatasetName		= d.DatasetName
,

               checkmessage = 'Dataset has no BusinessKey defined' -- U1
 --, BK_Schema			= s.bk
 --, BK_Group			= d.BK_Group

          FROM bld.vw_attribute a

          LEFT JOIN bld.vw_dataset d
            ON a.bk_dataset = d.bk --left join rep.vw_Schema		s on d.bk_schema	= s.bk

         WHERE 1 = 1

           AND d.bk_layer = 'src'

         GROUP BY a.bk_dataset,

                  a.code

        HAVING sum(isnull(cast(a.businesskey AS int), 0)) = 0

     UNION ALL SELECT bk_dataset = d.bk ,

               code = d.code ,

               checkmessage = '%File Dataset has no (valid) fileproperties defined' -- U2

          FROM bld.vw_dataset d

          LEFT JOIN bld.vw_fileproperties fp
            ON fp.code = d.code

         WHERE 1 = 1

           AND (d.objecttype like '%file')

         GROUP BY d.bk,

                  d.code

        HAVING count(isnull(fp.code, 0)) = 0

     UNION ALL SELECT d.bk,

               d.code ,

               checkmessage = 'Dataset has no atrributes defined' -- U5

          FROM bld.vw_dataset d

          LEFT JOIN bld.vw_attribute a
            ON a.bk_dataset = d.bk

         WHERE 1 = 1

           AND (d.schemaname = 'src_file'
          OR d.prefix = 'trv')

         GROUP BY d.bk,

                  d.code

        HAVING count(isnull(a.bk_dataset, 0)) = 0

     UNION ALL SELECT d.bk,

               d.code ,

               checkmessage = 'Dataset has attributes with the same ordinal position defined' -- U6

          FROM bld.vw_dataset d

          LEFT JOIN bld.vw_attribute a
            ON a.bk_dataset = d.bk

         WHERE 1 = 1 --and d.Active = 1

           AND (d.schemaname = 'src_file'
     OR d.prefix = 'trv')

         GROUP BY d.bk,

                  d.code,

                  a.ordinalposition

        HAVING COUNT (a.ordinalposition) > 1

     UNION ALL SELECT d.bk,

               d.code ,

               checkmessage = CASE
                                       WHEN a.datatype IN ('numeric',
                                                           'decimal')
                                            AND a.scale = 0 THEN a.attributename + ' : Scale is set to 0, consider a (big)integer' -- W1

                     END

          FROM bld.vw_dataset d

          LEFT JOIN bld.vw_attribute a
            ON a.bk_dataset = d.bk

         WHERE 1 = 1

           AND (d.schemaname = 'src_file'
          OR d.prefix = 'trv')

     UNION ALL SELECT d.bk,

               d.code ,

               checkmessage = CASE
                                       WHEN isnull(a.datatype, '') = ''                                                                                                                                                                                                                                                   THEN a.attributename + ' :DataType not defined' -- U7

                    WHEN a.datatype IN ('char',
                                                           'varchar',
                                                           'nchar',
                                                           'nvarchar')
                                            AND isnull(a.maximumlength, 0) = 0 THEN a.attributename + ' :Datatype Length is nog defined' -- U8

                    WHEN a.datatype IN ('numeric',
                                                           'decimal')
                                            AND (isnull(a.scale, -1) = -1
                                                 OR isnull(a.precision, -1) = -1)                                                              THEN a.attributename + ' :Datatype Scale and/or Precesion is not set correct' -- U9

                     END

          FROM bld.vw_dataset d

          LEFT JOIN bld.vw_attribute a
            ON a.bk_dataset = d.bk

         WHERE 1 = 1

           AND (d.schemaname = 'src_file'
          OR d.prefix = 'trv')
       )
SELECT bk = ac.bk_dataset + ac.checkmessage ,

       code = ac.code ,

       checkmessage = ac.checkmessage ,

       layername = d.layername ,

       schemaname = d.schemaname ,

       groupname = d.bk_group ,

       shortname = d.shortname

  FROM all_checks ac

  LEFT JOIN bld.vw_dataset d
    ON ac.bk_dataset = d.bk

 WHERE 1 = 1

   AND ac.checkmessage IS NOT NULL
