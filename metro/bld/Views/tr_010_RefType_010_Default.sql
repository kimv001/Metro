



CREATE VIEW [bld].[tr_010_RefType_010_Default] AS
/* 
=== Comments =========================================

Description:
	All Defined RefTypes.
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230326	1315		K. Vermeij				Added [isDefault]
=======================================================
*/
SELECT   
	  rt.bk
	, rt.code
	, rt.[Name]
	, rt.[Description]
	, rt.reftype
	, rt.reftypeabbr
	, rt.sortorder
	, rt.linkedreftype
	, rt.bk_linkedreftype
	, linkedreftypecode			= rtp.[Code]
	, linkedreftypename			= rtp.[Name]
	, linkedreftypedecription	= rtp.[Description]
	, defaultvalue				= CASE WHEN  rt.reftype = 'DataType' THEN rt.[Default] ELSE null END
	, isdefault					= CASE WHEN  rt.reftype = 'DataType' THEN null ELSE rt.[Default] END
	
FROM rep.vw_reftype rt
LEFT JOIN rep.vw_reftype rtp ON rt.linkedreftype = rtp.reftypeabbr AND rt.bk_linkedreftype = rtp.bk
WHERE 1=1
  AND isnull( rt.active,'1')=1
  AND rt.bk IS NOT null
 -- and (rt.BK = 'DST|SQL_SYN|' or rt.BK = 'SL|SQLSYN|')