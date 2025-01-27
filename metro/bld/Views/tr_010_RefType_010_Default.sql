



CREATE VIEW [bld].[tr_010_RefType_010_Default] AS
/* 
=== Comments =========================================

Description:
    This view is the first in a batch of transformation views that prepares all metadata to create DDL scripts for all needed data warehouse objects. 
	It selects and transforms reference type data from the [rep].[vw_RefType] view, including linked reference types and default values.

	The reference types are defined in the input datasheet and its a collection of all kind of refenece types that are used in the datawarehouse.

Columns:
    - BK: The business key of the reference type.
    - Code: The code of the reference type.
    - Name: The name of the reference type.
    - Description: The description of the reference type.
    - RefType: The type of the reference.
    - RefTypeAbbr: The abbreviation of the reference type.
    - SortOrder: The sort order of the reference type.
    - LinkedReftype: The linked reference type.
    - BK_LinkedRefType: The business key of the linked reference type.
    - LinkedRefTypeCode: The code of the linked reference type.
    - LinkedRefTypeName: The name of the linked reference type.
    - LinkedRefTypeDescription: The description of the linked reference type.
    - DefaultValue: The default value for the reference type if it is a 'DataType'.
    - isDefault: Indicates if the reference type is a default, except for 'DataType'.

Example Usage:
    SELECT * FROM [bld].[tr_010_RefType_010_Default]

Logic:
    1. Selects reference type data from the [rep].[vw_RefType] view.
    2. Joins with the same view to get linked reference type data.
    3. Filters active reference types and ensures the business key is not null.
    4. Transforms the data to include default values and linked reference type information.
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230326	1315		K. Vermeij				Added [isDefault]
=======================================================
*/
SELECT   
	  rt.BK
	, rt.Code
	, rt.[Name]
	, rt.[Description]
	, rt.RefType
	, rt.RefTypeAbbr
	, rt.SortOrder
	, rt.LinkedReftype
	, rt.BK_LinkedRefType
	, LinkedRefTypeCode			= rtP.[Code]
	, LinkedRefTypeName			= rtP.[Name]
	, LinkedRefTypeDecription	= rtP.[Description]
	, DefaultValue				= CASE WHEN  rt.RefType = 'DataType' THEN rt.[Default] ELSE null END
	, isDefault					= CASE WHEN  rt.RefType = 'DataType' THEN null ELSE rt.[Default] END
	
FROM rep.vw_RefType rt
LEFT JOIN rep.vw_RefType rtP ON rt.LinkedReftype = rtP.RefTypeAbbr AND rt.BK_LinkedRefType = rtP.BK
WHERE 1=1
  AND isnull( rt.Active,'1')=1
  AND rt.bk IS NOT null
 -- and (rt.BK = 'DST|SQL_SYN|' or rt.BK = 'SL|SQLSYN|')