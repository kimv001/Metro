
CREATE VIEW [bld].[tr_075_flow_010_default] AS
SELECT bk = fl.bk,

       code = fl.code,

       bk_flow = f.bk,

       flow_name = f.[name],

       flow_description = isnull(f.[description], '<no description available ...>'),

       flow_layer_step_name = fl.[name],

       flow_layer_step_description = isnull(fl.[description], '<no description available ...>'),

       flow_layer_step_order = fl.sortorder,

       bk_layer = l.bk,

       bk_schema = s.bk, -- helper to determine if there is a view on the source dataset that should be used instead of the table
 readfromview = fl.readfromview,

       bk_template_load = fl.bk_template_load, --Load_Template_Name			= tl.[Name],
 --Load_Template_Description	= tl.[Description],
 --Load_Template				= tl.Script
 bk_template_create = fl.bk_template_create

  FROM rep.vw_flow f

  JOIN rep.vw_flowlayer fl
    ON fl.bk_flow = f.bk

  LEFT JOIN rep.vw_layer l
    ON fl.bk_layer = l.bk

  LEFT JOIN rep.vw_schema s
    ON fl.bk_schema = s.bk

  LEFT JOIN rep.vw_template tl
    ON fl.bk_template_load = tl.bk
