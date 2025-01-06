
CREATE PROCEDURE [aud].[proc_log_procedure] @logaction varchar(50),

       @lognote varchar(MAX),

       @logtime datetime2 = NULL,

       @logprocedure varchar(255) = NULL,

       @logsql varchar(MAX) = NULL,

       @logrowcount bigint = NULL,

       @log_timestart datetime2 = NULL,

       @log_timeend datetime2 = NULL AS BEGIN -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.


   SET nocount
    ON; IF @logtime IS NULL

   SET @logtime = getdate(); --set @Log_TimeEnd = @LogTime;

INSERT INTO [aud].[log_procedure](log_time, log_action, log_note, log_procedure, log_sql, log_rowcount, log_user, log_timestart, log_timeend)
SELECT @logtime,

       @logaction,

       @lognote,

       @logprocedure,

       @logsql,

       @logrowcount,

       suser_name (),

       @log_timestart,

       @log_timeend END