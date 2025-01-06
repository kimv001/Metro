
CREATE VIEW [adf].[vw_schema] AS
SELECT src.bk,

       src.code,

       src.name,

       src.bk_schema,

       src.bk_layer,

       src.bk_datasource,

       src.bk_linkedservice,

       src.schemacode,

       src.schemaname,

       src.datasourcecode,

       src.datasourcename,

       src.bk_datasourcetype,

       src.datasourcetypecode,

       src.datasourcetypename,

       src.layercode,

       src.layername,

       src.layerorder,

       src.isdwh,

       src.issrc,

       src.istgt,

       src.isrep,

       src.linkedservicecode,

       src.linkedservicename,

       src.bk_template_create,

       src.bk_template_load,

       src.bk_reftype_tochar,

       repositorystatusname = env.repositorystatus,

       repositorystatuscode = env.repositorystatuscode,

       environment = env.environment

  FROM bld.vw_schema src

 CROSS JOIN [adf].[vw_sdtap] env
