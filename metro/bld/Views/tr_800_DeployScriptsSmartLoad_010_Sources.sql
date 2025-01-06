







CREATE view [bld].[tr_800_DeployScriptsSmartLoad_010_Sources] as 
/* 
=== Comments =========================================

Description:
	Is a helper for the bld.DeployScripts views.
	When change is detected in the bld tables [bld].[Markers], [bld].[DatasetTemplates] or [bld].[Template] on which the [bld].[DeployScripts] are dependent, the code of the full set will be returned
	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/



with CreateDate_MarkersAndDatasetTemplatesAndTemplates as (
	
	-- get create date from Markers
	-- if 1 marker is changed, all should be rebuild
	-- kind of design flaw, but you cant detemine which marker are used in which templates
	select src.BK_Dataset, max(src.mta_CreateDate) as mta_CreateDate, 'vw_Markers' as source
	from bld.vw_Markers src
	group by src.BK_Dataset
	

	union all 
	
	-- get create date for the combination of Datasets and Templates
	select src.BK_Dataset, src.mta_CreateDate, 'vw_DatasetTemplates' as source
	from bld.vw_DatasetTemplates src

	union all

	-- get create date Templates
	select src.BK_Dataset, t.mta_CreateDate, 'vw_DatasetTemplates' as source
	from bld.vw_DatasetTemplates src
	join bld.vw_Template t on src.BK_Template = t.BK

)


, MaxCreateDateSrc as (
	select 
		src.BK_Dataset
		, mta_CreateDate = max(mta_CreateDate) 
	from  CreateDate_MarkersAndDatasetTemplatesAndTemplates src
	group by src.BK_Dataset
)
, CreateDateTgt as (
	select 
		 BK_Dataset				= t.BK_Dataset
		, mta_CreateDate	= max(t.mta_CreateDate)
	from bld.vw_DeployScripts t
	group by t.BK_Dataset
)
-- List of Codes that are possibly changed
select distinct 
	BK					= Coalesce(S.BK_Dataset, T.BK_Dataset)
	, BK_Dataset		= Coalesce(S.BK_Dataset, T.BK_Dataset)
	, Code				= Coalesce(S.BK_Dataset, T.BK_Dataset)
	, SrcCreateDate		= S.mta_CreateDate
	, TgtCreateDate		= T.mta_CreateDate
	, IsUpdated			= iif(S.mta_CreateDate> T.mta_CreateDate,1,0)
	, RecType			= case 
							when S.BK_Dataset = T.BK_Dataset and 	S.mta_CreateDate> T.mta_CreateDate  then 0
							when T.BK_Dataset is null then 1
							when S.BK_Dataset is null then -1
							else -99
							end

from MaxCreateDateSrc S

full outer join CreateDateTgt T on T.BK_Dataset = S.BK_Dataset