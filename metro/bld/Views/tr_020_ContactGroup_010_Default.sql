
CREATE VIEW [bld].[tr_020_contactgroup_010_default] AS /*
=== Comments =========================================

Description:
	 List of Contact Groups

Changelog:
Date		time		Author					Description
20241004	1603		K. Vermeij				Initial
=======================================================
*/
SELECT src.[bk] ,

       src.[code] ,

       src.[name] ,

       src.[description] ,

       src.[active]

  FROM [rep].[vw_contactgroup] src

 WHERE 1 = 1

   AND isnull(src.active, '1') = 1

   AND src.bk IS NOT NULL
