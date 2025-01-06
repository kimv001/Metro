
CREATE VIEW [adf].[vw_sdtap] AS
SELECT bk_repositorystatus = bk ,

       repositorystatus = rt.[name] ,

       environment = rt.[name] ,

       repositorystatuscode = CASE
                                  WHEN isnumeric(rt.code) = 1 THEN cast(rt.code AS int)

            ELSE 0

             END

  FROM bld.vw_reftype rt

 WHERE 1 = 1

   AND reftype = 'RepositoryStatus'