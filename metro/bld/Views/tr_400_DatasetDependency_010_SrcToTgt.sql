
CREATE view [bld].[tr_400_DatasetDependency_010_SrcToTgt] as
/* 
=== Comments =========================================

Description:
	Get all repository defined dependencies from Src to Tgt
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/
With base as 
	(
	SELECT 
		  d.[BK]
		, d.[Code]

		, d.[DatasetName]
      
		, [FlowOrder]					= cast(d.[FlowOrder] as int)
		, [DependencyOrder]				= cast(RANK() over (partition by d.[Code]  order by cast(d.[FlowOrder] as int) asc) as int)
		--, [DependencyOrder]				= cast(dense_RANK() over (partition by d.[Code]  order by cast(d.[FlowOrder] as int) asc) as int)
		, d.[BK_RefType_ObjectType]
		, d.[BK_RefType_RepositoryStatus]
		
		, d.[mta_BKH]
      
	  FROM [bld].[vw_Dataset] d
	where 1=1
	--and d.code = 'BI|Base||IB|AggregatedPc4|'
	--and d.bk = 'DWH|stg||IB|AggregatedPc4|'
	--and d.code = 'DWH|aud_dim|trvs|monitor|schedule|'
	--and d.bk = 'DWH|csl|dim_vw|monitor|schedule|'
	--  and d.code  = 'BI|Base||IB|AggregatedPc4|'
	  --and d.[BK_RefType_TableType] != 'OT|V|View'
	  
	  )
,  Hierarchie aS (
	-- 
	SELECT 
		
		  BK_Child			= cast('SRC' as varchar(255))
		, BK_Parent			= P.[BK] 
		, Code				= P.Code
		, TableTypeChild	= cast('SRC' as varchar(255))
		, TableTypeParent	= p.[BK_RefType_ObjectType]
		, P.[DependencyOrder] 
		
	From base P
	Where [DependencyOrder] = 1
	UNION all

	Select 
		   
		BK_Child			= P.BK_Parent
		, BK_Parent			= c.BK
		, Code				= c.Code
		, TableTypeSource	= p.TableTypeParent
		, TableTypeParent	= c.[BK_RefType_ObjectType]
		, C.[DependencyOrder]
	from base c
	join Hierarchie P on C.Code = P.Code
					
					and c.[DependencyOrder] = p.[DependencyOrder] +1
	)
	--select * from Hierarchie
select 
	BK			= H.BK_Child+'|'+BK_Parent
	
	, BK_Parent	 = BK_Child
	, BK_Child	 = BK_Parent
	, [Code]
	, TableTypeParent = TableTypeChild
	, TableTypeChild = TableTypeParent

	
	, DependencyType = 'SrcToTgt'

from Hierarchie H