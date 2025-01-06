
CREATE VIEW [bld].[tr_420_loaddependency_010_srctotgt] AS /*
=== Comments =========================================

Description:
	Get all source dependencies for 1 target

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20240424	1430		K. Vermeij				Added DependencyType
20240424	1730		K. Vermeij				Removed filter "and src.LayerName != 'src'"
=======================================================
*/  WITH base AS

        (-- get the full list of dependencies
 SELECT --top 0
 bk_source = dd.bk_parent ,

               bk_target = dd.bk_child -- make the views look like tables (remove prefix and postfix)
 ,

               bk_targetclean = concat(tgt.bk_schema, '||', tgt.bk_group, '|', tgt.shortname, '|') ,

               bk_sourceclean = concat(src.bk_schema, '||', src.bk_group, '|', src.shortname, '|') ,

               dependencytype = dd.dependencytype

          FROM bld.vw_datasetdependency dd

          JOIN bld.vw_dataset src
            ON src.bk = dd.bk_child

          JOIN bld.vw_dataset tgt
            ON tgt.bk = dd.bk_parent

         WHERE 1 = 1

           AND dependencytype = 'SrcToTgt'
       ),

       rebase AS

        (-- join the "cleaned" businesskeys
 SELECT bk_target = tgt.bk ,

               bk_source = src.bk ,

               dependencytype = b.dependencytype

          FROM base b

          JOIN bld.vw_dataset src
            ON src.bk = b.bk_sourceclean

          JOIN bld.vw_dataset tgt
            ON tgt.bk = b.bk_targetclean

         WHERE src.bk <> tgt.bk
       ) ,

       tgtfromsrc AS

        (SELECT bk_target bk_target,

               bk_source,

               1 AS lvl,

               dependencytype

          FROM rebase

     UNION ALL SELECT d.bk_target,

               s.bk_source,

               d.lvl + 1 AS lvl,

               d.dependencytype

          FROM tgtfromsrc d

          JOIN rebase s
            ON d.bk_source = s.bk_target
       ) ,

       uniquetgtfromsrc AS

        (SELECT bk_target,

               bk_source,

               max(lvl) lvl,

               dependencytype

          FROM tgtfromsrc

         GROUP BY bk_target,

                  bk_source,

                  dependencytype -- add parents as source

     UNION ALL SELECT DISTINCT src.bk_target bk_target,

               src.bk_target bk_source,

               -100 AS lvl,

               dependencytype

          FROM tgtfromsrc src

         WHERE 1 = 1

           AND src.lvl = 1
       ),

       FINAL AS

        (SELECT bk = b.dependencytype + '|' + tgt.bk + '|' + src.bk ,

               code = tgt.code ,

               bk_target = tgt.bk ,

               tgt_layer = tgt.layername ,

               tgt_schema = tgt.schemaname ,

               tgt_group = tgt.bk_group ,

               tgt_shortname = tgt.shortname ,

               tgt_code = tgt.code ,

               tgt_datasetname = tgt.datasetname ,

               bk_source = src.bk ,

               src_layer = src.layername ,

               src_schema = src.schemaname ,

               src_group = src.bk_group ,

               src_shortname = src.shortname ,

               src_code = src.code ,

               src_datasetname = src.datasetname ,

               dependencytype = b.dependencytype ,

               generation_number = row_number() OVER (PARTITION BY tgt.bk
                                                 ORDER BY b.lvl ASC)

          FROM uniquetgtfromsrc b

          JOIN bld.vw_dataset src
            ON src.bk = b.bk_source

          JOIN bld.vw_dataset tgt
            ON tgt.bk = b.bk_target

         WHERE 1 = 1 -- and src.LayerName != 'src'
 --and src.DatasetName != tgt.DatasetName
 --and tgt.BK+'|'+src.BK = 'DWH|fct||IB|EUA||DWH|fct||IB|EUA|'
 --  and tgt.DatasetName= '[dim].[Common_Address]'
 -- and tgt.BK+'|'+src.BK  = 'DWH|fct||Wes|WeasEuaIb||SA_DWH|src_file||Wes|EUA|'
 --and tgt.BK='DWH|pst||IB|AggregatedPc4|'

       )
SELECT *

  FROM FINAL
