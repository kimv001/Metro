







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
=======================================================
*/



WITH CreateDate_MarkersAndDatasetTemplatesAndTemplates AS (
	
	-- get create date from Markers
	-- if 1 marker is changed, all should be rebuild
	-- kind of design flaw, but you cant detemine which marker are used in which templates
	SELECT src.BK_Dataset, max(src.mta_CreateDate) AS mta_CreateDate, 'vw_Markers' AS source
	FROM bld.vw_Markers src
	GROUP BY src.BK_Dataset
	

	UNION ALL 
	
	-- get create date for the combination of Datasets and Templates
	SELECT src.BK_Dataset, src.mta_CreateDate, 'vw_DatasetTemplates' AS source
	FROM bld.vw_DatasetTemplates src

	UNION ALL

	-- get create date Templates
	SELECT src.BK_Dataset, t.mta_CreateDate, 'vw_DatasetTemplates' AS source
	FROM bld.vw_DatasetTemplates src
	JOIN bld.vw_Template t ON src.BK_Template = t.BK

)


, MaxCreateDateSrc AS (
	SELECT 
		src.BK_Dataset
		, mta_CreateDate = max(mta_CreateDate) 
	FROM  CreateDate_MarkersAndDatasetTemplatesAndTemplates src
	GROUP BY src.BK_Dataset
)
, CreateDateTgt AS (
	SELECT 
		 BK_Dataset				= t.BK_Dataset
		, mta_CreateDate	= max(t.mta_CreateDate)
	FROM bld.vw_DeployScripts t
	GROUP BY t.BK_Dataset
)
-- List of Codes that are possibly changed
SELECT DISTINCT 
	BK					= COALESCE(S.BK_Dataset, T.BK_Dataset)
	, BK_Dataset		= COALESCE(S.BK_Dataset, T.BK_Dataset)
	, Code				= COALESCE(S.BK_Dataset, T.BK_Dataset)
	, SrcCreateDate		= S.mta_CreateDate
	, TgtCreateDate		= T.mta_CreateDate
	, IsUpdated			= iif(S.mta_CreateDate> T.mta_CreateDate,1,0)
	, RecType			= CASE 
							WHEN S.BK_Dataset = T.BK_Dataset AND 	S.mta_CreateDate> T.mta_CreateDate  THEN 0
							WHEN T.BK_Dataset IS null THEN 1
							WHEN S.BK_Dataset IS null THEN -1
							ELSE -99
							END

FROM MaxCreateDateSrc S

FULL OUTER JOIN CreateDateTgt T ON T.BK_Dataset = S.BK_Dataset