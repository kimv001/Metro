
CREATE VIEW [adf].[vw_datasourceproperties_sdtap_values] AS /*
Developed by:			metro
Description:			Generic transformationview to pivot all DataSourceProperties to SDTAP environment values

Change log:
Date					Author				Description
20220915 00:00			K. Vermeij			Initial version
*/ WITH cte_sdtap AS

        (SELECT *

          FROM [adf].[vw_datasourceproperties]
       ),

       cte_datasources AS

        (SELECT *,

               bk AS bk_datasource

          FROM rep.vw_datasource
       ) ,

       cte_datasourcepropertiesvalues AS

        (-- SaNDbox
 SELECT src.bk_datasource ,

               src.isdwh ,

               src.isrep ,

               datasourceserver = isnull(servername.s, servername.x) ,

               datasourcedatabase = isnull(databasename.s, databasename.x) ,

               datasourceurl = isnull(environmenturl.s, environmenturl.x) ,

               datasourceusr = isnull(datasourceusr.s, datasourceusr.x) ,

               environment = 'SND'

          FROM cte_datasources src

          LEFT JOIN cte_sdtap servername
            ON src.bk_datasource = servername.bk_datasource

           AND servername.[datasourcepropertiesname] = 'ServerName'

          LEFT JOIN cte_sdtap databasename
            ON src.bk_datasource = databasename.bk_datasource

           AND databasename.[datasourcepropertiesname] = 'databaseName'

          LEFT JOIN cte_sdtap environmenturl
            ON src.bk_datasource = environmenturl.bk_datasource

           AND environmenturl.[datasourcepropertiesname] = 'EnvironmentURL'

          LEFT JOIN cte_sdtap datasourceusr
            ON src.bk_datasource = datasourceusr.bk_datasource

           AND datasourceusr.[datasourcepropertiesname] = 'DataSourceUSR'

     UNION ALL --DEVelopment
 SELECT src.bk_datasource ,

               src.isdwh ,

               src.isrep ,

               datasourceserver = isnull(servername.d, servername.x) ,

               databasename = isnull(databasename.d, databasename.x) ,

               environmenturl = isnull(environmenturl.d, environmenturl.x) ,

               datasourceusr = isnull(datasourceusr.d, datasourceusr.x) ,

               environment = 'DEV'

          FROM cte_datasources src

          LEFT JOIN cte_sdtap servername
            ON src.bk_datasource = servername.bk_datasource

           AND servername.[datasourcepropertiesname] = 'ServerName'

          LEFT JOIN cte_sdtap databasename
            ON src.bk_datasource = databasename.bk_datasource

           AND databasename.[datasourcepropertiesname] = 'databaseName'

          LEFT JOIN cte_sdtap environmenturl
            ON src.bk_datasource = environmenturl.bk_datasource

           AND environmenturl.[datasourcepropertiesname] = 'EnvironmentURL'

          LEFT JOIN cte_sdtap datasourceusr
            ON src.bk_datasource = datasourceusr.bk_datasource

           AND datasourceusr.[datasourcepropertiesname] = 'DataSourceUSR'

     UNION ALL --TeST
 SELECT src.bk_datasource ,

               src.isdwh ,

               src.isrep ,

               datasourceserver = isnull(servername.t, servername.x) ,

               datasourcedatabase = isnull(databasename.t, databasename.x) ,

               environmenturl = isnull(environmenturl.t, environmenturl.x) ,

               datasourceusr = isnull(datasourceusr.t, datasourceusr.x) ,

               environment = 'TST'

          FROM cte_datasources src

          LEFT JOIN cte_sdtap servername
            ON src.bk_datasource = servername.bk_datasource

           AND servername.[datasourcepropertiesname] = 'ServerName'

          LEFT JOIN cte_sdtap databasename
            ON src.bk_datasource = databasename.bk_datasource

           AND databasename.[datasourcepropertiesname] = 'databaseName'

          LEFT JOIN cte_sdtap environmenturl
            ON src.bk_datasource = environmenturl.bk_datasource

           AND environmenturl.[datasourcepropertiesname] = 'EnvironmentURL'

          LEFT JOIN cte_sdtap datasourceusr
            ON src.bk_datasource = datasourceusr.bk_datasource

           AND datasourceusr.[datasourcepropertiesname] = 'DataSourceUSR'

     UNION ALL -- ACCeptance
 SELECT src.bk_datasource ,

               src.isdwh ,

               src.isrep ,

               datasourceserver = isnull(servername.a, servername.x) ,

               databasename = isnull(databasename.a, databasename.x) ,

               environmenturl = isnull(environmenturl.a, environmenturl.x) ,

               datasourceusr = isnull(datasourceusr.a, datasourceusr.x) ,

               environment = 'ACC'

          FROM cte_datasources src

          LEFT JOIN cte_sdtap servername
            ON src.bk_datasource = servername.bk_datasource

           AND servername.[datasourcepropertiesname] = 'ServerName'

          LEFT JOIN cte_sdtap databasename
            ON src.bk_datasource = databasename.bk_datasource

           AND databasename.[datasourcepropertiesname] = 'databaseName'

          LEFT JOIN cte_sdtap environmenturl
            ON src.bk_datasource = environmenturl.bk_datasource

           AND environmenturl.[datasourcepropertiesname] = 'EnvironmentURL'

          LEFT JOIN cte_sdtap datasourceusr
            ON src.bk_datasource = datasourceusr.bk_datasource

           AND datasourceusr.[datasourcepropertiesname] = 'DataSourceUSR'

     UNION ALL -- PRoDuction
 SELECT src.bk_datasource ,

               src.isdwh ,

               src.isrep ,

               datasourceserver = isnull(servername.p, servername.x) ,

               databasename = isnull(databasename.p, databasename.x) ,

               environmenturl = isnull(environmenturl.p, environmenturl.x) ,

               datasourceusr = isnull(datasourceusr.p, datasourceusr.x) ,

               environment = 'PRD'

          FROM cte_datasources src

          LEFT JOIN cte_sdtap servername
            ON src.bk_datasource = servername.bk_datasource

           AND servername.[datasourcepropertiesname] = 'ServerName'

          LEFT JOIN cte_sdtap databasename
            ON src.bk_datasource = databasename.bk_datasource

           AND databasename.[datasourcepropertiesname] = 'databaseName'

          LEFT JOIN cte_sdtap environmenturl
            ON src.bk_datasource = environmenturl.bk_datasource

           AND environmenturl.[datasourcepropertiesname] = 'EnvironmentURL'

          LEFT JOIN cte_sdtap datasourceusr
            ON src.bk_datasource = datasourceusr.bk_datasource

           AND datasourceusr.[datasourcepropertiesname] = 'DataSourceUSR'
       )
SELECT src.bk_datasource ,

       src.isdwh ,

       src.isrep ,

       src.datasourceserver ,

       src.datasourcedatabase ,

       src.datasourceurl ,

       src.datasourceusr ,

       src.environment

  FROM cte_datasourcepropertiesvalues src