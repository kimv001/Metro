

CREATE view [bld].[tr_110_FileProperties_010_DatasetSrc] as 

/* 
=== Comments =========================================

Description:
	Get all defined fileproperties and fileformats
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230830	1600		K. Vermeij				added [isPGP] for PGP decrypting purposes 
												added [ExpectedFileSize] for file testing purposes
20240403	1600		K. Vermeij				added [bk_schedule_FileExpected] for monitoring purposes
20240410	1130		K. Vermeij				added ExpectedFileCount
=======================================================
*/


Select
		  src.[BK]
		, src.[Code]
		
		-- File Properties 
		, fp.[Description]


		, fp.FileMask
		, fp.[Filename]
		, fp.FileSystem
		, fp.Folder

		, fp.isPGP

		-- test characteristics

		, ExpectedFileCount			= coalesce(fp.ExpectedFileCount,1)
		, fp.ExpectedFileSize
		, bk_schedule_FileExpected	= fp.bk_schedule_expected

		-- File Date Characteristics
		, fp.DateInFileNameFormat
		, fp.DateinFileNameLength
		, fp.DateInFileNameStartPos
		, fp.DateInFileNameExpression
		, fp.TestDateInFileName
		
		-- FileFormat FF
		, FF_Name					= ff.[name]
		, FF_Fileformat				= ff.Fileformat
		, FF_ColumnDelimiter		= ff.ColumnDelimiter
		, FF_RowDelimiter			= ff.RowDelimiter
		, FF_QuoteCharacter			= isnull(ff.QuoteCharacter,'')
		, FF_CompressionLevel		= ff.CompressionLevel
		, FF_CompressionType		= ff.CompressionType
		, FF_EnableCDC				= ff.EnableCDC
		, FF_EscapeCharacter		= ff.EscapeCharacter
		, FF_FileEncoding			= ff.FileEncoding
		, FF_FirstRow				= ff.[FirstRow]
		, FF_FirstRowAsHeader		= ff.FirstRowAsHeader
		, FF_Filesize				= fp.Filesize
		, FF_Threshold				= fp.Threshold
		
		
	From  rep.vw_DatasetSrcFileProperties fp 
	join [bld].[vw_Dataset] src on fp.bk = src.code
	join rep.vw_DatasetSrcFileFormat ff on ff.BK = fp.BK_FileFormat