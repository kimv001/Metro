
CREATE VIEW [adf].[vw_Schedules] AS 
SELECT 
	
	  src.BK
	, src.Code
	, src.BK_Schedule
	, src.TargetToLoad
	, src.ScheduleType
	--, src.ReloadIfAlreadyLoaded

	, RepositoryStatusName	= SDTAP.RepositoryStatus
	, RepositoryStatusCode	= SDTAP.RepositoryStatusCode 
	, Environment			= SDTAP.Environment


  FROM bld.vw_Schedules src
  CROSS JOIN adf.vw_SDTAP SDTAP