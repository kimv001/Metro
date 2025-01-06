





CREATE view [bld].[tr_510_Markers_010_SystemMarkers] as 
/* 
=== Comments =========================================

Description:
	creates all system markers per dataset
	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230226	1400		K. Vermeij				Added column [mta_rectype] to Activate SmartLoad
=======================================================
*/


SELECT 
	  BK				= d.bk+'|'+'<!<'+src.[Name]+'>>'+'|'+'System'
	
	, BK_Dataset		= d.BK
	, Code				= d.Code
	, MarkerType		= 'System'
	, MarkerDescription = src.[Description]
	, Marker			= '<!<'+src.[Name]+'>>'
	, MarkerValue		= src.[DefaultValue]
	, [Pre]				= Isnull(src.[Pre],0)
	, [Post]			= Isnull(src.[Post],0)
	, mta_RecType		= diff.RecType
	, MarkerVersion		= src.MarkerVersion
  FROM [rep].[vw_Marker] src
  cross join bld.vw_dataset d
  join [bld].[vw_MarkersSmartLoad] Diff on d.Code = Diff.Code  and diff.mta_RecType> -99