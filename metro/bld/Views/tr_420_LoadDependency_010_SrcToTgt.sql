
CREATE view [bld].[tr_420_LoadDependency_010_SrcToTgt] as
/* 
=== Comments =========================================

Description:
	Get all source dependencies for 1 target
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20240424	1430		K. Vermeij				Added DependencyType
20240424	1730		K. Vermeij				Removed filter "and src.LayerName != 'src'"
=======================================================
*/
  with base as (
	 -- get the full list of dependencies
	select --top 0
			   BK_Source		= dd.BK_Parent
			 , BK_Target		= dd.BK_Child

			 -- make the views look like tables (remove prefix and postfix)
			 , BK_TargetClean	= concat(tgt.BK_Schema,'||',tgt.BK_Group, '|', tgt.ShortName, '|')
			 , BK_SourceClean	= concat(src.BK_Schema,'||',src.BK_Group, '|', src.ShortName, '|')
			 , DependencyType	= dd.DependencyType
	From bld.vw_DatasetDependency dd
	join bld.vw_Dataset src on src.bk = dd.BK_Child
	join bld.vw_Dataset tgt on tgt.bk = dd.BK_Parent
	where 1=1
	and DependencyType = 'SrcToTgt'
	)
, rebase as (
	-- join the "cleaned" businesskeys
	Select 
		  BK_Target			= tgt.bk
		, BK_Source			= src.bk
		, DependencyType	= b.DependencyType
	From base b
	join bld.vw_Dataset src on src.bk = b.BK_SourceClean
	join bld.vw_Dataset tgt on tgt.bk = b.BK_TargetClean
	Where src.bk <> tgt.bk

	)

, TgtFromSrc

as
  ( 
	Select BK_Target BK_Target, BK_Source, 1 as lvl, DependencyType
	From rebase

	Union all
    
	Select d.BK_Target, s.BK_Source, d.lvl + 1 as lvl, d.DependencyType
    From TgtFromSrc d
    join rebase		s on d.BK_Source = s.BK_Target
  ) 

, UniqueTgtFromSrc as (
	Select  
		BK_Target, BK_Source, max(lvl) lvl, DependencyType
	From TgtFromSrc 
	group by BK_Target, BK_Source, DependencyType
	
	-- add parents as source
	union all
	Select distinct src.BK_Target BK_Target, src.BK_Target BK_Source, -100 as lvl, DependencyType
	from TgtFromSrc src
	where 1=1 and src.lvl = 1

	

), final as (
Select
	  BK				= b.DependencyType+'|'+tgt.BK+'|'+src.BK
	, Code				= tgt.Code
	, BK_Target			= tgt.BK
	, TGT_Layer			= tgt.LayerName	
	, TGT_Schema		= tgt.SchemaName
	, TGT_Group			= tgt.BK_Group
	, TGT_ShortName		= tgt.ShortName
	, TGT_Code			= tgt.Code
	, TGT_DatasetName	= tgt.DatasetName

	, BK_Source			= src.BK
	, SRC_Layer			= src.LayerName	
	, SRC_Schema		= src.SchemaName
	, SRC_Group			= src.BK_Group
	, SRC_ShortName		= src.ShortName
	, SRC_Code			= src.Code
	, SRC_DatasetName	= src.DatasetName
	, DependencyType	= b.DependencyType
	, Generation_Number	= ROW_NUMBER() over (partition BY  tgt.BK order by b.lvl asc) 
From UniqueTgtFromSrc b
join bld.vw_Dataset src on src.bk = b.BK_Source
join bld.vw_Dataset tgt on tgt.bk = b.BK_Target

 where 1=1
-- and src.LayerName != 'src'
 --and src.DatasetName != tgt.DatasetName
 --and tgt.BK+'|'+src.BK = 'DWH|fct||IB|EUA||DWH|fct||IB|EUA|'
 --  and tgt.DatasetName= '[dim].[Common_Address]'
 -- and tgt.BK+'|'+src.BK  = 'DWH|fct||Wes|WeasEuaIb||SA_DWH|src_file||Wes|EUA|'
 --and tgt.BK='DWH|pst||IB|AggregatedPc4|'
 )
 select * from final