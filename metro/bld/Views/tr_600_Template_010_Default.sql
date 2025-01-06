
CREATE VIEW [bld].[tr_600_template_010_default] AS
SELECT t.bk ,

       t.code ,

       templatename = t.[name] ,

       templatetype = tt.[name] ,

       templatedecription = t.[description] ,

       objecttype = rt.[name] ,

       objecttypedeployorder = rt.sortorder ,

       script = t.script ,

       scriptlanguagecode = t.scriptlanguage ,

       scriptlanguage = sl.[description] ,

       objectname = t.objectname -- Other
,

       t.bk_reftype_templatetype ,

       t.bk_reftype_objecttype ,

       t.bk_reftype_objecttype_basedon ,

       t.bk_reftype_scriptlanguage ,

       t.templateversion

  FROM rep.vw_template t -- objecttype

  LEFT JOIN rep.vw_reftype rt
    ON rt.bk = t.bk_reftype_objecttype -- templatetype

  LEFT JOIN rep.vw_reftype tt
    ON tt.bk = t.bk_reftype_templatetype -- scriptlanguage

  LEFT JOIN rep.vw_reftype sl
    ON sl.bk = t.bk_reftype_scriptlanguage
