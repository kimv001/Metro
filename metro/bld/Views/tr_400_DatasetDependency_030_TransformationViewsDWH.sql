



CREATE VIEW [bld].[tr_400_DatasetDependency_030_TransformationViewsDWH] AS 
/* 
=== Comments =========================================

Description:
    Dependencies gathered from the transformation views in the Data Warehouse will be added to the DatasetDependencies. This view builds up dataset dependencies from source system information schema dependencies.

Columns:
    - BK: The business key of the dependency.
    - BK_PARENT: The business key of the parent dataset.
    - BK_CHILD: The business key of the child dataset.
    - CODE: The code of the dataset.
    - TABLETYPEPARENT: The type of the parent dataset.
    - TABLETYPECHILD: The type of the child dataset.
    - DEPENDENCYTYPE: The type of the dependency (SrcToTgt).

Example Usage:
    SELECT * FROM [bld].[tr_400_DatasetDependency_030_TransformationViewsDWH]

Logic:
    1. Selects dependencies from the [stg].[DWH_ReferencingObjects] view.
    2. Joins with the [bld].[vw_Dataset] view to get dataset information.
    3. Left joins with the [bld].[vw_DatasetDependency] view to exclude existing dependencies.
    4. Selects and formats the final dataset dependencies.

Source Data:
    - [stg].[DWH_ReferencingObjects]: Contains information about referencing objects in the data warehouse.
    - [bld].[vw_Dataset]: Contains dataset definitions.
    - [bld].[vw_DatasetDependency]: Contains existing dataset dependencies.
	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20241018    1500        K. Vermeij              Based left join  on [bld].[DatasetDependency] instead of [bld].[tr_400_DatasetDependency_010_SrcToTgt]
=======================================================
*/




SELECT  DISTINCT
	  BK				= Concat(D_SRC.BK,'|',D_TGT.BK)
	, BK_PARENT			= D_SRC.BK
	, BK_CHILD			= D_TGT.BK
	
	, CODE				= D_SRC.CODE
	, TABLETYPEPARENT	= D_SRC.[BK_RefType_ObjectType]
	, TABLETYPECHILD	= D_TGT.[BK_RefType_ObjectType]
	, DEPENDENCYTYPE	= 'SrcToTgt'
	
FROM [stg].[DWH_ReferencingObjects] SRC
--From [stg_in_dwh].[Dependencies] src
JOIN BLD.VW_DATASET D_SRC ON D_SRC.DATASETNAME = SRC.[ReferencedObject]
JOIN BLD.VW_DATASET D_TGT ON D_TGT.DATASETNAME = SRC.[ReferencingObject]
LEFT JOIN
    [bld].[vw_DatasetDependency] DD
ON DD.BK_PARENT = D_SRC.BK AND DD.BK_CHILD = D_TGT.BK AND DD.DEPENDENCYTYPE	= 'SrcToTgt' AND DD.MTA_SOURCE = '[bld].[tr_400_DatasetDependency_010_SrcToTgt]'
--left join [bld].[tr_400_DatasetDependency_010_SrcToTgt] DD on DD.BK_Parent = D_SRC.BK and DD.BK_Child = D_TGT.BK and DD.DependencyType	= 'SrcToTgt'
WHERE 1=1
AND DD.BK IS null