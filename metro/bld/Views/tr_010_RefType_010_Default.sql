



CREATE view [bld].[tr_010_RefType_010_Default] as
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
Select   
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
	, DefaultValue				= case when  rt.RefType = 'DataType' then rt.[Default] else null end
	, isDefault					= case when  rt.RefType = 'DataType' then null else rt.[Default] end
	
From rep.vw_RefType rt
left join rep.vw_RefType rtP on rt.LinkedReftype = rtP.RefTypeAbbr and rt.BK_LinkedRefType = rtP.BK
Where 1=1
  and isnull( rt.Active,'1')=1
  and rt.bk is not null
 -- and (rt.BK = 'DST|SQL_SYN|' or rt.BK = 'SL|SQLSYN|')