








CREATE VIEW [adf].[vw_DWH_Date] AS

/* 
Description:
	Date Table from 2010-01-01 till 2039-12-31


*/

SELECT
	 src.* 

	, RepositoryStatusName	= SDTAP.RepositoryStatus
	, RepositoryStatusCode	= SDTAP.RepositoryStatusCode 
	, Environment			= SDTAP.RepositoryStatus
FROM  [adf].[DWH_Date]   src
CROSS JOIN [adf].[vw_SDTAP] SDTAP
WHERE 1=1
AND SDTAP.RepositoryStatusCode > -2