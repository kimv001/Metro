





CREATE VIEW [bld].[tr_025_Contact_010_Default] AS
/* 
=== Comments =========================================

Description:
    This view provides a list of active contacts with their associated contact groups and roles from various reference views. It ensures that only active contacts with non-null business keys are included.

Columns:
    - BK: The business key of the contact.
    - Code: The code of the contact.
    - BK_CONTACTGROUP: The business key of the contact group.
    - CONTACTGROUP: The name of the contact group.
    - CONTACTROLE: The name of the contact role.
    - MAIN_CONTACT: Indicates if the contact is the main contact.
    - ALERT_CONTACT: Indicates if the contact is an alert contact.
    - CONTACTPERSON_NAME: The name of the contact person.
    - CONTACTPERSON_DEPARTMENT: The department of the contact person.
    - CONTACTPERSON_PHONENUMBER: The phone number of the contact person.
    - CONTACTPERSON_MAILADRESS: The mail address of the contact person.
    - CONTACTPERSON_ACTIVE: Indicates if the contact person is active.
    - RN_CONTACT: Row number for partitioning contacts.

Example Usage:
    SELECT * FROM [bld].[tr_025_Contact_010_Default]

Logic:
    1. Selects contact role data from the [rep].[vw_RefType] view where the reference type abbreviation is 'CR'.
    2. Selects contact data from the [rep].[vw_Contact] view.
    3. Joins with the [rep].[vw_ContactGroup] view to get contact group data.
    4. Left joins with the [rep].[vw_ContactPerson] view to get contact person data.
    5. Left joins with the contact roles data.
    6. Filters active contacts and ensures the business key is not null.
    7. Uses row numbering to ensure unique contacts.
	
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