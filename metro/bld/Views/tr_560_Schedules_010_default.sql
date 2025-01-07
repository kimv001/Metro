﻿



/*
	and ISNULL(s.[BK_SRCDataset],'') = ''
	and ISNULL(s.[SRC_Shortname],'') = ''
	and ISNULL(s.[BK_TrnDataset],'') = ''
	and ISNULL(s.[BK_Group]		,'') = ''
	and ISNULL(s.[BK_Schema]	,'') = ''
	and ISNULL(s.[BK_Layer]		,'') = ''
	and ISNULL(s.[BK_SRC_layer] ,'') = ''
*/



CREATE VIEW [bld].[tr_560_Schedules_010_default] AS 

WITH ALLSCHEDULES AS (

	-- Process all tables
	SELECT
		  BK						= concat(S.BK,'|','All')
		, SCHEDULES_GROUP
		, DEPENDEND_ON_SCHEDULES_GROUP
		, BK_SCHEDULE				= S.BK_SCHEDULE
		, TARGETTOLOAD				= 'All'
		, SCHEDULETYPE				= 'DWH'
		, EXCLUDEFROMALLLEVEL		= isnull(S.EXCLUDEFROMALLLEVEL,0)
		, EXCLUDEFROMALLOTHER		= isnull(S.EXCLUDEFROMALLOTHER,0)
		, PROCESSSOURCEDEPENDENCIES = isnull(S.PROCESSSOURCEDEPENDENCIES,0)
	FROM REP.VW_SCHEDULES S
	WHERE 1=1
	AND S.PROCESSALL = 1

	UNION ALL


	-- TRN datasets
	SELECT
		  BK						= concat(S.BK,'|', S.BK_TRNDATASET)
		, SCHEDULES_GROUP
		, DEPENDEND_ON_SCHEDULES_GROUP
		, BK_SCHEDULE				= S.BK_SCHEDULE
		, TARGETTOLOAD				= S.BK_TRNDATASET
		, SCHEDULETYPE				= 'Dataset'
		, EXCLUDEFROMALLLEVEL		= isnull(S.EXCLUDEFROMALLLEVEL,0)
		, EXCLUDEFROMALLOTHER		= isnull(S.EXCLUDEFROMALLOTHER,0)
		, PROCESSSOURCEDEPENDENCIES = isnull(S.PROCESSSOURCEDEPENDENCIES,0)
	FROM REP.VW_SCHEDULES S
	WHERE 1=1
	AND ISNULL(S.[BK_SRCDataset],'') = ''
	AND ISNULL(S.[SRC_Shortname],'') = ''
	AND ISNULL(S.[BK_TrnDataset],'') != ''
	AND ISNULL(S.[BK_Group]	  ,'') = ''
	AND ISNULL(S.[BK_Schema]	  ,'') = ''
	AND ISNULL(S.[BK_Layer]	  ,'') = ''
	AND ISNULL(S.[BK_SRC_layer] ,'') = ''

	UNION ALL


	-- SRC datasets
	SELECT
		  BK						= concat(S.BK,'|',DT.BK)
		, SCHEDULES_GROUP
		, DEPENDEND_ON_SCHEDULES_GROUP
		, BK_SCHEDULE				= S.BK_SCHEDULE
		, TARGETTOLOAD				= DT.BK
		, SCHEDULETYPE				= 'Dataset'
		, EXCLUDEFROMALLLEVEL		= isnull(S.EXCLUDEFROMALLLEVEL,0)
		, EXCLUDEFROMALLOTHER		= isnull(S.EXCLUDEFROMALLOTHER,0)
		, PROCESSSOURCEDEPENDENCIES = isnull(S.PROCESSSOURCEDEPENDENCIES,0)
	FROM REP.VW_SCHEDULES S
	LEFT JOIN BLD.VW_DATASET D ON S.BK_SRCDATASET = D.BK
	LEFT JOIN BLD.VW_DATASET DT ON D.CODE = DT.CODE AND DT.FLOWORDERDESC = 1
	WHERE 1=1
	AND ISNULL(S.[BK_SRCDataset],'') != ''
	AND ISNULL(S.[SRC_Shortname],'') = ''
	AND ISNULL(S.[BK_TrnDataset],'') = ''
	AND ISNULL(S.[BK_Group]	  ,'') = ''
	AND ISNULL(S.[BK_Schema]	  ,'') = ''
	AND ISNULL(S.[BK_Layer]	  ,'') = ''
	AND ISNULL(S.[BK_SRC_layer] ,'') = ''

	UNION ALL


	-- Load Groups
	SELECT
		  BK						= concat(S.BK,'|',S.BK_GROUP)
		, SCHEDULES_GROUP
		, DEPENDEND_ON_SCHEDULES_GROUP
		, BK_SCHEDULE				= S.BK_SCHEDULE
		, TARGETTOLOAD				= S.BK_GROUP
		, SCHEDULETYPE				= 'Group'
		, EXCLUDEFROMALLLEVEL		= isnull(S.EXCLUDEFROMALLLEVEL,0)
		, EXCLUDEFROMALLOTHER		= isnull(S.EXCLUDEFROMALLOTHER,0)
		, PROCESSSOURCEDEPENDENCIES = isnull(S.PROCESSSOURCEDEPENDENCIES,0)
	FROM REP.VW_SCHEDULES S
	WHERE 1=1
	AND S.[BK_SRCDataset] IS  null
	AND S.[SRC_Shortname] IS  null
	AND S.[BK_TrnDataset] IS  null
	AND S.[BK_Group]	  IS NOT null
	AND S.[BK_Schema]	  IS  null
	AND S.[BK_Layer]	  IS  null
	AND S.[BK_SRC_layer]  IS  null

	UNION ALL


	-- Load Schema
	SELECT
		  BK						=  concat(S.BK,'|',S.BK_SCHEMA)
		, SCHEDULES_GROUP
		, DEPENDEND_ON_SCHEDULES_GROUP
		, BK_SCHEDULE				= S.BK_SCHEDULE
		, TARGETTOLOAD				= S.BK_SCHEMA
		, SCHEDULETYPE				= 'Schema'
		, EXCLUDEFROMALLLEVEL		= isnull(S.EXCLUDEFROMALLLEVEL,0)
		, EXCLUDEFROMALLOTHER		= isnull(S.EXCLUDEFROMALLOTHER,0)
		, PROCESSSOURCEDEPENDENCIES = isnull(S.PROCESSSOURCEDEPENDENCIES,0)
	FROM REP.VW_SCHEDULES S
	WHERE 1=1
	AND ISNULL(S.[BK_SRCDataset],'') = ''
	AND ISNULL(S.[SRC_Shortname],'') = ''
	AND ISNULL(S.[BK_TrnDataset],'') = ''
	AND ISNULL(S.[BK_Group]		,'') = ''
	AND ISNULL(S.[BK_Schema]	,'') != ''
	AND ISNULL(S.[BK_Layer]		,'') = ''
	AND ISNULL(S.[BK_SRC_layer] ,'') = ''

	UNION ALL


	-- Load Layer
	SELECT
		  BK						= concat(S.BK,'|',S.BK_LAYER)
		, SCHEDULES_GROUP
		, DEPENDEND_ON_SCHEDULES_GROUP
		, BK_SCHEDULE				= S.BK_SCHEDULE
		, TARGETTOLOAD				= S.BK_LAYER
		, SCHEDULETYPE				= 'Layer'
		, EXCLUDEFROMALLLEVEL		= isnull(S.EXCLUDEFROMALLLEVEL,0)
		, EXCLUDEFROMALLOTHER		= isnull(S.EXCLUDEFROMALLOTHER,0)
		, PROCESSSOURCEDEPENDENCIES = isnull(S.PROCESSSOURCEDEPENDENCIES,0)
	FROM REP.VW_SCHEDULES S
	
	WHERE 1=1
	AND ISNULL(S.[BK_SRCDataset],'') = ''
	AND ISNULL(S.[SRC_Shortname],'') = ''
	AND ISNULL(S.[BK_TrnDataset],'') = ''
	AND ISNULL(S.[BK_Group]		,'') = ''
	AND ISNULL(S.[BK_Schema]	,'') = ''
	AND ISNULL(S.[BK_Layer]		,'') != ''
	AND ISNULL(S.[BK_SRC_layer] ,'') = ''

	UNION ALL
	-- Load GroupLayers
	SELECT
		  BK						= concat(S.BK,'|',S.BK_LAYER+'-'+S.BK_GROUP)
		, SCHEDULES_GROUP
		, DEPENDEND_ON_SCHEDULES_GROUP
		, BK_SCHEDULE				= S.BK_SCHEDULE
		, TARGETTOLOAD				= S.BK_LAYER+'-'+S.BK_GROUP
		, SCHEDULETYPE				= 'LayerGroup'
		, EXCLUDEFROMALLLEVEL		= isnull(S.EXCLUDEFROMALLLEVEL,0)
		, EXCLUDEFROMALLOTHER		= isnull(S.EXCLUDEFROMALLOTHER,0)
		, PROCESSSOURCEDEPENDENCIES = isnull(S.PROCESSSOURCEDEPENDENCIES,0)
	FROM REP.VW_SCHEDULES S
	WHERE 1=1
	AND ISNULL(S.[BK_SRCDataset],'') = ''
	AND ISNULL(S.[SRC_Shortname],'') = ''
	AND ISNULL(S.[BK_TrnDataset],'') = ''
	AND ISNULL(S.[BK_Group]		,'') != ''
	AND ISNULL(S.[BK_Schema]	,'') = ''
	AND ISNULL(S.[BK_Layer]		,'') != ''
	AND ISNULL(S.[BK_SRC_layer] ,'') = ''

	UNION ALL
	-- Load GroupLayers
	SELECT
		  BK						= concat(S.BK,'|',S.BK_GROUP+'-'+S.BK_SRC_LAYER)
		, SCHEDULES_GROUP
		, DEPENDEND_ON_SCHEDULES_GROUP
		, BK_SCHEDULE				= S.BK_SCHEDULE
		, TARGETTOLOAD				= S.BK_GROUP+'-'+S.BK_SRC_LAYER
		, SCHEDULETYPE				= 'GroupSRCLayer'
		, EXCLUDEFROMALLLEVEL		= isnull(S.EXCLUDEFROMALLLEVEL,0)
		, EXCLUDEFROMALLOTHER		= isnull(S.EXCLUDEFROMALLOTHER,0)
		, PROCESSSOURCEDEPENDENCIES = isnull(S.PROCESSSOURCEDEPENDENCIES,0)
	FROM REP.VW_SCHEDULES S
	WHERE 1=1
	AND ISNULL(S.[BK_SRCDataset],'') = ''
	AND ISNULL(S.[SRC_Shortname],'') = ''
	AND ISNULL(S.[BK_TrnDataset],'') = ''
	AND ISNULL(S.[BK_Group]		,'') != ''
	AND ISNULL(S.[BK_Schema]	,'') = ''
	AND ISNULL(S.[BK_Layer]		,'') = ''
	AND ISNULL(S.[BK_SRC_layer] ,'') != ''

	UNION ALL
	-- Load ShortNameGroup
	SELECT
		  BK						= concat(S.BK,'|',S.SRC_SHORTNAME+'-'+S.[BK_Layer])
		, SCHEDULES_GROUP
		, DEPENDEND_ON_SCHEDULES_GROUP
		, BK_SCHEDULE				= S.BK_SCHEDULE
		, TARGETTOLOAD				= S.SRC_SHORTNAME+'-'+S.[BK_Layer]
		, SCHEDULETYPE				= 'ShortNameGroup'
		, EXCLUDEFROMALLLEVEL		= isnull(S.EXCLUDEFROMALLLEVEL,0)
		, EXCLUDEFROMALLOTHER		= isnull(S.EXCLUDEFROMALLOTHER,0)
		, PROCESSSOURCEDEPENDENCIES = isnull(S.PROCESSSOURCEDEPENDENCIES,0)
	FROM REP.VW_SCHEDULES S
	WHERE 1=1
	AND ISNULL(S.[BK_SRCDataset],'') = ''
	AND ISNULL(S.[SRC_Shortname],'') != ''
	AND ISNULL(S.[BK_TrnDataset],'') = ''
	AND ISNULL(S.[BK_Group]		,'') = ''
	AND ISNULL(S.[BK_Schema]	,'') = ''
	AND ISNULL(S.[BK_Layer]		,'') != ''
	AND ISNULL(S.[BK_SRC_layer] ,'') = ''

	UNION ALL
	-- Load ShortNameGroup
	SELECT
		  BK						= concat(S.BK,'|',S.SRC_SHORTNAME+'-'+S.BK_GROUP+'-'+S.[BK_Layer])
		, SCHEDULES_GROUP
		, DEPENDEND_ON_SCHEDULES_GROUP
		, BK_SCHEDULE				= S.BK_SCHEDULE
		, TARGETTOLOAD				= S.SRC_SHORTNAME+'-'+S.BK_GROUP+'-'+S.[BK_Layer]
		, SCHEDULETYPE				= 'ShortNameGroupLayer'
		, EXCLUDEFROMALLLEVEL		= isnull(S.EXCLUDEFROMALLLEVEL,0)
		, EXCLUDEFROMALLOTHER		= isnull(S.EXCLUDEFROMALLOTHER,0)
		, PROCESSSOURCEDEPENDENCIES = isnull(S.PROCESSSOURCEDEPENDENCIES,0)
	FROM REP.VW_SCHEDULES S
	WHERE 1=1
	AND ISNULL(S.[BK_SRCDataset],'') = ''
	AND ISNULL(S.[SRC_Shortname],'')!= ''
	AND ISNULL(S.[BK_TrnDataset],'') = ''
	AND ISNULL(S.[BK_Group]		,'')!= ''
	AND ISNULL(S.[BK_Schema]	,'') = ''
	AND ISNULL(S.[BK_Layer]		,'')!= ''
	AND ISNULL(S.[BK_SRC_layer] ,'') = ''


	UNION ALL
	-- export to file
	SELECT
		  BK						= concat(S.BK,'|',S.BK_EXPORT)
		, SCHEDULES_GROUP
		, DEPENDEND_ON_SCHEDULES_GROUP
		, BK_SCHEDULE				= S.BK_SCHEDULE
		, TARGETTOLOAD				= S.BK_EXPORT
		, SCHEDULETYPE				= 'export-file'
		, EXCLUDEFROMALLLEVEL		= isnull(S.EXCLUDEFROMALLLEVEL,0)
		, EXCLUDEFROMALLOTHER		= isnull(S.EXCLUDEFROMALLOTHER,0)
		, PROCESSSOURCEDEPENDENCIES = isnull(S.PROCESSSOURCEDEPENDENCIES,0)
	FROM REP.VW_SCHEDULES S
	WHERE 1=1
	AND ISNULL(S.[BK_export],'')!= ''
	

)
SELECT
	  BK						= SRC.BK
	, SCHEDULES_GROUP			= SRC.SCHEDULES_GROUP
	, DEPENDEND_ON_SCHEDULES_GROUP = SRC.DEPENDEND_ON_SCHEDULES_GROUP
	, CODE						= SRC.BK
	, BK_SCHEDULE				= SRC.BK_SCHEDULE
	, TARGETTOLOAD				= SRC.TARGETTOLOAD
	, SCHEDULETYPE				= SRC.SCHEDULETYPE
	, EXCLUDEFROMALLLEVEL		= SRC.EXCLUDEFROMALLLEVEL
	, EXCLUDEFROMALLOTHER		= SRC.EXCLUDEFROMALLOTHER
	, PROCESSSOURCEDEPENDENCIES = SRC.PROCESSSOURCEDEPENDENCIES

FROM ALLSCHEDULES SRC
WHERE 1=1
--and BK = 'pl_customer_ws.csv.gz'