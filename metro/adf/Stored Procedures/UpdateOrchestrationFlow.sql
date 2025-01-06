
CREATE PROCEDURE [adf].[updateorchestrationflow] @projectname NVARCHAR (900) = '-1',

       @flowname NVARCHAR (900) = '-1',

       @flowrunguid NVARCHAR (36) = '-1',

       @lastrunduration INT = -1,

       @lastrunstart datetime2 = '1900-01-01 00:00:00',

       @lastrunend datetime2 = '9999-12-31 23:59:99',

       @lastrunstatus NVARCHAR (10) = 'Undefined' AS -- Insert monitoring record

INSERT INTO [aud].[flowruns]
SELECT [projects].[projectid],

       [flows].[flowid],

       [flows].[flowname],

       @flowrunguid AS [flowrunguid],

       @lastrunstart AS [runstart],

       @lastrunend AS [runend],

       @lastrunduration AS [runduration],

       @lastrunstatus AS [runstatus],

       getdate() AS [logdatetime]

  FROM [adf].[flows] AS flows

 INNER JOIN [adf].[projects] AS projects
    ON [flows].[projectid] = [projects].[projectid]

 WHERE [flows].[flowname] = @flowname

   AND [projects].[projectname] = @projectname