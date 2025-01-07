





CREATE VIEW [bld].[tr_500_MarkersSmartLoad_010_Default] AS 
/* 
=== Comments =========================================

Description:
	Is a helper for the bld.tr_%_Marker_% views.
	When change is detected in the bld tables on wich the markers are dependent, the code of the full set will be returned
	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/

/*
select * from bld.dataset

update bld.Dataset set mta_Createdate = getdate()
where BK = 'BI|Base||IB|AggregatedPc4|'
*/

/* 
The First CTE's determine if there is a change in the source records
If not, the markers will not be rebuild
*/

WITH CREATEDATESRC AS (
	SELECT 	SRC.CODE, SRC.MTA_CREATEDATE , 'vw_Dataset' AS SOURCE
	FROM BLD.VW_DATASET SRC
	--order by 2 desc

	UNION ALL 
	
	SELECT SRC.CODE , SRC.MTA_CREATEDATE , 'vw_FileProperties' AS SOURCE
	FROM BLD.VW_FILEPROPERTIES SRC

	UNION ALL 
	
	SELECT SRC.CODE , SRC.MTA_CREATEDATE , 'vw_Attribute' AS SOURCE
	FROM BLD.VW_ATTRIBUTE SRC

	UNION ALL 
	
	SELECT SRC.CODE , SRC.MTA_CREATEDATE , 'vw_DatasetDependency' AS SOURCE
	FROM BLD.VW_DATASETDEPENDENCY SRC
)
, MAXCREATEDATESRC AS (
	SELECT 
		CODE
		, MTA_CREATEDATE = max(MTA_CREATEDATE) 
	FROM  CREATEDATESRC 
	GROUP BY CODE
)
, CREATEDATETGT AS (
	SELECT 
		 CODE				= M.CODE
		, MTA_CREATEDATE	= max(M.MTA_CREATEDATE)
	FROM BLD.VW_MARKERS M
	GROUP BY M.CODE
)
-- List of Codes that are possibly changed
SELECT DISTINCT 
	BK					= COALESCE(S.CODE, T.CODE)
	, CODE				= COALESCE(S.CODE, T.CODE)
	, SRCCREATEDATE		= S.MTA_CREATEDATE
	, TGTCREATEDATE		= T.MTA_CREATEDATE
	, ISUPDATED			= iif(S.MTA_CREATEDATE> T.MTA_CREATEDATE,1,0)
	, RECTYPE			= CASE 
							WHEN S.CODE = T.CODE AND 	S.MTA_CREATEDATE> T.MTA_CREATEDATE  THEN 0
							WHEN T.CODE IS null THEN 1
							WHEN S.CODE IS null THEN -1
							ELSE -99
							END

FROM MAXCREATEDATESRC S
--left join CreateDateTgt T on S.Code = T.Code and S.mta_CreateDate> T.mta_CreateDate
FULL OUTER JOIN CREATEDATETGT T ON T.CODE = S.CODE