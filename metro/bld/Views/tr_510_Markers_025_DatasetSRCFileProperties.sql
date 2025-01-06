








CREATE view [bld].[tr_510_Markers_025_DatasetSRCFileProperties] as 
/* 
=== Comments =========================================

Description:
	creates dataset markers
	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230226	1400		K. Vermeij				Added column [mta_rectype] to Activate SmartLoad
20230403	1944		K. Vermeij				If ROWTERMINATOR is empty in excel no line will be added. So synapse will take the default
=======================================================
*/

With base as (

	select distinct
		 BK							= tgt.BK
		, BKBase					= base.bk
		, dd.Code 
		, BKSource					= src.BK
		, BKTarget					= tgt.BK

		-- File Properties
		, DateInFileNameFormat		= cast(fp.DateInFileNameFormat														as varchar(max))
		, DateinFileNameLength		= cast(isnull(fp.DateinFileNameLength	,'Marker not defined in the repository...')	as varchar(max))
		, DateInFileNameStartPos	= cast(isnull(fp.DateInFileNameStartPos	,'Marker not defined in the repository...')	as varchar(max))
		, DateInFileNameExpression	= cast(isnull(iif(fp.DateInFileNameExpression='',null,fp.DateInFileNameExpression), '[mta_DateInFileName]')	as varchar(max))
								  
		, [Filename]				= cast(fp.[Filename]																as varchar(max))
		, FileMask					= cast(fp.FileMask																	as varchar(max))
		, FileSystem				= cast(fp.FileSystem																as varchar(max))
		, Folder					= cast(fp.Folder																	as varchar(max))

		, FileFormat				= cast(fp.FF_FileFormat																as varchar(max))			  
		, FileColumnDelimiter		= cast(fp.FF_ColumnDelimiter														as varchar(max))
		, FileRowDelimiter			= cast(isnull(fp.ff_RowDelimiter,'')												as varchar(max))
		, FileQuoteCharacter		= cast(fp.FF_QuoteCharacter															as varchar(max))
		, FileCompressionLevel		= cast(fp.FF_CompressionLevel														as varchar(max))
		, FileCompressionType		= cast(fp.FF_CompressionType														as varchar(max))
		, FileEnableCDC				= cast(fp.FF_EnableCDC																as varchar(max))
		, FileEscapeCharacter		= cast(fp.FF_EscapeCharacter														as varchar(max))
		, FileFileEncoding			= cast(fp.FF_FileEncoding															as varchar(max))
		, FileFirstRow				= cast(fp.FF_FirstRow																as varchar(max))
		, FileFirstRowAsHeader		= cast(fp.FF_FirstRowAsHeader														as varchar(max))
		, mta_RecType				= diff.RecType
	from   bld.Dataset base
	join bld.vw_MarkersSmartLoad	Diff on Diff.Code  =  base.code
	join bld.vw_DatasetDependency	DD	on base.code		= dd.code
	join bld.vw_Dataset				src on src.BK		= dd.BK_Parent
	join bld.vw_Dataset				tgt on tgt.BK		= dd.BK_Child
	left join bld.vw_FileProperties	fp	on fp.bk		= base.bk
	where 1=1
	--and tgt.bk = 'DWH|pst|vw|WMIA|IncidentReport|cur'
		and dd.DependencyType = 'SrcToTgt'
		and dd.mta_Source != '[bld].[tr_400_DatasetDependency_030_TransformationViewsDWH]'
		and dd.BK_Parent != 'src'
		and base.code=base.bk
		and base.DatasetType = 'SRC'
		and cast(diff.RecType as int) > -99
)
, MarkerBuild as (
	

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<DateInFileNameLength>>'
		, MarkerValue			= src.DateInFileNameLength
		, MarkerDescription		= ''
	From Base src

	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<DateInFileNameFormat>>'
		, MarkerValue			= src.DateInFileNameFormat
		, MarkerDescription		= ''
	From Base src

	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<DateInFileNameStartPos>>'
		, MarkerValue			= src.DateInFileNameStartPos
		, MarkerDescription		= ''
	From Base src

	
	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<DateInFileNameExpression>>'
		, MarkerValue			= src.DateInFileNameExpression
		, MarkerDescription		= ''
	From Base src

	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<Filename>>'
		, MarkerValue			= src.[Filename]
		, MarkerDescription		= ''
	From Base src

	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<FileMask>>'
		, MarkerValue			= src.FileMask
		, MarkerDescription		= ''
	From Base src


	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<FileSystem>>'
		, MarkerValue			= src.FileSystem
		, MarkerDescription		= ''
	From Base src


	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<Folder>>'
		, MarkerValue			= src.Folder
		, MarkerDescription		= ''
	From Base src

	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<FileFormat>>'
		, MarkerValue			= src.FileFormat
		, MarkerDescription		= ''
	From Base src


	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<FileColumnDelimiter>>'
		, MarkerValue			= src.FileColumnDelimiter
		, MarkerDescription		= ''
	From Base src


	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<FileRowDelimiter>>'
		, MarkerValue			= case when src.FileRowDelimiter = ''
									then ''
									else ',ROWTERMINATOR			= '''''+src.FileRowDelimiter+''''''
									end
		, MarkerDescription		= ''
	From Base src


	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<FileCompressionLevel>>'
		, MarkerValue			= src.FileCompressionLevel
		, MarkerDescription		= ''
	From Base src


	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<FileCompressionType>>'
		, MarkerValue			= src.FileCompressionType
		, MarkerDescription		= ''
	From Base src


	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<FileEnableCDC>>'
		, MarkerValue			= src.FileEnableCDC
		, MarkerDescription		= ''
	From Base src


	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<FileEscapeCharacter>>'
		, MarkerValue			= src.FileEscapeCharacter
		, MarkerDescription		= ''
	From Base src


	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<FileEncoding>>'
		, MarkerValue			= src.FileFileEncoding
		, MarkerDescription		= ''
	From Base src


	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<FileFirstRow>>'
		, MarkerValue			= src.FileFirstRow
		, MarkerDescription		= ''
	From Base src

	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<FileFirstRowAsHeader>>'
		, MarkerValue			= src.FileFirstRowAsHeader
		, MarkerDescription		= ''
	From Base src


	union all

	Select
		  src.BK		
		, src.Code
		, Marker				= '<!<FileQuoteCharacter>>'
		, MarkerValue			= src.FileQuoteCharacter
		, MarkerDescription		= ''
	From Base src
	)
select
	BK					= left(Concat( mb.bk,'|',MB.Marker),255)
	, BK_Dataset		= MB.bk		
	, Code				= mb.code
	, MarkerType		= 'Dynamic'
	, MarkerDescription
	, MB.Marker
	, MarkerValue		= cast(isnull(MB.MarkerValue,'') as varchar(max))
	, [Pre]				= 0
	, [Post]			= 0
	, mta_RecType		= diff.RecType
From MarkerBuild MB
left join [bld].[vw_MarkersSmartLoad] Diff on Diff.Code  =  MB.code
where 1=1
--and marker = '<!<DateInFileNameLength>>'
--and  left(Concat( mb.bk,'|',MB.Marker),255) = 'DWH|pst|vw|WMIA|IncidentReport|cur|<!<DateInFileNameLength>>'