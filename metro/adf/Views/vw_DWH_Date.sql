
CREATE VIEW [adf].[vw_dwh_date] AS /*
Description:
	Date Table from 2010-01-01 till 2039-12-31

*/
SELECT src.*,

       repositorystatusname = sdtap.repositorystatus,

       repositorystatuscode = sdtap.repositorystatuscode,

       environment = sdtap.repositorystatus

  FROM [adf].[dwh_date] src

 CROSS JOIN [adf].[vw_sdtap] sdtap

 WHERE 1 = 1

   AND sdtap.repositorystatuscode > -2
