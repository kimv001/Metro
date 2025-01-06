
CREATE VIEW [bld].[tr_210_attributesmartload_010_default] AS /*
=== Comments =========================================

Description:
	Is a helper for the [bld].[tr_200_Attribute_030_AddMtaAttributes]
	When change is detected in the bld tables on wich the src.tgt_table_name are dependent, the code of the full set will be returned

	# Note
	mta_attributes change when datasets are changed or when the ordinal positions of the other columns change

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/ /*
The First CTE's determine if there is a change in the source records
If not, the markers will not be rebuild
*/ WITH createdatesrc AS 
  
        (SELECT src.code, 
          
               src.mta_createdate, 
          
               'vw_Dataset' AS SOURCE 
   
          FROM bld.vw_dataset src --order by 2 desc

     UNION ALL SELECT a.code, 
                    
               a.mta_createdate, 
                    
               'vw_Attribute' AS SOURCE 
   
          FROM [bld].[vw_attribute] a 
   
         WHERE a.mta_source != '[bld].[tr_230_Attribute_030_AddMtaAttributes]'
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
   
          FROM bld.attribute m 
   
         WHERE m.mta_source = '[bld].[tr_230_Attribute_030_AddMtaAttributes]'

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
