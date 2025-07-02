




 CREATE view [adf].[vw_DWH_Geography] as 
 select 
 	src.* 

	, RepositoryStatusName	= SDTAP.RepositoryStatus
	, RepositoryStatusCode	= SDTAP.RepositoryStatusCode 
	, Environment			= SDTAP.RepositoryStatus
 
 from [adf].[DWH_geography] src
 Cross join [adf].[vw_SDTAP] SDTAP
where 1=1
and SDTAP.RepositoryStatusCode > -2