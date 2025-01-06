



CREATE view [bld].[tr_020_ContactGroup_010_Default] as
/* 
=== Comments =========================================

Description:
	 List of Contact Groups
	
Changelog:
Date		time		Author					Description
20241004	1603		K. Vermeij				Initial
=======================================================
*/
select 
	 src.[BK]
	,src.[Code]
	,src.[Name]
	,src.[Description]
	,src.[Active]
from [rep].[vw_ContactGroup] src
Where 1=1
  and isnull( src.Active,'1')=1
  and src.bk is not null