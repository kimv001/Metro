CREATE VIEW [adf].[vw_DWH_Time] AS
/*
Description:
    Time Table in HH:MM

*Note
    SS and MS came along, but always set 0
*/

SELECT
    src.*, 
    RepositoryStatusName = SDTAP.RepositoryStatus,
    RepositoryStatusCode = SDTAP.RepositoryStatusCode,
    Environment          = SDTAP.RepositoryStatus
FROM 
    [adf].[DWH_Time] src
CROSS JOIN 
    [adf].[vw_SDTAP] SDTAP
WHERE 
    SDTAP.RepositoryStatusCode > -2;
