








CREATE VIEW [bld].[tr_210_AttributeSmartLoad_010_Default] AS 
/* 
=== Comments =========================================

Description:
    This view is a helper for the [bld].[tr_200_Attribute_030_AddMtaAttributes]. 
	When a change is detected in the bld tables on which the src.tgt_table_name are dependent, the code of the full set will be returned.

Note:
    MTA attributes change when datasets are changed or when the ordinal positions of the other columns change.

	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
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

	SELECT A.CODE, A.MTA_CREATEDATE , 'vw_Attribute' AS SOURCE
	FROM [bld].[vw_Attribute] A
	WHERE A.MTA_SOURCE != '[bld].[tr_230_Attribute_030_AddMtaAttributes]'

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
	FROM BLD.ATTRIBUTE M
	WHERE M.MTA_SOURCE = '[bld].[tr_230_Attribute_030_AddMtaAttributes]'
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