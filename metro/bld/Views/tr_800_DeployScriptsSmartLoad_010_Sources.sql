

CREATE VIEW [bld].[tr_800_DeployScriptsSmartLoad_010_Sources] AS 
/* 
=== Comments =========================================

Description:
    This view is a helper for the `bld.DeployScripts` views. It detects changes in the `bld` tables ([bld].[Markers], [bld].[DatasetTemplates], or [bld].[Template]) on which the `bld.DeployScripts` are dependent. When a change is detected, the code of the full set will be returned.

Columns:
    - BK_DATASET: The business key of the dataset.
    - MTA_CREATEDATE: The creation date of the marker, dataset template, or template.
    - SOURCE: The source view from which the creation date is derived.

Example Usage:
    SELECT * FROM [bld].[tr_800_DeployScriptsSmartLoad_010_Sources]

Logic:
    1. Retrieves the creation date from the `bld.vw_Markers` view.
    2. Retrieves the creation date from the `bld.vw_DatasetTemplates` view.
    3. Retrieves the creation date from the `bld.vw_Template` view.
    4. Combines the results into a single view.

Source Data:
    - [bld].[vw_Markers]: Contains marker definitions.
    - [bld].[vw_DatasetTemplates]: Contains dataset template definitions.
    - [bld].[vw_Template]: Contains template definitions.
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20250607	2020		K. Vermeij				filter on custom staging views and filter trvs views.
=======================================================
*/



WITH CreateDate_MarkersAndDatasetTemplatesAndTemplates AS (
	
	-- get create date from Markers
	-- if 1 marker is changed, all should be rebuild
	-- kind of design flaw, but you cant detemine which marker are used in which templates
	--SELECT src.BK_Dataset, src.code, max(src.mta_CreateDate) AS mta_CreateDate, 'vw_Markers' AS source
	SELECT src.code, max(src.mta_CreateDate) AS mta_CreateDate, 'vw_Markers' AS source
	FROM bld.vw_Markers src
	GROUP BY  src.code
	

	UNION ALL 
	
	-- get create date for the combination of Datasets and Templates
	SELECT src.code, max(src.mta_CreateDate) AS mta_CreateDate, 'vw_DatasetTemplates' AS source
	FROM bld.vw_DatasetTemplates src
	GROUP BY  src.code

	UNION ALL

	-- get create date Templates
	SELECT  src.code, max(t.mta_CreateDate) AS mta_CreateDate, 'vw_DatasetTemplates' AS source
	FROM bld.vw_DatasetTemplates src
	JOIN bld.vw_Template t ON src.BK_Template = t.BK
	GROUP BY  src.code

)


, MaxCreateDateSrc AS (
	SELECT 
		src.code
		, mta_CreateDate = max(mta_CreateDate) 
	FROM  CreateDate_MarkersAndDatasetTemplatesAndTemplates src
	GROUP BY src.code
)
, CreateDateTgt AS (
	SELECT 
		 src.code
		, mta_CreateDate	= max(src.mta_CreateDate)
	FROM bld.vw_DeployScripts src
	GROUP BY src.code
)
, final as (
-- List of Codes that are possibly changed
SELECT DISTINCT 
	BK					= COALESCE(S.code, T.code)
	
	, Code				= COALESCE(S.code, T.code)
	, SrcCreateDate		= S.mta_CreateDate
	, TgtCreateDate		= T.mta_CreateDate
	, IsUpdated			= iif(S.mta_CreateDate> T.mta_CreateDate,1,0)
	, RecType			= CASE 
							WHEN S.code = T.code AND 	S.mta_CreateDate> T.mta_CreateDate  THEN 0
							WHEN T.code IS null THEN 1
							WHEN S.code IS null THEN -1
							ELSE -99
							END

FROM MaxCreateDateSrc S
FULL OUTER JOIN CreateDateTgt T ON T.code = S.code
)
select f.* from final f
join bld.vw_Dataset d on f.BK = d.BK
 where 1=1
--and d.code  = 'SF|SF_API||SF|Case|'