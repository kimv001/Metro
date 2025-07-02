


CREATE view [adf].[vw_Schedules] as 
Select 
	
	  src.BK
	, src.Code
	, src.BK_Schedule
	, src.TargetToLoad
	, src.ScheduleType
	, src.schedules_group
	, src.dependend_on_schedules_group
	--, src.ReloadIfAlreadyLoaded

	, RepositoryStatusName	= env.RepositoryStatus
	, RepositoryStatusCode	= env.RepositoryStatusCode 
	, Environment			= env.Environment
	-- select *
  From bld.vw_Schedules src
 -- join bld.vw_RefType rt on rt.bk = src.[BK_RefType_RepositoryStatus]
  join [adf].[vw_SDTAP]  env  on src.RepositoryStatusCode >= env.RepositoryStatusCode
where env.RepositoryStatusCode > -2