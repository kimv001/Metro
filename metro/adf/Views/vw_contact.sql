
CREATE VIEW [adf].[vw_contact] AS
SELECT src.[contactid],

       src.[bk],

       src.[code],

       src.[bk_contactgroup],

       src.[contactgroup],

       src.[contactrole],

       src.[main_contact],

       src.[contactperson_name],

       src.[contactperson_department],

       src.[contacperson_phonenumber],

       src.[contactperson_mailadress],

       src.[contactperson_active],

       repositorystatusname = sdtap.repositorystatus,

       repositorystatuscode = sdtap.repositorystatuscode,

       environment = sdtap.repositorystatus

  FROM [bld].[vw_contact] src

 CROSS JOIN adf.vw_sdtap sdtap

 WHERE 1 = 1

   AND sdtap.repositorystatuscode > -2
