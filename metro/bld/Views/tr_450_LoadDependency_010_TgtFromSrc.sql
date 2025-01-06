




CREATE view [bld].[tr_450_LoadDependency_010_TgtFromSrc] as
/* 
=== Comments =========================================

Description:
	Get all source dependencies for 1 target

	*note, the target it self is also noted as a source
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20240424	1430		K. Vermeij				Added DependencyType
20240424	1730		K. Vermeij				Removed filter "and src.LayerName != 'src'"
=======================================================
*/
  with base as (
	 -- get the full list of dependencies
	select 
			   BK_Target		= dd.BK_Child
			 , BK_Source		= dd.BK_Parent

			 -- make the views look like tables (remove prefix and postfix)
			 , BK_TargetClean	= concat(tgt.BK_Schema,'||',tgt.BK_Group, '|', tgt.ShortName, '|')
			 , BK_SourceClean	= case 
			
									when src.BK_Schema = 'DWH|csl' 
										then concat(replace( src.BK_Schema,'csl', left(src.prefix,3)),'||',tgt.BK_Group, '|', tgt.ShortName, '|')
									else concat(src.BK_Schema,'||',src.BK_Group, '|', src.ShortName, '|')
									end 
			
			 , DependencyType	= 'TgtFromSrc' -- sorry later on, this is shuffled...
	From bld.vw_DatasetDependency dd
	join bld.vw_Dataset src on src.bk = dd.BK_Parent
	join bld.vw_Dataset tgt on tgt.bk = dd.BK_Child
	where 1=1
	--and dd.code like '%wmp%|internet%'
	and dd.DependencyType = 'SrcToTgt'

	--select * from bld.vw_Dataset
	--where code like '%wmp%|internet%'
	)

	-- select * from bld.vw_Dataset src where bk = 'DWH|csl||WMP|Internet|'
	--Legacy177_backwards|azure||WMP|Internet|	DWH|csl|rpt_vw|WMP|Internet|	Legacy177_backwards|azure||WMP|Internet|	DWH|csl||WMP|Internet|	TgtFromSrc
	--Legacy177_backwards|azure||WMP|Internet|
	-- Legacy177_backwards|azure||WMP|Internet|	DWH|csl|rpt_vw|WMP|Internet|	Legacy177_backwards|azure||WMP|Internet|	DWH|csl||WMP|Internet|	TgtFromSrc
, rebase as (
	-- join the "cleaned" businesskeys
	Select 
		  BK_Target			= tgt.bk
		, BK_Source			=  src.bk
		, DependencyType	= b.DependencyType
	From base b
	join bld.vw_Dataset src on src.bk = b.BK_SourceClean
	join bld.vw_Dataset tgt on tgt.bk = b.BK_TargetClean
	--Where src.bk = tgt.bk
	Where src.bk <> tgt.bk

	)

, TgtFromSrc

as
  ( 
	Select BK_Target BK_Target, BK_Source, 1 as lvl, DependencyType
	From rebase

	Union all
    
	Select d.BK_Target, s.BK_Source, d.lvl + 1, d.DependencyType
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

	

)
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
	, Generation_Number	= ROW_NUMBER() over (partition BY  tgt.BK order by b.lvl desc) 
From UniqueTgtFromSrc b
join bld.vw_Dataset src on src.bk = b.BK_Source
join bld.vw_Dataset tgt on tgt.bk = b.BK_Target

 where 1=1
 --and src.LayerName = 'src'
 --and src.LayerName != 'src'
 --and src.DatasetName != tgt.DatasetName
 --and tgt.bk = 'DWH|fct||IB|EUA|'
 --and tgt.bk = 'DWH|dim||Wes|Product|'
-- and tgt.bk = 'DWH|aud_fct||monitor|dataset|'
 --and tgt.BK='DWH|pst||IB|AggregatedPc4|'
 --and tgt.BK+'|'+src.BK = 'DWH|fct||IB|EUA||DWH|fct||IB|EUA|'
 --  and tgt.DatasetName= '[dim].[Common_Address]'
 -- and tgt.BK+'|'+src.BK  = 'DWH|fct||Wes|WeasEuaIb||SA_DWH|src_file||Wes|EUA|'