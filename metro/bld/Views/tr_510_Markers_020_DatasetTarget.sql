



CREATE view [bld].[tr_510_Markers_020_DatasetTarget] as 
/* 
=== Comments =========================================

Description:
	creates dataset markers
	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230226	1400		K. Vermeij				Added column [mta_rectype] to Activate SmartLoad
20230409	0839		K. Vermeij				Added the Marker <!<distinct>>
20230616	1554		K. Vermeij				Added marker <!<tgt_insertnocheck>>
20230616	1554		K. Vermeij				Added marker <!<tgt_timestamp>>
20230701	0818		K. Vermeij				Added marker <!<tgt_recordsrcdate>>
20230727	1704		K. Vermeij				added marker <!<tgt_PartitionStatement>>
=======================================================
*/

With base as (

		select distinct
			 BK							= tgt.BK
			, BKBase					= base.bk
			, dd.Code 
			, BKSource					= src.BK
			, BKTarget					= tgt.BK

			, src_dataset				= cast(src.DatasetName					as varchar(max))
			, src_datasetschema			= cast(src.SchemaName					as varchar(max))
			, tgt_businessdate			= cast(isnull(base.BusinessDate,'NULL') as varchar(max))
			, tgt_recordsrcdate			= cast(coalesce(base.RecordSrcDate,fp.DateInFileNameExpression,'mta_loaddate') as varchar(max))
			, tgt_dataset				= cast(tgt.DatasetName					as varchar(max))
			, tgt_datasetgroupname		= cast(tgt.BK_Group						as varchar(max))
			, tgt_datasetschema			= cast(tgt.SchemaName					as varchar(max))
			, tgt_datasetshortname		= cast(iif(isnull(base.dwhTargetShortName,'')='', base.ShortName, base.dwhTargetShortName) as varchar(max))
			, tgt_datasetshortnamesrc	= cast(base.ShortName					as varchar(max))
			, tgt_FullLoad				= cast(base.FullLoad					as varchar(max))
			, tgt_insertonly			= cast(base.InsertOnly					as varchar(max))
			, tgt_insertnocheck			= cast(base.insertnocheck				as varchar(max))
			, tgt_wherefilter			= cast(base.WhereFilter					as varchar(max))
			, tgt_TimestampExpression	= cast(base.[timestamp]					as varchar(max))
			, tgt_PartitionStatement	= cast(base.PartitionStatement			as varchar(max))
			, DistinctValues			= cast(iif(isnull(base.DistinctValues,0) = 0,'', 'Distinct') as varchar(max))
			, SCD						= cast(base.SCD							as varchar(max))
			, mta_RecType				= diff.RecType
			, BK_RefType_ObjectType		= base.BK_RefType_ObjectType
			, ObjectTypeCode			= rto.Code

		from   bld.vw_Dataset base
		join bld.vw_MarkersSmartLoad	Diff on Diff.Code  =  base.code
		join bld.vw_DatasetDependency	DD	on base.code		= dd.code
		join bld.vw_Dataset				src on src.BK		= dd.BK_Parent
		join bld.vw_Dataset				tgt on tgt.BK		= dd.BK_Child
		join bld.vw_RefType				rto on rto.BK		= tgt.BK_RefType_ObjectType
		left join bld.vw_FileProperties	fp	on fp.bk		= base.bk
		where 1=1
			and dd.DependencyType = 'srcTotgt'
			and dd.mta_Source != '[bld].[tr_400_DatasetDependency_030_TransformationViewsDWH]'
			and dd.BK_Parent != 'src'
			and base.code=base.bk 
			and cast(diff.RecType as int) > -99

)
, MarkerBuild as (
	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<tgt_Dataset>>'
		, MarkerValue			= src.tgt_Dataset
		, MarkerDescription		= 'The name of the target dataset. Example: "[dim].[Common_Asset]"'
	From Base src

	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<tgt_DatasetGroupName>>'
		, MarkerValue			= src.tgt_DatasetGroupName
		, MarkerDescription		= 'Groupname of a dataset. Example "Common"'
	From Base src


	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<tgt_DatasetSchema>>'
		, MarkerValue			= src.tgt_DatasetSchema
		, MarkerDescription		= ''
	From Base src

	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<src_datasetschema>>'
		, MarkerValue			= src.src_DatasetSchema
		, MarkerDescription		= ''
	From Base src


	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<tgt_datasetshortname>>'
		, MarkerValue			= src.tgt_DatasetShortName
		, MarkerDescription		= ''
	From Base src

	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<tgt_datasetshortnamesrc>>'
		, MarkerValue			= src.tgt_DatasetShortNamesrc
		, MarkerDescription		= ''
	From Base src
	--where src.DatasetShortNamesrc is not null

	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<src_dataset>>'
		, MarkerValue			= src.src_Dataset
		, MarkerDescription		= ''
	From Base src

	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<tgt_businessdate>>'
		, MarkerValue			= src.tgt_BusinessDate
		, MarkerDescription		= ''
	From Base src
	--where src.DatasetBusinessDate is not null

	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<tgt_recordsourcedate>>'
		, MarkerValue			= src.tgt_recordsrcdate
		, MarkerDescription		= ''
	From Base src

	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<scd>>'
		, MarkerValue			= src.SCD
		, MarkerDescription		= ''
	From Base src

	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<distinct>>'
		, MarkerValue			= src.DistinctValues
		, MarkerDescription		= 'In Some cases the dataset delivered isn unique'
	From Base src
	
	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<tgt_wherefilter>>'
		, MarkerValue			= 'and '+src.tgt_WhereFilter
		, MarkerDescription		= ''
	From Base src
	--where src.DatasetWhereFilter is not null

	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<tgt_PartitionStatement>>'
		, MarkerValue			=  case when isnull(ltrim(rtrim(src.tgt_PartitionStatement)),'')='' then '' else  ',PARTITION('+src.tgt_PartitionStatement+')' end
		, MarkerDescription		= ''
	From Base src
	--where isnull(ltrim(rtrim(src.tgt_PartitionStatement)),'')!='' and src.ObjectTypeCode = 'T'

	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<tgt_TimestampExpression>>'
		, MarkerValue			= isnull(src.tgt_TimestampExpression,'null')
		, MarkerDescription		= ''
	From Base src
	--where src.DatasetWhereFilter is not null


	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<tgt_insertonly>>'
		, MarkerValue			= isnull(src.tgt_insertOnly,0)
		, MarkerDescription		= ''
	From Base src
	--where src.DatasetInsertOnly is not null

	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<tgt_insertnocheck>>'
		, MarkerValue			= isnull(src.tgt_insertnocheck,0)
		, MarkerDescription		= ''
	From Base src
	

	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<tgt_fullload>>'
		, MarkerValue			= src.tgt_FullLoad
		, MarkerDescription		= ''
	From Base src
	--where src.DatasetFullLoad is not null

	)
select
	BK					= Left(Concat( mb.bk,'|',MB.Marker) ,255)
	, BK_Dataset		=  MB.bk
	, Code				= mb.code
	, MarkerType		= 'Dynamic'
	, MarkerDescription
	, MB.Marker
	, MarkerValue		= isnull(MB.MarkerValue,'/* Marker: '+replace(replace(MB.Marker,'<!<','>!>'),'>>','<<')+' not used */')
	, [Pre]				= 0
	, [Post]			= 0
	, mta_RecType		= diff.RecType
From MarkerBuild MB
--join bld.vw_dataset tgt on MB.BK_Dataset_Code = tgt.Code
left join [bld].[vw_MarkersSmartLoad] Diff on Diff.Code  =  MB.code and diff.BK = mb.bk
where 1=1
--and marker = '<!<tgt_PartitionStatement>>'