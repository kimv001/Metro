
CREATE PROCEDURE [adf].[updateorchestrationjob] @flowrunguid nvarchar(36) = '-1',

       @jobid nvarchar(900) = '-1',

       @jobrunguid nvarchar(36) = '-1',

       @lastrunduration INT = -1,

       @lastrunstart datetime2 = '1900-01-01 00:00:00',

       @lastrunend datetime2 = '9999-12-31 23:59:99',

       @lastrunstatus nvarchar(10) = 'Undefined',

       @checkpoint datetime2 = NULL,

       @jobmetrics nvarchar(MAX) = NULL,

       @jobfullmessage nvarchar(MAX) = NULL AS -- Update job info

UPDATE [adf].[jobs]

   SET [lastrunduration] = @lastrunduration,

       [lastrunstart] = @lastrunstart,

       [lastrunstatus] = @lastrunstatus,

       [checkpoint] = @checkpoint

 WHERE [jobid] = @jobid -- Insert monitoring record

  INSERT INTO [aud].[jobruns]
SELECT [flows].[flowid],

       @flowrunguid AS [flowrunguid],

       [jobs].[jobid],

       [jobs].[jobname],

       [jobs].[jobdescription],

       [jobs].[jobtype],

       @jobrunguid AS [jobrunguid],

       @lastrunstart AS [runstart],

       @lastrunend AS [runend],

       @lastrunduration AS [runduration],

       @lastrunstatus AS [runstatus],

       @checkpoint AS [checkpoint],

       isnull(json_value(@jobmetrics, '$.RowsInserted'), -1) AS [rowsinserted],

       isnull(json_value(@jobmetrics, '$.RowsUpdated'), -1) AS [rowsupdated],

       isnull(json_value(@jobmetrics, '$.RowsDeleted'), -1) AS [rowsdeleted],

       getdate() AS [logdatetime],

       @jobfullmessage AS [logfullmessage]

  FROM [adf].[jobs] AS jobs

 INNER JOIN [adf].[flows] AS flows
    ON [jobs].[flowid] = [flows].[flowid]

 INNER JOIN [adf].[projects] AS projects
    ON [flows].[projectid] = [projects].[projectid]

 WHERE [jobs].[jobid] = @jobid
