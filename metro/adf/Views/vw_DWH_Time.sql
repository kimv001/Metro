
CREATE VIEW [adf].[vw_dwh_time] AS /*
Description:
	Time Table in HH:MM

*Note
	SS and MS came along, but always 0
*/
SELECT src.*,

       repositorystatusname = sdtap.repositorystatus,

       repositorystatuscode = sdtap.repositorystatuscode,

       environment = sdtap.repositorystatus

  FROM [adf].[dwh_time] src

 CROSS JOIN [adf].[vw_sdtap] sdtap

 WHERE 1 = 1

   AND sdtap.repositorystatuscode > -2
