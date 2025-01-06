
CREATE PROCEDURE [adf].[getorchestrationjob] @projectid nvarchar(900),

       @flowid nvarchar(900),

       @jobid nvarchar(900) AS BEGIN IF EXISTS

        (SELECT [jobdependencies].*

          FROM [adf].[getmissingjobdependencies] AS jobdependencies

         WHERE [jobdependencies].[flowid] = @flowid

           AND [jobdependencies].[jobid] = @jobid
       ) BEGIN raiserror(n'Dependencies not met', 16, 1) END
SELECT [projects].[projectname],

       [flows].[flowname],

       [flows].[flowid],

       [jobs].[jobid],

       [jobs].[jobname],

       [jobs].[jobdescription],

       [jobs].[jobtype],

       [parameters].[jobparameters],

       [jobs].[jobgroup],

       [jobs].[joborder],

       [jobs].[lastrunduration],

       cast(format([jobs].[lastrunstart], 'yyyy-MM-dd HH:mm:ss') AS varchar(19)) AS [lastrunstart],

       [jobs].[lastrunstatus],

       cast(format([jobs].[checkpoint], 'yyyy-MM-dd HH:mm:ss') AS varchar(19)) AS [checkpoint]

  FROM [adf].[jobs] AS jobs

 INNER JOIN [adf].[flows] AS flows
    ON [jobs].[flowid] = [flows].[flowid]

 INNER JOIN [adf].[projects] AS projects
    ON [flows].[projectid] = [projects].[projectid]

  LEFT JOIN

        (SELECT *

          FROM [adf].[getalljobparametersjson]
       ) AS PARAMETERS
    ON [jobs].[jobid] = [parameters].[jobid]

 WHERE [projects].[projectid] = @projectid

   AND [flows].[flowid] = @flowid

   AND [jobs].[jobid] = @jobid

   AND [flows].[flowgroup] >= 0

   AND [jobs].[jobgroup] >= 0 END
