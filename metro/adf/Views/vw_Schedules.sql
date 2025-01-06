
CREATE VIEW [adf].[vw_schedules] AS
SELECT src.bk ,

       src.code ,

       src.bk_schedule ,

       src.targettoload ,

       src.scheduletype --, src.ReloadIfAlreadyLoaded
 ,

       repositorystatusname = sdtap.repositorystatus ,

       repositorystatuscode = sdtap.repositorystatuscode ,

       environment = sdtap.environment

  FROM bld.vw_schedules src

 CROSS JOIN adf.vw_sdtap sdtap