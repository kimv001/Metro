
CREATE VIEW [bld].[tr_050_schema_010_default] AS /*
=== Comments =========================================

Description:
	Get all unique properties of a Schema

Changelog:
Date		time		Author					Description
20230326	1200		K. Vermeij				Initial
=======================================================
*/
SELECT bk = s.[bk] ,

       code = s.[code] ,

       [name] = s.[name] ,

       bk_schema = s.[bk] ,

       bk_layer = s.[bk_layer] ,

       bk_datasource = s.[bk_datasource] ,

       bk_linkedservice = ds.[bk_linkedservice] ,

       schemacode = s.[code] ,

       schemaname = s.[name] ,

       datasourcecode = ds.[code] ,

       datasourcename = ds.[name] ,

       bk_datasourcetype = dst.[bk] ,

       datasourcetypecode = dst.[code] ,

       datasourcetypename = dst.[name] ,

       layercode = l.[code] ,

       layername = l.[name] ,

       layerorder = isnull(cast(l.[layerorder] AS int), 0) + (isnull(cast([process_order_in_layer] AS int), 0) * 10) ,

       processorderlayer = s.[process_order_in_layer] ,

       processparallel = s.[process_parallel] ,

       isdwh = l.[isdwh] ,

       issrc = l.[issrc] ,

       istgt = l.[istgt] ,

       isrep = ds.[isrep] ,

       createdummies = s.[createdummies] ,

       linkedservicecode = ls.[code] ,

       linkedservicename = ls.[name] ,

       s.bk_template_create ,

       s.bk_template_load ,

       s.bk_reftype_tochar

  FROM rep.vw_schema s

  JOIN rep.vw_layer l
    ON l.bk = s.bk_layer

  JOIN rep.vw_datasource ds
    ON ds.bk = s.bk_datasource

  JOIN bld.vw_reftype dst
    ON dst.bk = ds.bk_reftype_datasourcetype

  JOIN rep.vw_linkedservice ls
    ON ls.bk = ds.bk_linkedservice
