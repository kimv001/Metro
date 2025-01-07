

CREATE PROCEDURE [aud].[proc_Log_Procedure] 
        @LogAction varchar(50), 
        @LogNote varchar(MAX), 
        @LogTime datetime2 = null,
		@LogProcedure varchar(255) = null,
		@LogSQL varchar(MAX) = NULL,
		@LogRowCount bigint = NULL,
		@Log_TimeStart datetime2 = NULL,
		@Log_TimeEnd datetime2 = NULL


    AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

            IF @LogTime IS null
                SET @LogTime = getdate();
				--set @Log_TimeEnd = @LogTime;

            INSERT INTO [aud].[Log_Procedure](Log_Time, Log_Action, Log_Note, Log_Procedure, Log_SQL, Log_RowCount, Log_User, Log_TimeStart,Log_TimeEnd)
                SELECT @Logtime, @LogAction, @LogNote, @LogProcedure, @LogSQL, @LogRowCount, SUSER_NAME (), @Log_TimeStart, @Log_TimeEnd

    END