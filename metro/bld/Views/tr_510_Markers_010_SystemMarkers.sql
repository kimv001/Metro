
CREATE VIEW [bld].[tr_510_markers_010_systemmarkers] AS /*
=== Comments =========================================

Description:
	creates all system markers per dataset

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230226	1400		K. Vermeij				Added column [mta_rectype] to Activate SmartLoad
=======================================================
*/
SELECT bk = d.bk + '|' + '<!<' + src.[name] + '>>' + '|' + 'System' ,

       bk_dataset = d.bk ,

       code = d.code ,

       markertype = 'System' ,

       markerdescription = src.[description] ,

       marker = '<!<' + src.[name] + '>>' ,

       markervalue = src.[defaultvalue] ,

       [pre] = isnull(src.[pre], 0) ,

       [post] = isnull(src.[post], 0) ,

       mta_rectype = diff.rectype ,

       markerversion = src.markerversion

  FROM [rep].[vw_marker] src

 CROSS JOIN bld.vw_dataset d

  JOIN [bld].[vw_markerssmartload] diff
    ON d.code = diff.code

   AND diff.mta_rectype > -99
