
CREATE VIEW [adf].[getalljobparametersjson] AS WITH allparameters AS

        (SELECT [jobs].[jobid],

               [projects].[projectparametername] AS parametername,

               [projects].[projectparametervalue] AS parametervalue,

               2 AS ordervalue

          FROM [adf].[jobs] AS jobs

          LEFT JOIN [adf].[jobparameters] AS jobparameters
            ON [jobs].[jobid] = [jobparameters].[jobid]

          LEFT JOIN [adf].[flows] AS flows
            ON [jobs].[flowid] = [flows].[flowid]

         INNER JOIN [adf].[projectparameters] AS projects
            ON [jobs].[jobtype] = [projects].[projectparameterjobtype]

           AND [flows].[projectid] = [projects].[projectid]

         UNION SELECT [jobparameters2].[jobid],

               [jobparameters2].[jobparametername] AS parametername,

               [jobparameters2].[jobparametervalue] AS parametervalue,

               1 AS ordervalue

          FROM [adf].[jobparameters] AS jobparameters2
       ),

       allparameterswithduplicatecount AS

        (SELECT [jobid],

               [parametername],

               [parametervalue],

               row_number() over(PARTITION BY [jobid], [parametername]
                            ORDER BY [ordervalue] ASC) AS duplicatecount

          FROM [allparameters]
       )
SELECT [jobid],

       '{' + string_agg ('"' + [parametername] + '": "' + [parametervalue] + '"', ',') + '}' AS jobparameters

  FROM [allparameterswithduplicatecount]

 WHERE [duplicatecount] = 1

 GROUP BY [jobid]
