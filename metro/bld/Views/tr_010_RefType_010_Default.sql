



CREATE VIEW [bld].[tr_010_RefType_010_Default] AS
/* 
=== Comments =========================================

Description:
	All Defined RefTypes 
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230326	1315		K. Vermeij				Added [isDefault]
=======================================================
*/
SELECT   
	  rt.BK
	, rt.Code
	, rt.[Name]
	, rt.[Description]
	, rt.RefType
	, rt.RefTypeAbbr
	, rt.SortOrder
	, rt.LinkedReftype
	, rt.BK_LinkedRefType
	, LinkedRefTypeCode			= rtP.[Code]
	, LinkedRefTypeName			= rtP.[Name]
	, LinkedRefTypeDecription	= rtP.[Description]
	, DefaultValue				= CASE WHEN  rt.RefType = 'DataType' THEN rt.[Default] ELSE null END
	, isDefault					= CASE WHEN  rt.RefType = 'DataType' THEN null ELSE rt.[Default] END
	
FROM rep.vw_RefType rt
LEFT JOIN rep.vw_RefType rtP ON rt.LinkedReftype = rtP.RefTypeAbbr AND rt.BK_LinkedRefType = rtP.BK
WHERE 1=1
  AND isnull( rt.Active,'1')=1
  AND rt.bk IS NOT null
 -- and (rt.BK = 'DST|SQL_SYN|' or rt.BK = 'SL|SQLSYN|')