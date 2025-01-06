
CREATE view [adf].[vw_Schedules] as 
Select 
	
	  src.BK
	, src.Code
	, src.BK_Schedule
	, src.TargetToLoad
	, src.ScheduleType
	--, src.ReloadIfAlreadyLoaded

	, RepositoryStatusName	= SDTAP.RepositoryStatus
	, RepositoryStatusCode	= SDTAP.RepositoryStatusCode 
	, Environment			= SDTAP.Environment


  From bld.vw_Schedules src
  Cross join adf.vw_SDTAP SDTAP