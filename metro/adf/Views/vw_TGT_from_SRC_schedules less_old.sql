
CREATE view [adf].[vw_TGT_from_SRC_schedules less_old] as
/*
=============================================
SQL Query: Schedule Dependency Management
=============================================

**Purpose**:
This query determines valid schedules for loading target datasets by evaluating dependencies between datasets, groups, schemas, and layers. It assigns priorities, filters unnecessary schedules, and categorizes them into three groups:

1. **no_children** - Schedules that have no child dependencies.
2. **other_schedules** - Schedules that have dependencies on other datasets.
3. **all_other** - Remaining schedules, specifically for DWH processing.

**Logical Steps**:
1. **base**:
   - Fetches and joins schedule (`vw_Schedules`) and dependency (`vw_TGT_from_SRC_base`) data.
   - Assigns a **priority order** based on dependency type.
   - Ensures valid schedules by filtering out unwanted entries.

2. **exclude_from_all_other**:
   - Identifies schedules marked as `ExcludeFromAllOther = 1` for exclusion.

3. **prep_nochildren**:
   - Filters schedules with `ProcessSourceDependencies = 0` and assigns a **rank** for priority handling.

4. **no_children**:
   - Selects schedules with no dependencies, ensuring they are not excluded.

5. **other_schedules**:
   - Identifies schedules that **depend on other datasets**.

6. **all_other**:
   - Finds remaining schedules that are **not included in other categories**, particularly `DWH`.

7. **final**:
   - Combines all filtered schedules into a **single output dataset**.

=============================================
*/

WITH base AS (
    -- Step 1: Extract and prioritize schedules
    SELECT 
        CONCAT('schedule : ', s.BK) AS TGT_new,
        s.scheduletype,
        s.TargetToLoad,
        s.BK_Schedule,
        -- Assign priority based on dependency type
        CASE 
            WHEN ts.dependencytype = 'export-file' THEN 100
            WHEN ts.dependencytype = 'Dataset' THEN 200
            WHEN ts.dependencytype = 'ShortNameGroup' THEN 300
            WHEN ts.dependencytype = 'ShortNameGroupLayer' THEN 400
            WHEN ts.dependencytype = 'Group' THEN 500
            WHEN ts.dependencytype = 'LayerGroup' THEN 600
            WHEN ts.dependencytype = 'Schema' THEN 700
            --WHEN ts.dependencytype = 'GroupSRCLayer' THEN 800
            WHEN ts.dependencytype = 'Layer' THEN 900
            WHEN ts.dependencytype = 'DWH' THEN 999
            ELSE 999 
        END AS schedule_priority_order,
        s.ExcludeFromAllLevel,
        s.ExcludeFromAllOther,
        s.ProcessSourceDependencies,
        s.dependend_on_schedules_group,
        s.schedules_group,
        ts.*
    FROM bld.vw_Schedules s 
     JOIN [adf].[vw_TGT_from_SRC_base] ts
        ON s.TargetToLoad = ts.tgt 
        AND (
            s.ProcessSourceDependencies = 1
            OR (
                s.ProcessSourceDependencies = 0
                AND s.scheduletype = ts.dependencytype 
                AND (
                    s.TargetToLoad = ts.src_dataset
                    OR s.TargetToLoad = ts.src_group
                    OR s.TargetToLoad = ts.src_schema
                    OR s.TargetToLoad = CONCAT(ts.src_layer, '-', ts.src_group)
                    OR s.TargetToLoad = CONCAT(ts.src_shortname, '-', ts.src_group, '-', ts.src_layer)
                    OR s.TargetToLoad = CONCAT(ts.src_shortname, '-', ts.src_group)
                )
            )
        )
		and ts.SRC_Layer != 'src'
    WHERE 1=1
	--and s.BK = 'exclude common_time|NONE|||[dim].[Common_Time]|||||[dim].[Common_Time]'
),

exclude_from_all_other AS (
    -- Step 2: Identify schedules that should be excluded from 'all_other'
    SELECT * 
    FROM base 
    WHERE ExcludeFromAllOther = 1
),

prep_nochildren AS (
    -- Step 3: Rank schedules that have no dependencies
    SELECT 
        b.*, 
        rank() OVER (PARTITION BY b.src_dataset, b.Environment, b.schedule_priority_order ORDER BY b.schedule_priority_order ASC) AS filter_sourcedependencies
    FROM base b
    WHERE ProcessSourceDependencies = 0 
    AND ScheduleType != 'DWH'
),

no_children AS (
    -- Step 4: Select schedules that have no child dependencies and are not excluded
    SELECT b.*, 'no_children' AS src
    FROM prep_nochildren b
    LEFT JOIN exclude_from_all_other eao  
        ON b.Environment = eao.Environment 
        AND b.SRC_Dataset = eao.SRC_Dataset 
        AND (eao.TGT IS NULL OR eao.TGT != b.TargetToLoad)
    WHERE b.filter_sourcedependencies = 1
    AND b.ScheduleType != 'DWH'
    AND eao.SRC_Dataset IS NULL
),

other_schedules AS (
    -- Step 5: Select schedules that depend on other datasets and are not excluded
    SELECT b.*, 'other_schedules' AS src
    FROM base b
    LEFT JOIN exclude_from_all_other eao  
        ON b.Environment = eao.Environment 
        AND b.SRC_Dataset = eao.SRC_Dataset 
        AND (eao.TGT IS NULL OR eao.TGT != b.TargetToLoad)
    WHERE b.ProcessSourceDependencies = 1 
    AND b.ScheduleType != 'DWH'
    AND eao.SRC_Dataset IS NULL
),

all_other AS (
    -- Step 6: Identify remaining schedules, specifically for DWH
    SELECT b.*, 'all_other' AS src
    FROM base b
    LEFT JOIN no_children nc 
        ON b.SRC_Dataset = nc.SRC_Dataset 
        AND b.Environment = nc.Environment
    LEFT JOIN other_schedules os 
        ON b.SRC_Dataset = os.SRC_Dataset 
        AND b.Environment = os.Environment
    WHERE nc.SRC_Dataset IS NULL
    AND os.SRC_Dataset IS NULL
    AND b.ScheduleType = 'DWH'
),

final AS (
    -- Step 7: Combine all selected schedules into a final dataset
    SELECT 
        TGT_new AS TGT,
        TargetToLoad,
        scheduletype,
        BK_Schedule,
        SRC_BK_DataSet,
        SRC_Dataset,
        SRC_ShortName,
        SRC_Group,
        SRC_Schema,
        SRC_Layer,
        Source,
        SRC_DatasetType,
        TGT_DatasetType,
        generation_number,
        DependencyType,
        RepositoryStatusName,
        RepositoryStatusCode,
        Environment,
        src
    FROM no_children
    UNION ALL
    SELECT 
        TGT_new, TargetToLoad, scheduletype, BK_Schedule, SRC_BK_DataSet, SRC_Dataset, 
        SRC_ShortName, SRC_Group, SRC_Schema, SRC_Layer, Source, SRC_DatasetType, 
        TGT_DatasetType, generation_number, DependencyType, RepositoryStatusName, 
        RepositoryStatusCode, Environment, src
    FROM other_schedules
    UNION ALL
    SELECT 
        TGT_new, TargetToLoad, scheduletype, BK_Schedule, SRC_BK_DataSet, SRC_Dataset, 
        SRC_ShortName, SRC_Group, SRC_Schema, SRC_Layer, Source, SRC_DatasetType, 
        TGT_DatasetType, generation_number, DependencyType, RepositoryStatusName, 
        RepositoryStatusCode, Environment, src
    FROM all_other
)

-- Final selection of schedules
SELECT b.*
FROM final b
/*
left join bld.vw_Schedules s on b.tgt = CONCAT('schedule : ', s.BK)
where Environment = 'prd'
and b.BK_Schedule in ('ON_FINISH')
--and SRC_Dataset = '[sto].[KPI_Dashboard]'
--and s.bk is null
order by 3 asc

--and TargetToLoad = '[rpt].[Legacy_WsMainFacts]'

select * from bld.vw_Schedules order by 2
--and src_group = 'dcb'
--order by src_dataset
select * from [adf].[vw_TGT_from_SRC_base]
where tgt = 'exclude common_time|NONE|||[dim].[Common_Time]|||||[dim].[Common_Time]'
*/