



CREATE VIEW [bld].[tr_020_ContactGroup_010_Default] AS
/* 
=== Comments =========================================

Description:
    This view provides a list of active contact groups from the [rep].[vw_ContactGroup] view. It filters out inactive contact groups and ensures that the business key is not null.

Columns:
    - BK: The business key of the contact group.
    - Code: The code of the contact group.
    - Name: The name of the contact group.
    - Description: The description of the contact group.
    - Active: Indicates if the contact group is active.

Example Usage:
    SELECT * FROM [bld].[tr_020_ContactGroup_010_Default]

Logic:
    1. Selects contact group data from the [rep].[vw_ContactGroup] view.
    2. Filters active contact groups and ensures the business key is not null.
	
Changelog:
Date		time		Author					Description
20241004	1603		K. Vermeij				Initial
=======================================================
*/
SELECT 
	 src.[BK]
	,src.[Code]
	,src.[Name]
	,src.[Description]
	,src.[Active]
FROM [rep].[vw_ContactGroup] src
WHERE 1=1
  AND isnull( src.active,'1')=1
  AND src.bk IS NOT null