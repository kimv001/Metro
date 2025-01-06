 /*
	and ISNULL(s.[BK_SRCDataset],'') = ''
	and ISNULL(s.[SRC_Shortname],'') = ''
	and ISNULL(s.[BK_TrnDataset],'') = ''
	and ISNULL(s.[BK_Group]		,'') = ''
	and ISNULL(s.[BK_Schema]	,'') = ''
	and ISNULL(s.[BK_Layer]		,'') = ''
	and ISNULL(s.[BK_SRC_layer] ,'') = ''
*/
CREATE VIEW [bld].[tr_560_schedules_010_default] AS WITH allschedules AS

        (-- Process all tables
 SELECT bk = concat(s.bk, '|', 'All') ,

               schedules_group ,

               dependend_on_schedules_group ,

               bk_schedule = s.bk_schedule ,

               targettoload = 'All' ,

               scheduletype = 'DWH' ,

               excludefromalllevel = isnull(s.excludefromalllevel, 0) ,

               excludefromallother = isnull(s.excludefromallother, 0) ,

               processsourcedependencies = isnull(s.processsourcedependencies, 0)

          FROM rep.vw_schedules s

         WHERE 1 = 1

           AND s.processall = 1

     UNION ALL -- TRN datasets
 SELECT bk = concat(s.bk, '|', s.bk_trndataset) ,

               schedules_group ,

               dependend_on_schedules_group ,

               bk_schedule = s.bk_schedule ,

               targettoload = s.bk_trndataset ,

               scheduletype = 'Dataset' ,

               excludefromalllevel = isnull(s.excludefromalllevel, 0) ,

               excludefromallother = isnull(s.excludefromallother, 0) ,

               processsourcedependencies = isnull(s.processsourcedependencies, 0)

          FROM rep.vw_schedules s

         WHERE 1 = 1

           AND isnull(s.[bk_srcdataset], '') = ''

           AND isnull(s.[src_shortname], '') = ''

           AND isnull(s.[bk_trndataset], '') != ''

           AND isnull(s.[bk_group] , '') = ''

           AND isnull(s.[bk_schema] , '') = ''

           AND isnull(s.[bk_layer] , '') = ''

           AND isnull(s.[bk_src_layer], '') = ''

     UNION ALL -- SRC datasets
 SELECT bk = concat(s.bk, '|', dt.bk) ,

               schedules_group ,

               dependend_on_schedules_group ,

               bk_schedule = s.bk_schedule ,

               targettoload = dt.bk ,

               scheduletype = 'Dataset' ,

               excludefromalllevel = isnull(s.excludefromalllevel, 0) ,

               excludefromallother = isnull(s.excludefromallother, 0) ,

               processsourcedependencies = isnull(s.processsourcedependencies, 0)

          FROM rep.vw_schedules s

          LEFT JOIN bld.vw_dataset d
            ON s.bk_srcdataset = d.bk

          LEFT JOIN bld.vw_dataset dt
            ON d.code = dt.code

           AND dt.floworderdesc = 1

         WHERE 1 = 1

           AND isnull(s.[bk_srcdataset], '') != ''

           AND isnull(s.[src_shortname], '') = ''

           AND isnull(s.[bk_trndataset], '') = ''

           AND isnull(s.[bk_group] , '') = ''

           AND isnull(s.[bk_schema] , '') = ''

           AND isnull(s.[bk_layer] , '') = ''

           AND isnull(s.[bk_src_layer], '') = ''

     UNION ALL -- Load Groups
 SELECT bk = concat(s.bk, '|', s.bk_group) ,

               schedules_group ,

               dependend_on_schedules_group ,

               bk_schedule = s.bk_schedule ,

               targettoload = s.bk_group ,

               scheduletype = 'Group' ,

               excludefromalllevel = isnull(s.excludefromalllevel, 0) ,

               excludefromallother = isnull(s.excludefromallother, 0) ,

               processsourcedependencies = isnull(s.processsourcedependencies, 0)

          FROM rep.vw_schedules s

         WHERE 1 = 1

           AND s.[bk_srcdataset] IS NULL

           AND s.[src_shortname] IS NULL

           AND s.[bk_trndataset] IS NULL

           AND s.[bk_group] IS NOT NULL

           AND s.[bk_schema] IS NULL

           AND s.[bk_layer] IS NULL

           AND s.[bk_src_layer] IS NULL

     UNION ALL -- Load Schema
 SELECT bk = concat(s.bk, '|', s.bk_schema) ,

               schedules_group ,

               dependend_on_schedules_group ,

               bk_schedule = s.bk_schedule ,

               targettoload = s.bk_schema ,

               scheduletype = 'Schema' ,

               excludefromalllevel = isnull(s.excludefromalllevel, 0) ,

               excludefromallother = isnull(s.excludefromallother, 0) ,

               processsourcedependencies = isnull(s.processsourcedependencies, 0)

          FROM rep.vw_schedules s

         WHERE 1 = 1

           AND isnull(s.[bk_srcdataset], '') = ''

           AND isnull(s.[src_shortname], '') = ''

           AND isnull(s.[bk_trndataset], '') = ''

           AND isnull(s.[bk_group] , '') = ''

           AND isnull(s.[bk_schema], '') != ''

           AND isnull(s.[bk_layer] , '') = ''

           AND isnull(s.[bk_src_layer], '') = ''

     UNION ALL -- Load Layer
 SELECT bk = concat(s.bk, '|', s.bk_layer) ,

               schedules_group ,

               dependend_on_schedules_group ,

               bk_schedule = s.bk_schedule ,

               targettoload = s.bk_layer ,

               scheduletype = 'Layer' ,

               excludefromalllevel = isnull(s.excludefromalllevel, 0) ,

               excludefromallother = isnull(s.excludefromallother, 0) ,

               processsourcedependencies = isnull(s.processsourcedependencies, 0)

          FROM rep.vw_schedules s

         WHERE 1 = 1

           AND isnull(s.[bk_srcdataset], '') = ''

           AND isnull(s.[src_shortname], '') = ''

           AND isnull(s.[bk_trndataset], '') = ''

           AND isnull(s.[bk_group] , '') = ''

           AND isnull(s.[bk_schema], '') = ''

           AND isnull(s.[bk_layer] , '') != ''

           AND isnull(s.[bk_src_layer], '') = ''

     UNION ALL -- Load GroupLayers
 SELECT bk = concat(s.bk, '|', s.bk_layer + '-' + s.bk_group) ,

               schedules_group ,

               dependend_on_schedules_group ,

               bk_schedule = s.bk_schedule ,

               targettoload = s.bk_layer + '-' + s.bk_group ,

               scheduletype = 'LayerGroup' ,

               excludefromalllevel = isnull(s.excludefromalllevel, 0) ,

               excludefromallother = isnull(s.excludefromallother, 0) ,

               processsourcedependencies = isnull(s.processsourcedependencies, 0)

          FROM rep.vw_schedules s

         WHERE 1 = 1

           AND isnull(s.[bk_srcdataset], '') = ''

           AND isnull(s.[src_shortname], '') = ''

           AND isnull(s.[bk_trndataset], '') = ''

           AND isnull(s.[bk_group] , '') != ''

           AND isnull(s.[bk_schema], '') = ''

           AND isnull(s.[bk_layer] , '') != ''

           AND isnull(s.[bk_src_layer], '') = ''

     UNION ALL -- Load GroupLayers
 SELECT bk = concat(s.bk, '|', s.bk_group + '-' + s.bk_src_layer) ,

               schedules_group ,

               dependend_on_schedules_group ,

               bk_schedule = s.bk_schedule ,

               targettoload = s.bk_group + '-' + s.bk_src_layer ,

               scheduletype = 'GroupSRCLayer' ,

               excludefromalllevel = isnull(s.excludefromalllevel, 0) ,

               excludefromallother = isnull(s.excludefromallother, 0) ,

               processsourcedependencies = isnull(s.processsourcedependencies, 0)

          FROM rep.vw_schedules s

         WHERE 1 = 1

           AND isnull(s.[bk_srcdataset], '') = ''

           AND isnull(s.[src_shortname], '') = ''

           AND isnull(s.[bk_trndataset], '') = ''

           AND isnull(s.[bk_group] , '') != ''

           AND isnull(s.[bk_schema], '') = ''

           AND isnull(s.[bk_layer] , '') = ''

           AND isnull(s.[bk_src_layer], '') != ''

     UNION ALL -- Load ShortNameGroup
 SELECT bk = concat(s.bk, '|', s.src_shortname + '-' + s.[bk_layer]) ,

               schedules_group ,

               dependend_on_schedules_group ,

               bk_schedule = s.bk_schedule ,

               targettoload = s.src_shortname + '-' + s.[bk_layer] ,

               scheduletype = 'ShortNameGroup' ,

               excludefromalllevel = isnull(s.excludefromalllevel, 0) ,

               excludefromallother = isnull(s.excludefromallother, 0) ,

               processsourcedependencies = isnull(s.processsourcedependencies, 0)

          FROM rep.vw_schedules s

         WHERE 1 = 1

           AND isnull(s.[bk_srcdataset], '') = ''

           AND isnull(s.[src_shortname], '') != ''

           AND isnull(s.[bk_trndataset], '') = ''

           AND isnull(s.[bk_group] , '') = ''

           AND isnull(s.[bk_schema], '') = ''

           AND isnull(s.[bk_layer] , '') != ''

           AND isnull(s.[bk_src_layer], '') = ''

     UNION ALL -- Load ShortNameGroup
 SELECT bk = concat(s.bk, '|', s.src_shortname + '-' + s.bk_group + '-' + s.[bk_layer]) ,

               schedules_group ,

               dependend_on_schedules_group ,

               bk_schedule = s.bk_schedule ,

               targettoload = s.src_shortname + '-' + s.bk_group + '-' + s.[bk_layer] ,

               scheduletype = 'ShortNameGroupLayer' ,

               excludefromalllevel = isnull(s.excludefromalllevel, 0) ,

               excludefromallother = isnull(s.excludefromallother, 0) ,

               processsourcedependencies = isnull(s.processsourcedependencies, 0)

          FROM rep.vw_schedules s

         WHERE 1 = 1

           AND isnull(s.[bk_srcdataset], '') = ''

           AND isnull(s.[src_shortname], '') != ''

           AND isnull(s.[bk_trndataset], '') = ''

           AND isnull(s.[bk_group] , '') != ''

           AND isnull(s.[bk_schema], '') = ''

           AND isnull(s.[bk_layer] , '') != ''

           AND isnull(s.[bk_src_layer], '') = ''

     UNION ALL -- export to file
 SELECT bk = concat(s.bk, '|', s.bk_export) ,

               schedules_group ,

               dependend_on_schedules_group ,

               bk_schedule = s.bk_schedule ,

               targettoload = s.bk_export ,

               scheduletype = 'export-file' ,

               excludefromalllevel = isnull(s.excludefromalllevel, 0) ,

               excludefromallother = isnull(s.excludefromallother, 0) ,

               processsourcedependencies = isnull(s.processsourcedependencies, 0)

          FROM rep.vw_schedules s

         WHERE 1 = 1

           AND isnull(s.[bk_export], '') != ''
       )
SELECT bk = src.bk ,

       schedules_group = src.schedules_group ,

       dependend_on_schedules_group = src.dependend_on_schedules_group ,

       code = src.bk ,

       bk_schedule = src.bk_schedule ,

       targettoload = src.targettoload ,

       scheduletype = src.scheduletype ,

       excludefromalllevel = src.excludefromalllevel ,

       excludefromallother = src.excludefromallother ,

       processsourcedependencies = src.processsourcedependencies

  FROM allschedules src

 WHERE 1 = 1 --and BK = 'pl_customer_ws.csv.gz'
