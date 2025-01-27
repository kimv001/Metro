

CREATE VIEW [bld].[tr_110_FileProperties_010_DatasetSrc] AS 

/* 
=== Comments =========================================

Description:
    This view retrieves all defined file properties and file formats. 
	It includes various attributes related to the files, such as file masks, file systems, and expected file characteristics.

Columns:
    - BK: The business key of the file property.
    - Code: The code of the file property.
    - Description: The description of the file property.
    - FileMask: The file mask used to identify files.
    - Filename: The name of the file.
    - FileSystem: The file system where the file is located.
    - Folder: The folder where the file is located.
    - IsPGP: Indicates if the file is PGP encrypted.
    - ExpectedFileCount: The expected number of files.
    - ExpectedFileSize: The expected size of the file.
    - BK_Schedule_FileExpected: The business key of the schedule for expected files.
    - DateInFilenameFormat: The format of the date in the filename.
    - DateInFilenameLength: The length of the date in the filename.
    - DateInFilenameStartPos: The start position of the date in the filename.
    - DateInFilenameExpression: The expression used to extract the date from the filename.

Example Usage:
    SELECT * FROM [bld].[tr_110_FileProperties_010_DatasetSrc]

Logic:
    1. Selects file property definitions from the [rep].[vw_FileProperties] view.
    2. Joins with other relevant views to get additional file property attributes.

Source Data:
    - [rep].[vw_FileProperties]: Contains definitions for file properties.
    - [rep].[vw_FileFormats]: Contains definitions for file formats.
    - [rep].[vw_Schedule]: Contains schedule information for monitoring purposes.
	
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