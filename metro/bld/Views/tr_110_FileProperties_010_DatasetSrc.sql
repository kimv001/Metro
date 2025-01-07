

CREATE VIEW [bld].[tr_110_FileProperties_010_DatasetSrc] AS 

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


SELECT
		  src.[BK]
		, src.[Code]
		
		-- File Properties 
		, fp.[Description]


		, fp.filemask
		, fp.[Filename]
		, fp.filesystem
		, fp.folder

		, fp.ispgp

		-- test characteristics

		, expectedfilecount			= COALESCE(fp.expectedfilecount,1)
		, fp.expectedfilesize
		, bk_schedule_fileexpected	= fp.bk_schedule_expected

		-- File Date Characteristics
		, fp.dateinfilenameformat
		, fp.dateinfilenamelength
		, fp.dateinfilenamestartpos
		, fp.dateinfilenameexpression
		, fp.testdateinfilename
		
		-- FileFormat FF
		, ff_name					= ff.[name]
		, ff_fileformat				= ff.fileformat
		, ff_columndelimiter		= ff.columndelimiter
		, ff_rowdelimiter			= ff.rowdelimiter
		, ff_quotecharacter			= isnull(ff.quotecharacter,'')
		, ff_compressionlevel		= ff.compressionlevel
		, ff_compressiontype		= ff.compressiontype
		, ff_enablecdc				= ff.enablecdc
		, ff_escapecharacter		= ff.escapecharacter
		, ff_fileencoding			= ff.fileencoding
		, ff_firstrow				= ff.[FirstRow]
		, ff_firstrowasheader		= ff.firstrowasheader
		, ff_filesize				= fp.filesize
		, ff_threshold				= fp.threshold
		
		
	FROM  rep.vw_datasetsrcfileproperties fp 
	JOIN [bld].[vw_Dataset] src ON fp.bk = src.code
	JOIN rep.vw_datasetsrcfileformat ff ON ff.bk = fp.bk_fileformat