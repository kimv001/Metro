
CREATE VIEW [adf].[vw_dataset] AS
SELECT src.bk,

       src.code,

       src.datasetname AS datasetname_old,

       CASE
           WHEN src.layername = 'src' THEN concat('[', src.schemaname, '].[', src.bk_group, '_', src_shortname, ']')

            ELSE src.datasetname

             END AS datasetname,

       src.schemaname,

       src.layername,

       src.datasource,

       src.bk_linkedservice,

       src.linkedservicename,

       src.bk_datasource,

       src.bk_layer,

       src.bk_schema,

       src.bk_group,

       src.shortname,

       src.src_shortname,

       src.src_objecttype,

       src.dwhtargetshortname,

       src.prefix,

       src.postfix,

       src.[description],

       src.[description] AS dataset_description,

       src.[bk_contactgroup],

       src.[bk_contactgroup_data_logistics],

       src.[data_logistics_info],

       src.[bk_contactgroup_data_supplier],

       src.[data_supplier_info],

       src.[view_defintion_contains_business_logic],

       src.[view_defintion],

       src.bk_flow,

       src.floworder,

       src.[timestamp],

       src.businessdate,

       src.wherefilter,

       src.partitionstatement,

       src.bk_reftype_objecttype,

       src.fullload,

       src.insertonly,

       src.bigdata,

       src.bk_template_load,

       src.bk_template_create,

       src.customstagingview,

       src.bk_reftype_repositorystatus,

       src.issystem,

       src.firstdefaultdwhview,

       src.replaceattributenames,

       src.datasettype,

       src.objecttype,

       src.repositorystatusname,

       src.repositorystatuscode,

       src.isdwh,

       src.issrc,

       src.istgt -- filesource properties
,

       fp.[filemask],

       fp.[filename],

       fp.[filesystem],

       fp.[folder],

       fp.[ispgp],

       fp.expectedfilecount,

       fp.[expectedfilesize],

       fp.[bk_schedule_fileexpected],

       fp.[dateinfilenameformat],

       fp.[dateinfilenamelength],

       fp.[dateinfilenamestartpos],

       fp.[dateinfilenameexpression] -- meta data
,

       src.mta_rectype,

       src.mta_createdate,

       src.mta_source,

       src.mta_bk,

       src.mta_bkh,

       src.mta_rh,

       src.mta_isdeleted,

       env.environment

  FROM bld.vw_dataset src

 CROSS JOIN [adf].[vw_sdtap] env

  LEFT JOIN bld.vw_fileproperties fp
    ON fp.bk = src.bk --where datasetname = '[sto].[FactMomsMdf]'
