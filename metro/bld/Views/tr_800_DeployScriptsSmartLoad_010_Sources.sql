
CREATE VIEW [bld].[tr_800_deployscriptssmartload_010_sources] AS /*
=== Comments =========================================

Description:
	Is a helper for the bld.DeployScripts views.
	When change is detected in the bld tables [bld].[Markers], [bld].[DatasetTemplates] or [bld].[Template] on which the [bld].[DeployScripts] are dependent, the code of the full set will be returned

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/ WITH createdate_markersanddatasettemplatesandtemplates AS

        (-- get create date from Markers
 -- if 1 marker is changed, all should be rebuild
 -- kind of design flaw, but you cant detemine which marker are used in which templates
 SELECT src.bk_dataset,

               max(src.mta_createdate) AS mta_createdate,

               'vw_Markers' AS SOURCE

          FROM bld.vw_markers src

         GROUP BY src.bk_dataset

     UNION ALL -- get create date for the combination of Datasets and Templates
 SELECT src.bk_dataset,

               src.mta_createdate,

               'vw_DatasetTemplates' AS SOURCE

          FROM bld.vw_datasettemplates src

     UNION ALL -- get create date Templates
 SELECT src.bk_dataset,

               t.mta_createdate,

               'vw_DatasetTemplates' AS SOURCE

          FROM bld.vw_datasettemplates src

          JOIN bld.vw_template t
            ON src.bk_template = t.bk
       ) ,

       maxcreatedatesrc AS

        (SELECT src.bk_dataset ,

               mta_createdate = max(mta_createdate)

          FROM createdate_markersanddatasettemplatesandtemplates src

         GROUP BY src.bk_dataset
       ),

       createdatetgt AS

        (SELECT bk_dataset = t.bk_dataset ,

               mta_createdate = max(t.mta_createdate)

          FROM bld.vw_deployscripts t

         GROUP BY t.bk_dataset
       ) -- List of Codes that are possibly changed

SELECT DISTINCT bk = coalesce(s.bk_dataset, t.bk_dataset) ,

       bk_dataset = coalesce(s.bk_dataset, t.bk_dataset) ,

       code = coalesce(s.bk_dataset, t.bk_dataset) ,

       srccreatedate = s.mta_createdate ,

       tgtcreatedate = t.mta_createdate ,

       isupdated = iif(s.mta_createdate > t.mta_createdate, 1, 0) ,

       rectype = CASE
                              WHEN s.bk_dataset = t.bk_dataset
                                   AND s.mta_createdate > t.mta_createdate THEN 0

            WHEN t.bk_dataset IS NULL                                                THEN 1

            WHEN s.bk_dataset IS NULL                                                THEN -1

            ELSE -99

             END

  FROM maxcreatedatesrc s

  FULL OUTER JOIN createdatetgt t
    ON t.bk_dataset = s.bk_dataset
