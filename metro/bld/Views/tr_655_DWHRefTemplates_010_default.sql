
CREATE VIEW [bld].[tr_655_dwhreftemplates_010_default] AS WITH templates AS

        (SELECT bk_template = t.bk ,

               t.bk ,

               t.code ,

               templatetype = 'Create' ,

               templatesource = rt_target.[name] ,

               templateorder = rt_objecttype.sortorder ,

               t.bk_reftype_objecttype ,

               templatescript = t.script ,

               templateversion = t.templateversion , RowNum = row_number() OVER (
                                                                            ORDER BY cast(rt_objecttype.sortorder AS int) ASC)

          FROM bld.vw_template t

          JOIN bld.vw_reftype rt_target
            ON t.bk_reftype_templatetype = rt_target.bk

          JOIN bld.vw_reftype rt_objecttype
            ON t.bk_reftype_objecttype = rt_objecttype.bk

         WHERE rt_target.bk = 'TT|DWHR|DWH_Ref'
       )
SELECT bk ,

       code ,

       bk_template ,

       bk_dataset = '' ,

       templatetype ,

       templatesource ,

       bk_reftype_objecttype ,

       templatescript = templatescript ,

       templateversion , RowNum

  FROM templates

 WHERE 1 = 1
