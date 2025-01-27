





CREATE VIEW [bld].[tr_510_Markers_010_SystemMarkers] AS 
/* 
=== Comments =========================================

Description:
    This view generates system markers for all datasets. These markers are used to dynamically replace values in templates based on the dataset and system configurations.

Columns:
    - BK: The business key of the marker.
    - BK_DATASET: The business key of the dataset.
    - CODE: The code of the dataset.
    - MARKERTYPE: The type of the marker (System).
    - MARKERDESCRIPTION: The description of the marker.
    - MARKER: The marker placeholder.
    - MARKERVALUE: The value of the marker.
    - Pre: Indicates if the marker is a pre-processing marker.
    - Post: Indicates if the marker is a post-processing marker.
    - MTA_RECTYPE: The record type for the marker.
    - MARKERVERSION: The version of the marker.

Example Usage:
    SELECT * FROM [bld].[tr_510_Markers_010_SystemMarkers]

Logic:
    1. Selects marker definitions from the [rep].[vw_Marker] view.
    2. Cross joins with the [bld].[vw_Dataset] view to apply markers to all datasets.
    3. Joins with the [bld].[vw_MarkersSmartLoad] view to filter markers based on changes in the source records.

Source Data:
    - [rep].[vw_Marker]: Contains definitions for markers.
    - [bld].[vw_Dataset]: Contains dataset definitions.
    - [bld].[vw_MarkersSmartLoad]: Contains information about changes in source records for smart loading.

	
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