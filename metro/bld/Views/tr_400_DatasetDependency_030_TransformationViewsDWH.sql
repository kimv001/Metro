
CREATE VIEW [bld].[tr_400_datasetdependency_030_transformationviewsdwh] AS /*
=== Comments =========================================

Description:
	Dependencies gathered from the transaformation views in the Data Warehouse will be added to the DatasetDependencies.

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20241018    1500        K. Vermeij              Based left join  on [bld].[DatasetDependency] instead of [bld].[tr_400_DatasetDependency_010_SrcToTgt]
=======================================================
*/
SELECT DISTINCT bk = concat(d_src.bk, '|', d_tgt.bk) ,

       bk_parent = d_src.bk ,

       bk_child = d_tgt.bk ,

       code = d_src.code ,

       tabletypeparent = d_src.[bk_reftype_objecttype] ,

       tabletypechild = d_tgt.[bk_reftype_objecttype] ,

       dependencytype = 'SrcToTgt'

  FROM [stg].[dwh_referencingobjects] src --From [stg_in_dwh].[Dependencies] src

  JOIN bld.vw_dataset d_src
    ON d_src.datasetname = src.[referencedobject]

  JOIN bld.vw_dataset d_tgt
    ON d_tgt.datasetname = src.[referencingobject]

  LEFT JOIN [bld].[vw_datasetdependency] dd
    ON dd.bk_parent = d_src.bk

   AND dd.bk_child = d_tgt.bk

   AND dd.dependencytype = 'SrcToTgt'

   AND dd.mta_source = '[bld].[tr_400_DatasetDependency_010_SrcToTgt]' --left join [bld].[tr_400_DatasetDependency_010_SrcToTgt] DD on DD.BK_Parent = D_SRC.BK and DD.BK_Child = D_TGT.BK and DD.DependencyType	= 'SrcToTgt'

 WHERE 1 = 1

   AND dd.bk IS NULL
