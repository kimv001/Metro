



CREATE view [bld].[tr_400_DatasetDependency_030_TransformationViewsDWH] as 
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




Select  distinct
	  BK				= Concat(D_SRC.BK,'|',D_TGT.BK)
	, BK_Parent			= D_SRC.BK
	, BK_Child			= D_TGT.BK
	
	, Code				= D_SRC.Code
	, TableTypeParent	= D_SRC.[BK_RefType_ObjectType]
	, TableTypeChild	= D_TGT.[BK_RefType_ObjectType]
	, DependencyType	= 'SrcToTgt'
	
from [stg].[DWH_ReferencingObjects] src
--From [stg_in_dwh].[Dependencies] src
join bld.vw_Dataset D_SRC on D_SRC.DatasetName = src.[ReferencedObject]
join bld.vw_Dataset D_TGT on D_TGT.DatasetName = src.[ReferencingObject]
left join [bld].[vw_DatasetDependency] DD on DD.BK_Parent = D_SRC.BK and DD.BK_Child = D_TGT.BK and DD.DependencyType	= 'SrcToTgt' and dd.mta_Source = '[bld].[tr_400_DatasetDependency_010_SrcToTgt]'
--left join [bld].[tr_400_DatasetDependency_010_SrcToTgt] DD on DD.BK_Parent = D_SRC.BK and DD.BK_Child = D_TGT.BK and DD.DependencyType	= 'SrcToTgt'
Where 1=1
and DD.BK is null