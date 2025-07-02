

CREATE VIEW [bld].[tr_560_Schedules_010_default] AS 
/*
Description:
    This view builds up the default schedule definitions for all datasets and specific transactional datasets. It provides detailed information about schedules, including their groups, dependencies, and target datasets to load.

Columns:
    - BK: The business key of the schedule.
    - SCHEDULES_GROUP: The group of the schedule.
    - DEPENDEND_ON_SCHEDULES_GROUP: The group on which the schedule is dependent.
    - BK_SCHEDULE: The business key of the schedule.
    - TARGETTOLOAD: The target dataset to load.
    - SCHEDULETYPE: The type of the schedule (DWH or Dataset).
    - EXCLUDEFROMALLLEVEL: Indicates if the schedule is excluded from all levels.
    - EXCLUDEFROMALLOTHER: Indicates if the schedule is excluded from all other schedules.
    - PROCESSSOURCEDEPENDENCIES: Indicates if the schedule processes source dependencies.

Example Usage:
    SELECT * FROM [bld].[tr_560_Schedules_010_default]

Logic:
    1. Selects all schedules that process all tables.
    2. Selects schedules for specific transactional datasets.
    3. Combines the results into a single view.

Source Data:
    - [rep].[vw_Schedules]: Contains schedule definitions.

Changelog:
Date        Time        Author              Description
20220804    00:00       K. Vermeij          Initial version
20250416	1130		K. Vermeij			added: [RepositoryStatusName] and [RepositoryStatusCode]
*/

with schedules_base as (
select s.* 
	, [RepositoryStatusName]					= rt.[Name]
	, [RepositoryStatusCode]					= rt.code
from rep.vw_Schedules s
join bld.vw_RefType rt on rt.bk = s.[BK_RefType_RepositoryStatus]
)

, allSchedules as (

	-- Process all tables
	select
		  BK						= concat(s.BK,'|','All')
		, schedules_group
		, dependend_on_schedules_group
		, BK_Schedule				= s.BK_Schedule
		, TargetToLoad				= 'All'
		, ScheduleType				= 'DWH'
		, ExcludeFromAllLevel		= isnull(s.ExcludeFromAllLevel,0)
		, ExcludeFromAllOther		= isnull(s.ExcludeFromAllOther,0)
		, ProcessSourceDependencies = isnull(s.ProcessSourceDependencies,1)
		, s.[RepositoryStatusName]	
		, s.[RepositoryStatusCode]
	from schedules_base s
	where 1=1
	and s.ProcessAll = 1

	union All


	-- TRN datasets
	select
		  BK						= concat(s.BK,'|', s.BK_TrnDataset)
		, schedules_group
		, dependend_on_schedules_group
		, BK_Schedule				= s.BK_Schedule
		, TargetToLoad				= s.BK_TrnDataset
		, ScheduleType				= 'Dataset'
		, ExcludeFromAllLevel		= isnull(s.ExcludeFromAllLevel,0)
		, ExcludeFromAllOther		= isnull(s.ExcludeFromAllOther,0)
		, ProcessSourceDependencies = isnull(s.ProcessSourceDependencies,1)
		, s.[RepositoryStatusName]	
		, s.[RepositoryStatusCode]
	from schedules_base s
	where 1=1
	and ISNULL(s.[BK_SRCDataset],'') = ''
	and ISNULL(s.[SRC_Shortname],'') = ''
	and ISNULL(s.[BK_TrnDataset],'') != ''
	and ISNULL(s.[BK_Group]	  ,'') = ''
	and ISNULL(s.[BK_Schema]	  ,'') = ''
	and ISNULL(s.[BK_Layer]	  ,'') = ''
	--and ISNULL(s.[BK_SRC_layer] ,'') = ''

	union All


	-- SRC datasets
	select
		  BK						= concat(s.BK,'|',dt.bk)
		, schedules_group
		, dependend_on_schedules_group
		, BK_Schedule				= s.BK_Schedule
		, TargetToLoad				= dt.bk
		, ScheduleType				= 'Dataset'
		, ExcludeFromAllLevel		= isnull(s.ExcludeFromAllLevel,0)
		, ExcludeFromAllOther		= isnull(s.ExcludeFromAllOther,0)
		, ProcessSourceDependencies = isnull(s.ProcessSourceDependencies,1)
		, s.[RepositoryStatusName]	
		, s.[RepositoryStatusCode]
	from schedules_base s
	left join bld.vw_Dataset d on s.BK_SRCDataset = d.BK
	left join bld.vw_Dataset dt on d.Code = dt.code and dt.FlowOrderDesc = 1
	where 1=1
	and ISNULL(s.[BK_SRCDataset],'') != ''
	and ISNULL(s.[SRC_Shortname],'') = ''
	and ISNULL(s.[BK_TrnDataset],'') = ''
	and ISNULL(s.[BK_Group]	  ,'') = ''
	and ISNULL(s.[BK_Schema]	  ,'') = ''
	and ISNULL(s.[BK_Layer]	  ,'') = ''
	--and ISNULL(s.[BK_SRC_layer] ,'') = ''

	union all


	-- Load Groups
	select
		  BK						= concat(s.BK,'|',s.BK_Group)
		, schedules_group
		, dependend_on_schedules_group
		, BK_Schedule				= s.BK_Schedule
		, TargetToLoad				= s.BK_Group
		, ScheduleType				= 'Group'
		, ExcludeFromAllLevel		= isnull(s.ExcludeFromAllLevel,0)
		, ExcludeFromAllOther		= isnull(s.ExcludeFromAllOther,0)
		, ProcessSourceDependencies = isnull(s.ProcessSourceDependencies,1)
		, s.[RepositoryStatusName]	
		, s.[RepositoryStatusCode]
	from schedules_base s
	where 1=1
	and s.[BK_SRCDataset] is  null
	and s.[SRC_Shortname] is  null
	and s.[BK_TrnDataset] is  null
	and s.[BK_Group]	  is not null
	and s.[BK_Schema]	  is  null
	and s.[BK_Layer]	  is  null
	--and s.[BK_SRC_layer]  is  null

	union all


	-- Load Schema
	select
		  BK						=  concat(s.BK,'|',s.BK_Schema)
		, schedules_group
		, dependend_on_schedules_group
		, BK_Schedule				= s.BK_Schedule
		, TargetToLoad				= s.BK_Schema
		, ScheduleType				= 'Schema'
		, ExcludeFromAllLevel		= isnull(s.ExcludeFromAllLevel,0)
		, ExcludeFromAllOther		= isnull(s.ExcludeFromAllOther,0)
		, ProcessSourceDependencies = isnull(s.ProcessSourceDependencies,1)
		, s.[RepositoryStatusName]	
		, s.[RepositoryStatusCode]
	from schedules_base s
	where 1=1
	and ISNULL(s.[BK_SRCDataset],'') = ''
	and ISNULL(s.[SRC_Shortname],'') = ''
	and ISNULL(s.[BK_TrnDataset],'') = ''
	and ISNULL(s.[BK_Group]		,'') = ''
	and ISNULL(s.[BK_Schema]	,'') != ''
	and ISNULL(s.[BK_Layer]		,'') = ''
	--and ISNULL(s.[BK_SRC_layer] ,'') = ''

	union all


	-- Load Layer
	select
		  BK						= concat(s.BK,'|',s.BK_Layer)
		, schedules_group
		, dependend_on_schedules_group
		, BK_Schedule				= s.BK_Schedule
		, TargetToLoad				= s.BK_Layer
		, ScheduleType				= 'Layer'
		, ExcludeFromAllLevel		= isnull(s.ExcludeFromAllLevel,0)
		, ExcludeFromAllOther		= isnull(s.ExcludeFromAllOther,0)
		, ProcessSourceDependencies = isnull(s.ProcessSourceDependencies,1)
		, s.[RepositoryStatusName]	
		, s.[RepositoryStatusCode]
	from schedules_base s
	
	where 1=1
	and ISNULL(s.[BK_SRCDataset],'') = ''
	and ISNULL(s.[SRC_Shortname],'') = ''
	and ISNULL(s.[BK_TrnDataset],'') = ''
	and ISNULL(s.[BK_Group]		,'') = ''
	and ISNULL(s.[BK_Schema]	,'') = ''
	and ISNULL(s.[BK_Layer]		,'') != ''
	--and ISNULL(s.[BK_SRC_layer] ,'') = ''

	union all
	-- Load GroupLayers
	select
		  BK						= concat(s.BK,'|',s.BK_Layer+'-'+s.BK_Group)
		, schedules_group
		, dependend_on_schedules_group
		, BK_Schedule				= s.BK_Schedule
		, TargetToLoad				= s.BK_Layer+'-'+s.BK_Group
		, ScheduleType				= 'LayerGroup'
		, ExcludeFromAllLevel		= isnull(s.ExcludeFromAllLevel,0)
		, ExcludeFromAllOther		= isnull(s.ExcludeFromAllOther,0)
		, ProcessSourceDependencies = isnull(s.ProcessSourceDependencies,1)
		, s.[RepositoryStatusName]	
		, s.[RepositoryStatusCode]
	from schedules_base s
	where 1=1
	and ISNULL(s.[BK_SRCDataset],'') = ''
	and ISNULL(s.[SRC_Shortname],'') = ''
	and ISNULL(s.[BK_TrnDataset],'') = ''
	and ISNULL(s.[BK_Group]		,'') != ''
	and ISNULL(s.[BK_Schema]	,'') = ''
	and ISNULL(s.[BK_Layer]		,'') != ''
	--and ISNULL(s.[BK_SRC_layer] ,'') = ''

	--union all
	---- Load GroupLayers
	--select
	--	  BK						= concat(s.BK,'|',s.BK_Group+'-'+s.BK_SRC_layer)
	--	, schedules_group
	--	, dependend_on_schedules_group
	--	, BK_Schedule				= s.BK_Schedule
	--	, TargetToLoad				= s.BK_Group+'-'+s.BK_SRC_layer
	--	, ScheduleType				= 'GroupSRCLayer'
	--	, ExcludeFromAllLevel		= isnull(s.ExcludeFromAllLevel,0)
	--	, ExcludeFromAllOther		= isnull(s.ExcludeFromAllOther,0)
	--	, ProcessSourceDependencies = isnull(s.ProcessSourceDependencies,1)
	--from rep.vw_Schedules s
	--where 1=1
	--and ISNULL(s.[BK_SRCDataset],'') = ''
	--and ISNULL(s.[SRC_Shortname],'') = ''
	--and ISNULL(s.[BK_TrnDataset],'') = ''
	--and ISNULL(s.[BK_Group]		,'') != ''
	--and ISNULL(s.[BK_Schema]	,'') = ''
	--and ISNULL(s.[BK_Layer]		,'') = ''
	--and ISNULL(s.[BK_SRC_layer] ,'') != ''

	union all
	-- Load ShortNameGroup
	select
		  BK						= concat(s.BK,'|',s.SRC_Shortname+'-'+s.[BK_Layer])
		, schedules_group
		, dependend_on_schedules_group
		, BK_Schedule				= s.BK_Schedule
		, TargetToLoad				= s.SRC_Shortname+'-'+s.[BK_Layer]
		, ScheduleType				= 'ShortNameGroup'
		, ExcludeFromAllLevel		= isnull(s.ExcludeFromAllLevel,0)
		, ExcludeFromAllOther		= isnull(s.ExcludeFromAllOther,0)
		, ProcessSourceDependencies = isnull(s.ProcessSourceDependencies,1)
		, s.[RepositoryStatusName]	
		, s.[RepositoryStatusCode]
	from schedules_base s
	where 1=1
	and ISNULL(s.[BK_SRCDataset],'') = ''
	and ISNULL(s.[SRC_Shortname],'') != ''
	and ISNULL(s.[BK_TrnDataset],'') = ''
	and ISNULL(s.[BK_Group]		,'') = ''
	and ISNULL(s.[BK_Schema]	,'') = ''
	and ISNULL(s.[BK_Layer]		,'') != ''
	--and ISNULL(s.[BK_SRC_layer] ,'') = ''

	union all
	-- Load ShortNameGroup
	select
		  BK						= concat(s.BK,'|',s.SRC_Shortname+'-'+s.BK_Group+'-'+s.[BK_Layer])
		, schedules_group
		, dependend_on_schedules_group
		, BK_Schedule				= s.BK_Schedule
		, TargetToLoad				= s.SRC_Shortname+'-'+s.BK_Group+'-'+s.[BK_Layer]
		, ScheduleType				= 'ShortNameGroupLayer'
		, ExcludeFromAllLevel		= isnull(s.ExcludeFromAllLevel,0)
		, ExcludeFromAllOther		= isnull(s.ExcludeFromAllOther,0)
		, ProcessSourceDependencies = isnull(s.ProcessSourceDependencies,1)
		, s.[RepositoryStatusName]	
		, s.[RepositoryStatusCode]
	from schedules_base s
	where 1=1
	and ISNULL(s.[BK_SRCDataset],'') = ''
	and ISNULL(s.[SRC_Shortname],'')!= ''
	and ISNULL(s.[BK_TrnDataset],'') = ''
	and ISNULL(s.[BK_Group]		,'')!= ''
	and ISNULL(s.[BK_Schema]	,'') = ''
	and ISNULL(s.[BK_Layer]		,'')!= ''
	--and ISNULL(s.[BK_SRC_layer] ,'') = ''


	union all
	-- export to file
	select
		  BK						= concat(s.BK,'|',s.BK_export)
		, schedules_group
		, dependend_on_schedules_group
		, BK_Schedule				= s.BK_Schedule
		, TargetToLoad				= s.BK_export
		, ScheduleType				= 'export-file'
		, ExcludeFromAllLevel		= isnull(s.ExcludeFromAllLevel,0)
		, ExcludeFromAllOther		= isnull(s.ExcludeFromAllOther,0)
		, ProcessSourceDependencies = isnull(s.ProcessSourceDependencies,1)
		, s.[RepositoryStatusName]	
		, s.[RepositoryStatusCode]
	from schedules_base s
	where 1=1
	and ISNULL(s.[BK_export],'')!= ''
	

)
Select
	  BK						= src.BK
	, schedules_group			= src.schedules_group
	, dependend_on_schedules_group = src.dependend_on_schedules_group
	, Code						= src.BK
	, BK_Schedule				= src.BK_Schedule
	, TargetToLoad				= src.TargetToLoad
	, ScheduleType				= src.ScheduleType
	, ExcludeFromAllLevel		= src.ExcludeFromAllLevel
	, ExcludeFromAllOther		= src.ExcludeFromAllOther
	, ProcessSourceDependencies = src.ProcessSourceDependencies
	, [RepositoryStatusName]	
	, [RepositoryStatusCode]
from allSchedules src
where 1=1
--and BK = 'pl_customer_ws.csv.gz'