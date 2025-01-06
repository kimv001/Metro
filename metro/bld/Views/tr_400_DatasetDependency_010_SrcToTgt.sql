
CREATE VIEW [bld].[tr_400_datasetdependency_010_srctotgt] AS /*
=== Comments =========================================

Description:
	Get all repository defined dependencies from Src to Tgt

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/ WITH base AS

        (SELECT d.[bk] ,

               d.[code] ,

               d.[datasetname] ,

               [floworder] = cast(d.[floworder] AS int) ,

               [dependencyorder] = cast(rank() OVER (PARTITION BY d.[code]
                                                ORDER BY cast(d.[floworder] AS int) ASC) AS int) --, [DependencyOrder]				= cast(dense_RANK() over (partition by d.[Code]  order by cast(d.[FlowOrder] as int) asc) as int)
 ,

               d.[bk_reftype_objecttype] ,

               d.[bk_reftype_repositorystatus] ,

               d.[mta_bkh]

          FROM [bld].[vw_dataset] d

         WHERE 1 = 1 --and d.code = 'BI|Base||IB|AggregatedPc4|'
 --and d.bk = 'DWH|stg||IB|AggregatedPc4|'
 --and d.code = 'DWH|aud_dim|trvs|monitor|schedule|'
 --and d.bk = 'DWH|csl|dim_vw|monitor|schedule|'
 --  and d.code  = 'BI|Base||IB|AggregatedPc4|'
 --and d.[BK_RefType_TableType] != 'OT|V|View'

       ),

       hierarchie AS

        (--
 SELECT bk_child = cast('SRC' AS varchar(255)) ,

               bk_parent = p.[bk] ,

               code = p.code ,

               tabletypechild = cast('SRC' AS varchar(255)) ,

               tabletypeparent = p.[bk_reftype_objecttype] ,

               p.[dependencyorder]

          FROM base p

         WHERE [dependencyorder] = 1

     UNION ALL SELECT bk_child = p.bk_parent ,

               bk_parent = c.bk ,

               code = c.code ,

               tabletypesource = p.tabletypeparent ,

               tabletypeparent = c.[bk_reftype_objecttype] ,

               c.[dependencyorder]

          FROM base c

          JOIN hierarchie p
            ON c.code = p.code

           AND c.[dependencyorder] = p.[dependencyorder] + 1
       ) --select * from Hierarchie

SELECT bk = h.bk_child + '|' + bk_parent ,

       bk_parent = bk_child ,

       bk_child = bk_parent ,

       [code] ,

       tabletypeparent = tabletypechild ,

       tabletypechild = tabletypeparent ,

       dependencytype = 'SrcToTgt'

  FROM hierarchie h
