
CREATE VIEW [adf].[vw_tgt_export_from_src] AS
SELECT tgt = e.[export_name],

       src_bk_dataset = e.bk_dataset,

       [src_dataset] = e.[export_name], --e.src_dataset,
 [src_shortname] = e.src_shortname,

       src_sourcename = e.[export_name], --e.SRC_Group + '_' +  e.SRC_ShortName,
 src_datasettype = e.src_datasettype,

       tgt_datasettype = 'File',

       [src_group] = e.src_group,

       [src_schema] = e.src_schema,

       [src_layer] = e.src_layer,

       generation_number = 1, --DENSE_RANK() over(partition by [TGT_Group] order by [generation_number])
 dependencytype = 'export-file',

       [repositorystatusname] = e.repositorystatusname,

       [repositorystatuscode] = e.repositorystatuscode -- select *

  FROM bld.vw_exports e
