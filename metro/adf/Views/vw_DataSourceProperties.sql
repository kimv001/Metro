
CREATE VIEW [adf].[vw_datasourceproperties] AS /*
Developed by:			metro
Description:			Generic transformationview to pivot all DataSourceProperties to DTAP environment values

Change log:
Date					Author				Description
20220915 00:00			K. Vermeij			Initial version
*/
SELECT bk_datasource ,

       datasourcename ,

       bk_linkedservice ,

       datasourcepropertiesname ,

       currentenvironment = CASE
                                WHEN right(cast(serverproperty('ServerName') AS varchar), 3) = 'ROD' THEN 'PRD'

            ELSE right(cast(serverproperty('ServerName') AS varchar), 3)

             END ,

       datasourcepropertiescurrentvalue = CASE
                                                                   WHEN right(cast(serverproperty('ServerName') AS varchar), 3) = 'dev' THEN isnull([d], [x])

            WHEN right(cast(serverproperty('ServerName') AS varchar), 3) = 'tst' THEN isnull([t], [x])

            WHEN right(cast(serverproperty('ServerName') AS varchar), 3) = 'acc' THEN isnull([a], [x])

            WHEN right(cast(serverproperty('ServerName') AS varchar), 3) = 'rod' THEN isnull([p], [x])

            WHEN right(cast(serverproperty('ServerName') AS varchar), 3) = 'box' THEN isnull([s], [x])

            ELSE 'Unknown'

             END ,

       d = isnull([d], [x]) ,

       t = isnull([t], [x]) ,

       a = isnull([a], [x]) ,

       p = isnull([p], [x]) ,

       x = [x] -- default value for all DTAP
,

       s = isnull([s], [x]) -- Sandbox environment


  FROM

        (SELECT bk_datasource = ds.bk ,

               bk_linkedservice = ds.bk_linkedservice ,

               datasourcename = ds.[name] ,

               datasourcepropertiesname = src.datasourcepropertiesname ,

               datasourcepropertiesvalue = src.datasourcepropertiesvalue ,

               datasourcepropertiesenvironment = rt.code

          FROM rep.vw_datasource ds

          JOIN rep.vw_datasourceproperties src
            ON src.bk_datasource = ds.bk

          JOIN rep.vw_reftype rt
            ON rt.bk = src.bk_reftype_environment
       ) dsp PIVOT (max([datasourcepropertiesvalue])
                                                                            FOR [datasourcepropertiesenvironment] IN ([d],
                                                                                                                      [t],
                                                                                                                      [a],
                                                                                                                      [p],
                                                                                                                      [x],
                                                                                                                      [s])) AS pivot_table