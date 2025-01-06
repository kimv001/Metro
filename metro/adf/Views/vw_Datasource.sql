
CREATE VIEW [adf].[vw_datasource] AS
SELECT src.bk_datasource,

       src.isdwh,

       src.isrep,

       src.datasourceserver,

       src.datasourcedatabase,

       src.datasourceurl,

       src.datasourceusr,

       src.environment,

       rt.code AS repositorystatus

  FROM adf.vw_datasourceproperties_sdtap_values src

  JOIN rep.vw_reftype rt
    ON rt.name = src.environment

 WHERE src.isdwh = 1
