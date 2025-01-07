



CREATE VIEW [bld].[tr_020_ContactGroup_010_Default] AS
/* 
=== Comments =========================================

Description:
	 List of Contact Groups
	
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