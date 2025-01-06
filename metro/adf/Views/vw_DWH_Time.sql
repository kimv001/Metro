




CREATE view [adf].[vw_DWH_Time] as

/* 
Description:
	Time Table in HH:MM

*Note
	SS and MS came along, but always 0
*/

select
	src.* 

	, RepositoryStatusName	= SDTAP.RepositoryStatus
	, RepositoryStatusCode	= SDTAP.RepositoryStatusCode 
	, Environment			= SDTAP.RepositoryStatus
from  [adf].[DWH_Time]   src
Cross join [adf].[vw_SDTAP] SDTAP
where 1=1
and SDTAP.RepositoryStatusCode > -2