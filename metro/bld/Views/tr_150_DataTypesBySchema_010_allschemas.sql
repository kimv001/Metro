
CREATE VIEW [bld].[tr_150_datatypesbyschema_010_allschemas] AS /*
=== Comments =========================================

Description:
	Get DataType per Schema (per DataSourceType)

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230326	1222		K. Vermeij				Replaced schema related join logic to bld.vw_schema
20241101	1300		K. Vermeij				Added [DefaultValue]
=======================================================
*/ WITH fixedschemadatatype AS

        (/* get fixed datatypes for scehma's, like "staging" */  SELECT bk_schema = ss.bk , 
                                                                  
               datatypemapped = dtm.datatypebydatasource 
   
          FROM bld.vw_schema ss 
   
          JOIN bld.[vw_reftype] sdt 
            ON sdt.bk = ss.[bk_reftype_tochar] 
   
          JOIN bld.vw_reftype dst 
            ON dst.bk = ss.bk_datasourcetype 
   
          JOIN rep.vw_datatypemapping dtm 
            ON dtm.bk_reftype_dst = dst.bk 
   
           AND sdt.code = dtm.code 
   
          JOIN bld.vw_reftype dt 
            ON dt.bk = dtm.bk_reftype_datatype 
   
         WHERE sdt.reftype = 'SchemaDataType'
       ), 
        
       genericdatasourcetype AS 
  
        (-- select the default DataSourceType. This will be used if no datasource Type is mapped in [DataTypeMapping]
 SELECT bk_reftype_datasourcetype = r.bk 
   
          FROM bld.[vw_reftype] r 
   
         WHERE r.reftypeabbr = 'DST'
     
           AND cast(r.[isdefault] AS int) = 1
       ) , 
        
       datatypemapping AS 
  
        (-- get all datatypes by DataSourceType
  SELECT bk_schema = ss.bk , 
         
               datatypemapped = coalesce(fd.datatypemapped, dtm.datatypebydatasource, gdtm.datatypebydatasource) , 
         
               datatypeinrep = coalesce(dt.code, gdtm.datatypebydatasource) , 
         
               fixedschemadatatype = iif(fd.bk_schema IS NULL, 0, 1) , 
         
               orgmappeddatatype = coalesce(dtm.datatypebydatasource, gdtm.datatypebydatasource) , 
         
               defaultvalue = coalesce(dt.defaultvalue, gdt.defaultvalue) 
   
          FROM bld.vw_schema ss 
   
          JOIN rep.vw_datasource ds 
            ON ds.bk = ss.bk_datasource --

          JOIN bld.vw_reftype dst 
            ON dst.bk = ds.bk_reftype_datasourcetype 
   
          LEFT JOIN rep.vw_datatypemapping dtm 
            ON dtm.bk_reftype_dst = dst.bk 
   
          LEFT JOIN bld.vw_reftype dt 
            ON dt.bk = dtm.bk_reftype_datatype -- DataSourceType zonder specifieke datatypemapping (generic)

          JOIN genericdatasourcetype gdst 
            ON 1 = 1 
   
          LEFT JOIN rep.vw_datatypemapping gdtm 
            ON gdtm.bk_reftype_dst = gdst.bk_reftype_datasourcetype
   
           AND dtm.bk_reftype_dst IS NULL 
   
          LEFT JOIN bld.vw_reftype gdt 
            ON gdt.bk = gdtm.bk_reftype_datatype -- Some schema's get a fixed datatype like staging

          LEFT JOIN fixedschemadatatype fd
            ON ss.bk = fd.bk_schema
       )
SELECT DISTINCT bk = src.bk_schema + '|' + datatypemapped + '|' + datatypeinrep ,

       code = src.bk_schema ,

       src.bk_schema ,

       src.datatypemapped ,

       src.datatypeinrep ,

       src.fixedschemadatatype ,

       src.orgmappeddatatype ,

       src.defaultvalue

  FROM datatypemapping src
