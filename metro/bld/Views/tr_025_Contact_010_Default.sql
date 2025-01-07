





CREATE VIEW [bld].[tr_025_Contact_010_Default] AS
/* 
=== Comments =========================================

Description:
	 List of Contact Persons
	
Changelog:
Date		time		Author					Description
20241004	1603		K. Vermeij				Initial
=======================================================
*/
WITH CONTACTROLES AS (
SELECT [BK]
      ,[Code]
      ,[Name]
     
      ,[Description]
      ,[RefType]
      ,[RefTypeAbbr]
      ,[SortOrder]
FROM [rep].[vw_RefType]
WHERE [RefTypeAbbr] = 'CR'


)
, FINAL AS (
SELECT 
	SRC.BK
	, SRC.CODE
	, SRC.BK_CONTACTGROUP
	, CONTACTGROUP						= CG.[name]
	, CONTACTROLE						= CR.[name]
	, MAIN_CONTACT						= SRC.MAIN_CONTACT
	, ALERT_CONTACT						= SRC.ALERT_CONTACT
	, CONTACTPERSON_NAME				= CP.[contact_name]
	, CONTACTPERSON_DEPARTMENT			= CP.[contact_department]
	, CONTACPERSON_PHONENUMBER			= CP.[contact_phone_number]
	, CONTACTPERSON_MAILADRESS			= CP.[contact_mail_address]
	, CONTACTPERSON_ACTIVE				= CP.[Active]
	, RN_CONTACT						= ROW_NUMBER() OVER (PARTITION BY SRC.BK ORDER BY SRC.BK ASC)
	-- select *
FROM [rep].[vw_Contact] SRC
JOIN REP.VW_CONTACTGROUP CG ON SRC.BK_CONTACTGROUP = CG.BK
LEFT JOIN [rep].[vw_ContactPerson] CP ON SRC.BK_CONTACTPERSON = CP.BK
LEFT JOIN CONTACTROLES CR ON SRC.BK_CONTACTROLE = CR.BK
WHERE 1=1
  AND isnull( SRC.ACTIVE,'1')=1
  AND SRC.BK IS NOT null
  )
  SELECT * FROM FINAL WHERE RN_CONTACT = 1