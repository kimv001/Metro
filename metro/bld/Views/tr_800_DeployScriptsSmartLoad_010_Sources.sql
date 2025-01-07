







CREATE VIEW [bld].[tr_800_DeployScriptsSmartLoad_010_Sources] AS 
/* 
=== Comments =========================================

Description:
	Is a helper for the bld.DeployScripts views.
	When change is detected in the bld tables [bld].[Markers], [bld].[DatasetTemplates] or [bld].[Template] on which the [bld].[DeployScripts] are dependent, the code of the full set will be returned
	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/



WITH CREATEDATE_MARKERSANDDATASETTEMPLATESANDTEMPLATES AS (
	
	-- get create date from Markers
	-- if 1 marker is changed, all should be rebuild
	-- kind of design flaw, but you cant detemine which marker are used in which templates
	SELECT SRC.BK_DATASET, max(SRC.MTA_CREATEDATE) AS MTA_CREATEDATE, 'vw_Markers' AS SOURCE
	FROM BLD.VW_MARKERS SRC
	GROUP BY SRC.BK_DATASET
	

	UNION ALL 
	
	-- get create date for the combination of Datasets and Templates
	SELECT SRC.BK_DATASET, SRC.MTA_CREATEDATE, 'vw_DatasetTemplates' AS SOURCE
	FROM BLD.VW_DATASETTEMPLATES SRC

	UNION ALL

	-- get create date Templates
	SELECT SRC.BK_DATASET, T.MTA_CREATEDATE, 'vw_DatasetTemplates' AS SOURCE
	FROM BLD.VW_DATASETTEMPLATES SRC
	JOIN BLD.VW_TEMPLATE T ON SRC.BK_TEMPLATE = T.BK

)


, MAXCREATEDATESRC AS (
	SELECT 
		SRC.BK_DATASET
		, MTA_CREATEDATE = max(MTA_CREATEDATE) 
	FROM  CREATEDATE_MARKERSANDDATASETTEMPLATESANDTEMPLATES SRC
	GROUP BY SRC.BK_DATASET
)
, CREATEDATETGT AS (
	SELECT 
		 BK_DATASET				= T.BK_DATASET
		, MTA_CREATEDATE	= max(T.MTA_CREATEDATE)
	FROM BLD.VW_DEPLOYSCRIPTS T
	GROUP BY T.BK_DATASET
)
-- List of Codes that are possibly changed
SELECT DISTINCT 
	BK					= COALESCE(S.BK_DATASET, T.BK_DATASET)
	, BK_DATASET		= COALESCE(S.BK_DATASET, T.BK_DATASET)
	, CODE				= COALESCE(S.BK_DATASET, T.BK_DATASET)
	, SRCCREATEDATE		= S.MTA_CREATEDATE
	, TGTCREATEDATE		= T.MTA_CREATEDATE
	, ISUPDATED			= iif(S.MTA_CREATEDATE> T.MTA_CREATEDATE,1,0)
	, RECTYPE			= CASE 
							WHEN S.BK_DATASET = T.BK_DATASET AND 	S.MTA_CREATEDATE> T.MTA_CREATEDATE  THEN 0
							WHEN T.BK_DATASET IS null THEN 1
							WHEN S.BK_DATASET IS null THEN -1
							ELSE -99
							END

FROM MAXCREATEDATESRC S

FULL OUTER JOIN CREATEDATETGT T ON T.BK_DATASET = S.BK_DATASET