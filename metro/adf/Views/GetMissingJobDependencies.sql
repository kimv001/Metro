
CREATE VIEW [adf].[getmissingjobdependencies] AS
SELECT [projects].[projectname],

       [flows].[flowname],

       [jobs].*,

       [jobdependencies].[prerequisitejobid],

       [prerequisitejobs].[jobname] AS [prerequisitejobname],

       [prerequisitejobs].[lastrunstatus] AS [prerequisitejobstatus],

       [prerequisitejobs].[lastrunstart] AS [prerequisitejoblastrunstart]

  FROM [adf].[jobs] AS jobs

 INNER JOIN [adf].[flows] AS flows
    ON [jobs].[flowid] = [flows].[flowid]

 INNER JOIN [adf].[projects] AS projects
    ON [flows].[projectid] = [projects].[projectid]

  LEFT JOIN [adf].[jobdependencies] AS jobdependencies
    ON [jobs].[jobid] = [jobdependencies].[dependingjobid]

 INNER JOIN [adf].[jobs] AS prerequisitejobs
    ON [jobdependencies].[prerequisitejobid] = [prerequisitejobs].[jobid]

 WHERE ([prerequisitejobs].[lastrunstatus] <> 'Successful'
       OR [prerequisitejobs].[lastrunstatus] IS NULL)