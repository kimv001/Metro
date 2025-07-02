CREATE PROCEDURE [aud].[proc_Log_Procedure] 
    @LogAction VARCHAR(50), 
    @LogNote VARCHAR(MAX), 
    @LogTime DATETIME2 = NULL,
    @LogProcedure VARCHAR(255) = NULL,
    @LogSQL VARCHAR(MAX) = NULL,
    @LogRowCount BIGINT = NULL,
    @Log_TimeStart DATETIME2 = NULL,
    @Log_TimeEnd DATETIME2 = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Calculate Amsterdam Time correctly (with DST support)
    IF @LogTime IS NULL
    BEGIN
        SET @LogTime = SYSUTCDATETIME() AT TIME ZONE 'UTC' AT TIME ZONE 'W. Europe Standard Time';
    END

    -- Default TimeEnd to LogTime if not provided
    IF @Log_TimeEnd IS NULL
    BEGIN
        SET @Log_TimeEnd = @LogTime;
    END

    INSERT INTO [aud].[Log_Procedure] 
    (
        Log_Time, 
        Log_Action, 
        Log_Note, 
        Log_Procedure, 
        Log_SQL, 
        Log_RowCount, 
        Log_User, 
        Log_TimeStart,
        Log_TimeEnd
    )
    VALUES 
    (
        @LogTime, 
        @LogAction, 
        @LogNote, 
        @LogProcedure, 
        @LogSQL, 
        @LogRowCount, 
        SUSER_SNAME(), 
        @Log_TimeStart,
        @Log_TimeEnd
    );
END