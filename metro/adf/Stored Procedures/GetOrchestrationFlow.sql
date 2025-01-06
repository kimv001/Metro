
CREATE PROCEDURE [adf].[getorchestrationflow] @projectname nvarchar(280),

       @flowname nvarchar(280) = NULL AS IF ((@flowname IS NULL)
                                                                                                 OR (lower(@flowname) = 'null')) BEGIN
SELECT [projects].[projectid],

       [projects].[projectname],

       [flows].[flowid],

       [flows].[flowname],

       [jobs].[jobid],

       [jobs].[jobname],

       [jobs].[jobdescription],

       [jobs].[jobtype],

       [jobs].[jobgroup],

       [jobs].[joborder],

       [jobs].[lastrunduration],

       [jobs].[lastrunstart],

       [jobs].[lastrunstatus],

       [jobs].[checkpoint]

  FROM [adf].[jobs] AS jobs

 INNER JOIN [adf].[flows] AS flows
    ON [jobs].[flowid] = [flows].[flowid]

 INNER JOIN [adf].[projects] AS projects
    ON [flows].[projectid] = [projects].[projectid]

 WHERE [projects].[projectname] = @projectname

   AND [flows].[flowgroup] >= 0

   AND [jobs].[jobgroup] >= 0

 ORDER BY [flowgroup] ASC,

          [floworder] ASC,

          [jobgroup] ASC,

          [joborder] ASC END ELSE BEGIN
SELECT [projects].[projectid],

       [projects].[projectname],

       [flows].[flowid],

       [flows].[flowname],

       [jobs].[jobid],

       [jobs].[jobname],

       [jobs].[jobdescription],

       [jobs].[jobtype],

       [jobs].[jobgroup],

       [jobs].[joborder],

       [jobs].[lastrunduration],

       [jobs].[lastrunstart],

       [jobs].[lastrunstatus],

       [jobs].[checkpoint]

  FROM [adf].[jobs] AS jobs

 INNER JOIN [adf].[flows] AS flows
    ON [jobs].[flowid] = [flows].[flowid]

 INNER JOIN [adf].[projects] AS projects
    ON [flows].[projectid] = [projects].[projectid]

 WHERE [projects].[projectname] = @projectname

   AND [flows].[flowname] = @flowname

   AND [flows].[flowgroup] >= 0

   AND [jobs].[jobgroup] >= 0

 ORDER BY [flowgroup] ASC,

          [floworder] ASC,

          [jobgroup] ASC,

          [joborder] ASC END