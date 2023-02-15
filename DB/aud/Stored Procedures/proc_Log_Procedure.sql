

CREATE PROCEDURE [aud].[proc_Log_Procedure] 
        @LogAction varchar(50), 
        @LogNote varchar(max), 
        @LogTime datetime2 = null,
		@LogProcedure varchar(255) = null,
		@LogSQL varchar(max) = NULL,
		@LogRowCount bigint = NULL

    AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

            if @LogTime is null
                set @LogTime = getdate();

            INSERT INTO [aud].[Log_Procedure](Log_Time, Log_Action, Log_Note, Log_Procedure, Log_SQL, Log_RowCount, Log_User)
                Select @Logtime, @LogAction, @LogNote, @LogProcedure, @LogSQL, @LogRowCount, SUSER_NAME ()

    END