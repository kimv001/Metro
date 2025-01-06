
CREATE VIEW [bld].[tr_650_datasettemplates_010_default] AS WITH alldefaulttemplates AS

        (SELECT bk_template = d.[bk_template_create] ,

               d.bk ,

               d.code ,

               templatetype = 'Create' ,

               templatesource = 'Dataset' ,

               templateorder = 1 ,

               t.bk_reftype_objecttype ,

               templatescript = t.script

          FROM bld.vw_dataset d

          JOIN bld.vw_template t
            ON t.bk = d.bk_template_create

           AND d.bk_reftype_objecttype = t.bk_reftype_objecttype

         WHERE 1 = 1

     UNION ALL SELECT bk_template = fl.bk_template_create ,

               d.bk ,

               d.code ,

               templatetype = 'Create' ,

               templatesource = 'FlowLayer' ,

               templateorder = 2 ,

               t.bk_reftype_objecttype ,

               templatescript = t.script

          FROM bld.vw_dataset d

          JOIN bld.vw_schema s
            ON s.bk = d.bk_schema

          JOIN rep.vw_flowlayer fl
            ON fl.bk_flow = d.bk_flow

           AND ((fl.bk_layer = s.bk_layer
         AND fl.bk_schema = d.bk_schema)
        OR (fl.bk_layer = s.bk_layer
            AND fl.bk_schema IS NULL))

          JOIN bld.vw_template t
            ON t.bk = fl.bk_template_create

           AND d.[bk_reftype_objecttype] = t.bk_reftype_objecttype

         WHERE 1 = 1

     UNION ALL SELECT bk_template = s.bk_template_create ,

               d.bk ,

               d.code ,

               templatetype = 'Create' ,

               templatesource = 'Schema' ,

               templateorder = 3 ,

               t.bk_reftype_objecttype ,

               templatescript = t.script -- ,D.BK_RefType_ObjectType , t.BK_RefType_ObjectType

          FROM bld.vw_dataset d

          JOIN bld.vw_schema s
            ON s.bk = d.bk_schema

          JOIN bld.vw_template t
            ON t.bk = s.bk_template_create

           AND d.bk_reftype_objecttype = t.bk_reftype_objecttype

         WHERE 1 = 1

           AND d.bk <> d.code -- Source Datasets and Transformation Views must not be (re)created

     UNION ALL SELECT bk_template = d.[bk_template_load] ,

               d.bk ,

               d.code ,

               templatetype = 'Load' ,

               templatesource = 'Dataset' ,

               templateorder = 1 ,

               t.bk_reftype_objecttype ,

               templatescript = t.script

          FROM bld.vw_dataset d

          JOIN bld.vw_template t
            ON t.bk = d.[bk_template_load]

           AND d.bk_reftype_objecttype = t.bk_reftype_objecttype_basedon -- and d.[BK_RefType_ObjectType]= 'OT|T|Table'

         WHERE 1 = 1

     UNION ALL SELECT bk_template = fl.bk_template_load ,

               d.bk ,

               d.code ,

               templatetype = 'Load' ,

               templatesource = 'FlowLayer' ,

               templateorder = 2 ,

               t.bk_reftype_objecttype ,

               templatescript = t.script

          FROM bld.vw_dataset d

          JOIN bld.vw_schema s
            ON s.bk = d.bk_schema

          JOIN rep.vw_flowlayer fl
            ON fl.bk_flow = d.bk_flow

           AND ((fl.bk_layer = s.bk_layer
         AND fl.bk_schema = d.bk_schema)
        OR (fl.bk_layer = s.bk_layer
            AND fl.bk_schema IS NULL))

          JOIN bld.vw_template t
            ON t.bk = fl.bk_template_load

           AND d.[bk_reftype_objecttype] = 'OT|T|Table'

         WHERE 1 = 1

     UNION ALL SELECT bk_template = s.bk_template_load ,

               d.bk ,

               d.code ,

               templatetype = 'Load' ,

               templatesource = 'Schema' ,

               templateorder = 3 ,

               t.bk_reftype_objecttype ,

               templatescript = t.script

          FROM bld.vw_dataset d

          JOIN bld.vw_schema s
            ON s.bk = d.bk_schema

          JOIN bld.vw_template t
            ON t.bk = s.bk_template_load

           AND d.[bk_reftype_objecttype] = 'OT|T|Table'

         WHERE 1 = 1
       ),

       templateorder AS

        (SELECT bk = src.bk_template + '|' + src.bk ,

               code = src.code ,

               bk_template = src.bk_template ,

               bk_dataset = src.bk ,

               templatetype = src.templatetype ,

               templatesource = src.templatesource ,

               bk_reftype_objecttype = src.bk_reftype_objecttype ,

               templatescript = src.templatescript , RowNum = row_number() OVER (PARTITION BY src.templatetype + '|' + src.bk
                                                                            ORDER BY templateorder ASC) --, RowNum				= ROW_NUMBER() over (partition by BK_Template+'|'+src.BK order by TemplateOrder asc)

          FROM alldefaulttemplates src
       )
SELECT bk ,

       code ,

       bk_template ,

       bk_dataset ,

       templatetype ,

       templatesource ,

       bk_reftype_objecttype ,

       templatescript = CASE
                            WHEN right(bk_dataset, 6) = 'custom' THEN '/* User defined view on the database, no deployment desirable. */'

            ELSE templatescript

             END , RowNum

  FROM templateorder

 WHERE 1 = 1

   AND RowNum = 1 --and code = 'SF|SF_API||SF|Netcode__c|'
 --and code = 'DWH|dim|trvs_|Wes|LocationType|'
 --order by 4,1
 --and BK_Dataset = 'DWH|stg|vw_|REF|Addresses|Custom'
