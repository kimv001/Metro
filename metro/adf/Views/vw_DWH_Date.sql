








CREATE view [adf].[vw_DWH_Date] as

/* 
Description:
	Date Table from 2010-01-01 till 2039-12-31


*/

select
	 src.* 

	, RepositoryStatusName	= SDTAP.RepositoryStatus
	, RepositoryStatusCode	= SDTAP.RepositoryStatusCode 
	, Environment			= SDTAP.RepositoryStatus
from  [adf].[DWH_Date]   src
Cross join [adf].[vw_SDTAP] SDTAP
where 1=1
and SDTAP.RepositoryStatusCode > -2