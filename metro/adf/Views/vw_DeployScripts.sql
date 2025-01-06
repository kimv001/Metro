
CREATE VIEW adf.vw_deployscripts AS
SELECT src.bk,

       src.code,

       src.bk_template,

       src.bk_dataset,

       src.tgt_objectname,

       src.objecttype,

       src.objecttypedeployorder,

       src.templatetype,

       src.scriptlanguagecode,

       src.scriptlanguage,

       src.templatesource,

       src.templatename,

       src.templatescript,

       repositorystatusname = env.repositorystatus,

       repositorystatuscode = env.repositorystatuscode,

       environment = env.environment

  FROM bld.vw_deployscripts src

 CROSS JOIN adf.vw_sdtap env
