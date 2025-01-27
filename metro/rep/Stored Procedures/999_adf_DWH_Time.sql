
CREATE PROCEDURE rep.[999_adf_DWH_Time] AS
/* 
=== Comments =========================================

Description:
    This stored procedure creates a time table with time-related calculations.

Parameters:
    None

Example Usage:
    exec [rep].[999_adf_DWH_Time]

Procedure Logic:
    1. Checks if the table [adf].[DWH_Time] exists.
    2. If the table does not exist, creates the table [adf].[DWH_Time].
    3. Truncates the table [adf].[DWH_Time] to remove any existing data.
    4. Populates the table [adf].[DWH_Time] with time-related calculations.

AST:
Procedure: [rep].[999_adf_DWH_Time]
  Parameters:
    - None
  Variables:
    - None
  Logic:
    - Check if the table [adf].[DWH_Time] exists
    - If the table does not exist, create the table
    - Truncate the table to remove existing data
    - Populate the table with time-related calculations

Mermaid Diagram:
graph TD
    A[Start] --> B[Check if the table [adf].[DWH_Time] exists]
    B --> C{Table exists?}
    C --> D[Create the table [adf].[DWH_Time]] --> E[Truncate the table]
    C --> E[Truncate the table]
    E --> F[Populate the table with time-related calculations]
    F --> G[End]
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/

BEGIN
    -- Check if the table [adf].[DWH_Time] exists
    IF NOT EXISTS (
        SELECT 1 
        FROM INFORMATION_SCHEMA.TABLES 
        WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_NAME = 'DWH_Time'
    ) 
    BEGIN
        -- Create the table [adf].[DWH_Time]
        CREATE TABLE [adf].[DWH_Time](
            [Time_HH_MM_SS] [time](7) NULL,
            [Time_Int] [int] NULL
        ) ON [PRIMARY];
    END

    -- Truncate the table to remove existing data
    TRUNCATE TABLE [adf].[DWH_Time];

    -- Populate the table with time-related calculations
    WITH Hours AS
    (
        SELECT DATEADD(
            DD, 0, DATEDIFF(
                DD, 0, GETDATE()
            )
        ) AS dtHr
        UNION ALL
        SELECT DATEADD(MINUTE, 1, dtHr)
        FROM Hours
        WHERE DATEADD(MINUTE, 1, dtHr) < DATEADD(DAY, 1, DATEDIFF(DAY, 0, GETDATE()))
    )
    INSERT INTO [adf].[DWH_Time] ([Time_HH_MM_SS], [Time_Int])
    SELECT dtHr, 
            -- minutes counter, starting at 0 ending at 1439
            (DATEPART(HOUR, CAST(dtHr AS time)) * 60) + (DATEPART(MINUTE, CAST(dtHr AS time)) ) Time_Int
    FROM Hours
    OPTION (MAXRECURSION 1440);
END