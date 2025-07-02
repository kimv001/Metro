
CREATE PROC [aud].[Proc_log_CheckIfDatasetConatinsData] @SourceDataset [VARCHAR](255),@TargetDataset [VARCHAR](255),@PipelineRunID [VARCHAR](255),@PipelineTriggerID [VARCHAR](255) AS

/*

Procedure Description

*/

BEGIN
    SET NOCOUNT ON;

    -- Declare variables to track processing status
	DECLARE @SRC_COUNTER BIGINT = 0;
    DECLARE @ErrorMessage VARCHAR(8000) = ''; 
	DECLARE @SQL nvarchar(max);
    PRINT CHAR(10) + CHAR(9) + 'Begin check if SourceDataset contains data: ' + @SourceDataset ;

    -- ***************************************
    -- 1. CHECK IF SOURCE table contains data
    -- ***************************************
	
	--DECLARE @SourceDataset NVARCHAR(255) = '[adf].[rep_Contact]';
	--DECLARE @SRC_COUNTER BIGINT = 0;
	--DECLARE @SQL NVARCHAR(MAX);

		SET @SQL = N'SELECT @SRC_COUNTER_OUT = ISNULL(COUNT(1), 0) FROM ' + @SourceDataset;

		EXEC sp_executesql 
			@SQL,
			N'@SRC_COUNTER_OUT BIGINT OUTPUT',
			@SRC_COUNTER_OUT = @SRC_COUNTER OUTPUT;

		-- Resultaat tonen
		SELECT @SRC_COUNTER AS SourceCounter;

   

    -- ***************************************
    -- 3. HANDLE IF SOURCE DATASET IS EMPTY
    -- ***************************************

    -- If the target dataset is currently being processed, log an error and exit
    if @SRC_COUNTER = 0
    BEGIN
        SET @ErrorMessage = 'Source Dataset ' + @SourceDataset + ' is empty! Load is stopped!';

        PRINT CHAR(10) + 'Close Audit Entry in Error';
        EXEC [aud].[Proc_log_CloseAuditEntry] 
            @Dataset = @TargetDataset,
            @PipelineRunID = @PipelineRunID,
            @PipelineTriggerID = @PipelineTriggerID,
            @ProcessMessage = @ErrorMessage,
            @ProcessError = '1';
        

    END

    -- ***************************************
    -- 4. PROCEDURE SUCCESS - NO CONFLICTS FOUND
    -- ***************************************

    PRINT CHAR(10) + CHAR(9) + 'End Check: Source dataset contains data';

    SET NOCOUNT OFF;
END;