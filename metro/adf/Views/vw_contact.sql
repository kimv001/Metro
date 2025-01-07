






CREATE VIEW [adf].[vw_contact] AS

SELECT 
	  src.[ContactId]
	, src.[bk]
	, src.[code]
	, src.[bk_contactgroup]
	, src.[contactgroup]
	, src.[contactrole]
	, src.[main_contact]
	, src.[contactperson_name]
	, src.[contactperson_department]
	, src.[contacperson_phonenumber]
	, src.[contactperson_mailadress]
	, src.[contactperson_active]
	, RepositoryStatusName	= SDTAP.RepositoryStatus
	, RepositoryStatusCode	= SDTAP.RepositoryStatusCode 
	, Environment			= SDTAP.RepositoryStatus

  FROM [bld].[vw_Contact] src
CROSS JOIN ADF.vw_SDTAP SDTAP
WHERE 1=1
	AND SDTAP.RepositoryStatusCode > -2