
CREATE VIEW [bld].[tr_500_markerssmartload_010_default] AS /*
=== Comments =========================================

Description:
	Is a helper for the bld.tr_%_Marker_% views.
	When change is detected in the bld tables on wich the markers are dependent, the code of the full set will be returned

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/ /*
select * from bld.dataset

update bld.Dataset set mta_Createdate = getdate()
where BK = 'BI|Base||IB|AggregatedPc4|'
*/ /*
The First CTE's determine if there is a change in the source records
If not, the markers will not be rebuild
*/ WITH createdatesrc AS 
  
        (SELECT src.code, 
          
               src.mta_createdate, 
          
               'vw_Dataset' AS SOURCE 
   
          FROM bld.vw_dataset src --order by 2 desc
 
     UNION ALL SELECT src.code, 
                    
               src.mta_createdate, 
                    
               'vw_FileProperties' AS SOURCE 
   
          FROM bld.vw_fileproperties src 
   
     UNION ALL SELECT src.code, 
                    
               src.mta_createdate, 
                    
               'vw_Attribute' AS SOURCE 
   
          FROM bld.vw_attribute src 
   
     UNION ALL SELECT src.code, 
                    
               src.mta_createdate, 
                    
               'vw_DatasetDependency' AS SOURCE

          FROM bld.vw_datasetdependency src
       ),

       maxcreatedatesrc AS

        (SELECT code ,

               mta_createdate = max(mta_createdate)

          FROM createdatesrc

         GROUP BY code
       ),

       createdatetgt AS

        (SELECT code = m.code ,

               mta_createdate = max(m.mta_createdate)

          FROM bld.vw_markers m

         GROUP BY m.code
       ) -- List of Codes that are possibly changed

SELECT DISTINCT bk = coalesce(s.code, t.code) ,

       code = coalesce(s.code, t.code) ,

       srccreatedate = s.mta_createdate ,

       tgtcreatedate = t.mta_createdate ,

       isupdated = iif(s.mta_createdate > t.mta_createdate, 1, 0) ,

       rectype = CASE
                              WHEN s.code = t.code
                                   AND s.mta_createdate > t.mta_createdate THEN 0

            WHEN t.code IS NULL                                          THEN 1

            WHEN s.code IS NULL                                          THEN -1

            ELSE -99

             END

  FROM maxcreatedatesrc s --left join CreateDateTgt T on S.Code = T.Code and S.mta_CreateDate> T.mta_CreateDate

  FULL OUTER JOIN createdatetgt t
    ON t.code = s.code
