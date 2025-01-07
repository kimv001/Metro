



CREATE VIEW [bld].[tr_400_DatasetDependency_030_TransformationViewsDWH] AS 
/* 
=== Comments =========================================

Description:
	Dependencies gathered from the transaformation views in the Data Warehouse will be added to the DatasetDependencies.
	
	
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