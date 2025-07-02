




CREATE view [adf].[vw_TGT_from_SRC_schedules] as
/*
=============================================
SQL Query: Schedule Dependency Management
=============================================

**Purpose**:
This query determines valid schedules for loading target datasets by evaluating dependencies between datasets, groups, schemas, and layers. It assigns priorities, filters unnecessary schedules, and categorizes them into three groups:



=============================================
*/

WITH schedules AS (
    -- Step 1: Extract and prioritize schedules
    SELECT 
        CONCAT('schedule : ', s.BK) AS Schedule_TGT,
        s.scheduletype,
        s.TargetToLoad,
        s.BK_Schedule,
        s.ExcludeFromAllLevel,
        s.ExcludeFromAllOther,
        s.ProcessSourceDependencies,
        s.dependend_on_schedules_group,
        s.schedules_group
	FROM bld.vw_Schedules s 
	where 1=1

	
	)
, TTL as (
	select 
		ts.* ,

		-- Determine Priority for "Exclude from Other Schedules" in case of overlapping schedules
		-- For Example schedule group "Fixed"  and dataset "[fct].[Fixed_InstalledBase_ManagementLetter]" are both are scheduled with "Exclude fromOther Schedules" 
		-- then the src_datasets get prioritized. The schedule on dataset "[fct].[Fixed_InstalledBase_ManagementLetter]" gets excluded from schedule group "Fixed"
		row_number() over (partition by SRC_Dataset, ts.Environment order by 
															CASE 
																	WHEN ts.dependencytype = 'export-file'			THEN 100
																	WHEN ts.dependencytype = 'Dataset'				THEN 200
																	WHEN ts.dependencytype = 'ShortNameGroup'		THEN 300
																	WHEN ts.dependencytype = 'ShortNameGroupLayer'	THEN 400
																	WHEN ts.dependencytype = 'Group'				THEN 500
																	WHEN ts.dependencytype = 'LayerGroup'			THEN 600
																	WHEN ts.dependencytype = 'Schema'				THEN 700
																	WHEN ts.dependencytype = 'Layer'				THEN 900
																	ELSE 999 
																END
																 asc
																 ) as schedule_priority_order

	from [adf].[vw_TGT_from_SRC_base] ts
	where 1=1
	and SRC_Layer != 'src'
	--and tgt  ='pl_customer_ws'



)

, PREP_EO_T__NC_T as (  -- Exclude From All Other, No Children

	select 
		s.*,t.*, 'EO_T__NC_T' as src, 
		row_number() over (partition by t.src_dataset, t.Environment order by t.schedule_priority_order asc) as schedule_priority_order_new --> only Rownumber 1 by src_dataset is needed
	from schedules as s
	join TTL t on s.TargetToLoad = t.tgt 
	where 1=1
	and s.ExcludeFromAllOther		= 1			--> EO_T Exclude from all others is true
	and s.ProcessSourceDependencies = 0			--> NC_T Process Children is false
	and s.ScheduleType				!= 'dwh'	--> exclude all level
	and
		( s.TargetToLoad = t.src_dataset
						OR s.TargetToLoad = t.src_group
						OR s.TargetToLoad = t.src_schema
						OR s.TargetToLoad = t.[Source] --takes care of the exports
						OR s.TargetToLoad = CONCAT(t.src_layer, '-', t.src_group)
						OR s.TargetToLoad = CONCAT(t.src_shortname, '-', t.src_group, '-', t.src_layer)
						OR s.TargetToLoad = CONCAT(t.src_shortname, '-', t.src_group)
		) 

)
, EO_T__NC_T as (
	select * from PREP_EO_T__NC_T 
	where schedule_priority_order_new = 1
)

, PREP_EO_T__NC_F as (  -- Exclude From All Other, All Children

	select 
		s.*,t.*, 'EO_T__NC_F' as src
		, row_number() over (partition by t.src_dataset, t.Environment order by t.schedule_priority_order asc) as schedule_priority_order_new --> only Rownumber 1 by src_dataset is needed
	from schedules as s
	join TTL t on s.TargetToLoad = t.tgt
	left join EO_T__NC_T on EO_T__NC_T.SRC_Dataset = t.SRC_Dataset
	where 1=1
	and s.ExcludeFromAllOther		= 1			--> EO_T Exclude from all others is true
	and s.ProcessSourceDependencies = 1			--> NC_F Process Children is true
	and s.ScheduleType				!= 'dwh'	--> exclude all level
	and EO_T__NC_T.SRC_Dataset is null

)
, EO_T__NC_F as(
	select * from PREP_EO_T__NC_F
	where schedule_priority_order_new = 1
)

, EO_F__NC_F as (  -- Schedule No Children

	select s.*,t.*, 'EO_F__NC_F' as src 
	from schedules as s
	join TTL t on s.TargetToLoad = t.tgt
	left join EO_T__NC_T on EO_T__NC_T.SRC_Dataset = t.SRC_Dataset
	left join EO_T__NC_F on EO_T__NC_F.SRC_Dataset = t.SRC_Dataset
	where 1=1
	and s.ExcludeFromAllOther		= 0			--> EO_F Exclude from all others is false
	and s.ProcessSourceDependencies = 0			--> NC_F Process Children is false
	and s.ScheduleType				!= 'dwh'	--> exclude all level
	and
		( s.TargetToLoad = t.src_dataset
						OR s.TargetToLoad = t.src_group
						OR s.TargetToLoad = t.src_schema
				
						OR s.TargetToLoad = CONCAT(t.src_layer, '-', t.src_group)
						OR s.TargetToLoad = CONCAT(t.src_shortname, '-', t.src_group, '-', t.src_layer)
						OR s.TargetToLoad = CONCAT(t.src_shortname, '-', t.src_group)
	)

	and EO_T__NC_T.SRC_Dataset is null
	and EO_T__NC_F.SRC_Dataset is null



)
, EO_F__NC_T as (  -- Schedule All Children

	select s.*,t.*, 'EO_F__NC_T' as src
	from schedules as s
	join TTL t on s.TargetToLoad = t.tgt
	left join EO_T__NC_T on EO_T__NC_T.SRC_Dataset = t.SRC_Dataset
	left join EO_T__NC_F on EO_T__NC_F.SRC_Dataset = t.SRC_Dataset
	where 1=1
	and s.ExcludeFromAllOther		= 0			--> EO_F Exclude from all others is false
	and s.ProcessSourceDependencies = 1			--> NC_T Process Children is true
	and s.ScheduleType				!= 'dwh'	--> exclude all level
	and EO_T__NC_T.SRC_Dataset is null
	and EO_T__NC_F.SRC_Dataset is null
)
, AllOther as (  -- All other not scheduled

	select s.*,t.*, 'AllOther' as src
	from schedules as s
	join TTL t on s.TargetToLoad = t.tgt
	left join EO_T__NC_T on EO_T__NC_T.SRC_Dataset = t.SRC_Dataset
	left join EO_T__NC_F on EO_T__NC_F.SRC_Dataset = t.SRC_Dataset
	left join EO_F__NC_F on EO_F__NC_F.SRC_Dataset = t.SRC_Dataset
	left join EO_F__NC_T on EO_F__NC_T.SRC_Dataset = t.SRC_Dataset
	where 1=1
	and s.ScheduleType = 'dwh' -- all level
	and EO_T__NC_T.SRC_Dataset is null
	and EO_T__NC_F.SRC_Dataset is null
	and EO_F__NC_F.SRC_Dataset is null
	and EO_F__NC_T.SRC_Dataset is null
)
, final AS (

    -- Step 7: Combine all selected schedules into a final dataset
    SELECT 
        Schedule_TGT as TGT, TargetToLoad, scheduletype, BK_Schedule, 
		SRC_BK_DataSet, SRC_Dataset, SRC_ShortName, SRC_Group, SRC_Schema, SRC_Layer, [Source], SRC_DatasetType,
        TGT_DatasetType, generation_number, DependencyType, RepositoryStatusName, RepositoryStatusCode, Environment, src,schedule_priority_order
	FROM EO_T__NC_T
    UNION ALL
    SELECT 
        Schedule_TGT as TGT, TargetToLoad, scheduletype, BK_Schedule, 
		SRC_BK_DataSet, SRC_Dataset, SRC_ShortName, SRC_Group, SRC_Schema, SRC_Layer, [Source], SRC_DatasetType,
        TGT_DatasetType, generation_number, DependencyType, RepositoryStatusName, RepositoryStatusCode, Environment, src ,schedule_priority_order
	FROM EO_T__NC_F
    UNION ALL
    SELECT 
        Schedule_TGT as TGT, TargetToLoad, scheduletype, BK_Schedule, 
		SRC_BK_DataSet, SRC_Dataset, SRC_ShortName, SRC_Group, SRC_Schema, SRC_Layer, [Source], SRC_DatasetType,
        TGT_DatasetType, generation_number, DependencyType, RepositoryStatusName, RepositoryStatusCode, Environment, src,schedule_priority_order 
	FROM EO_F__NC_T
	 UNION ALL
    SELECT 
        Schedule_TGT as TGT, TargetToLoad, scheduletype, BK_Schedule, 
		SRC_BK_DataSet, SRC_Dataset, SRC_ShortName, SRC_Group, SRC_Schema, SRC_Layer, [Source], SRC_DatasetType,
        TGT_DatasetType, generation_number, DependencyType, RepositoryStatusName, RepositoryStatusCode, Environment, src,schedule_priority_order 
	FROM EO_F__NC_F
	 UNION ALL
    SELECT 
        Schedule_TGT as TGT, TargetToLoad, scheduletype, BK_Schedule, 
		SRC_BK_DataSet, SRC_Dataset, SRC_ShortName, SRC_Group, SRC_Schema, SRC_Layer, [Source], SRC_DatasetType,
        TGT_DatasetType, generation_number, DependencyType, RepositoryStatusName, RepositoryStatusCode, Environment, src,schedule_priority_order 
	FROM AllOther
)

-- Final selection of schedules
SELECT b.*
FROM final b
where 1=1
--and Environment = 'prd'
--and tgt like '%pl_customer_ws%'
--and SRC_Group = 'fixed'
--and tgt = 'schedule : Process fixed tables from cds to fct|DAY0930|||||Fixed|||Fixed'
--and src_shortname like '%ClaseProcesoPtr15GeneralWA%'
--and tgt like '%schedule%Fixed_InstalledBase_ManagementLetter%'
--and tgt like '%Maya_GeplandeOpdrachten%'
--and ( tgt like '%aura%' or  tgt like '%Legacy177_backwards|azure%')