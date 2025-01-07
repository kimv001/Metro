





CREATE VIEW [bld].[tr_510_Markers_010_SystemMarkers] AS 
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
	  BK				= D.BK+'|'+'<!<'+SRC.[Name]+'>>'+'|'+'System'
	
	, BK_DATASET		= D.BK
	, CODE				= D.CODE
	, MARKERTYPE		= 'System'
	, MARKERDESCRIPTION = SRC.[Description]
	, MARKER			= '<!<'+SRC.[Name]+'>>'
	, MARKERVALUE		= SRC.[DefaultValue]
	, [Pre]				= Isnull(SRC.[Pre],0)
	, [Post]			= Isnull(SRC.[Post],0)
	, MTA_RECTYPE		= DIFF.RECTYPE
	, MARKERVERSION		= SRC.MARKERVERSION
  FROM [rep].[vw_Marker] SRC
  CROSS JOIN BLD.VW_DATASET D
  JOIN [bld].[vw_MarkersSmartLoad] DIFF ON D.CODE = DIFF.CODE  AND DIFF.MTA_RECTYPE> -99