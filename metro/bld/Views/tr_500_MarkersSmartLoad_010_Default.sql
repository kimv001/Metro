





CREATE view [bld].[tr_500_MarkersSmartLoad_010_Default] as 
/* 
=== Comments =========================================

Description:
	Is a helper for the bld.tr_%_Marker_% views.
	When change is detected in the bld tables on wich the markers are dependent, the code of the full set will be returned
	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/

/*
select * from bld.dataset

update bld.Dataset set mta_Createdate = getdate()
where BK = 'BI|Base||IB|AggregatedPc4|'
*/

/* 
The First CTE's determine if there is a change in the source records
If not, the markers will not be rebuild
*/

with CreateDateSrc as (
	select 	src.Code, src.mta_CreateDate , 'vw_Dataset' as source
	from bld.vw_Dataset src
	--order by 2 desc

	union all 
	
	select src.Code , src.mta_CreateDate , 'vw_FileProperties' as source
	from bld.vw_FileProperties src

	union all 
	
	select src.Code , src.mta_CreateDate , 'vw_Attribute' as source
	from bld.vw_Attribute src

	union all 
	
	select src.Code , src.mta_CreateDate , 'vw_DatasetDependency' as source
	from bld.vw_DatasetDependency src
)
, MaxCreateDateSrc as (
	select 
		Code
		, mta_CreateDate = max(mta_CreateDate) 
	from  CreateDateSrc 
	group by Code
)
, CreateDateTgt as (
	select 
		 Code				= m.code
		, mta_CreateDate	= max(m.mta_CreateDate)
	from bld.vw_Markers m
	group by m.code
)
-- List of Codes that are possibly changed
select distinct 
	BK					= Coalesce(S.Code, T.Code)
	, Code				= Coalesce(S.Code, T.Code)
	, SrcCreateDate		= S.mta_CreateDate
	, TgtCreateDate		= T.mta_CreateDate
	, IsUpdated			= iif(S.mta_CreateDate> T.mta_CreateDate,1,0)
	, RecType			= case 
							when S.Code = T.Code and 	S.mta_CreateDate> T.mta_CreateDate  then 0
							when T.Code is null then 1
							when S.Code is null then -1
							else -99
							end

from MaxCreateDateSrc S
--left join CreateDateTgt T on S.Code = T.Code and S.mta_CreateDate> T.mta_CreateDate
full outer join CreateDateTgt T on T.Code = S.Code