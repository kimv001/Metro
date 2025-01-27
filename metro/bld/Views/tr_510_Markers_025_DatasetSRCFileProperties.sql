








CREATE VIEW [bld].[tr_510_Markers_025_DatasetSRCFileProperties] AS 
/* 
=== Comments =========================================

Description:
    Creates dataset markers for source file properties. These markers are used to dynamically replace values in templates based on the file properties of the source datasets.

Columns:
    - BK: The business key of the marker.
    - BKBASE: The business key of the base dataset.
    - CODE: The code of the dataset.
    - BKSOURCE: The business key of the source dataset.
    - BKTARGET: The business key of the target dataset.
    - DATEINFILENAMEFORMAT: The format of the date in the filename.
    - DATEINFILENAMELENGTH: The length of the date in the filename.
    - DATEINFILENAMESTARTPOS: The start position of the date in the filename.
    - DATEINFILENAMEEXPRESSION: The expression used to extract the date from the filename.
    - FILENAME: The name of the file.
    - FILEMASK: The file mask used to identify files.
    - FILESYSTEM: The file system where the file is located.
    - FOLDER: The folder where the file is located.
    - FILEFORMAT: The file format.
    - FILECOLUMNDLIMITER: The column delimiter for the file format.
    - FILEROWDELIMITER: The row delimiter for the file format.
    - FILEQUOTECHARACTER: The quote character for the file format.
    - FILECOMPRESSIONLEVEL: The compression level for the file format.

Example Usage:
    SELECT * FROM [bld].[tr_510_Markers_025_DatasetSRCFileProperties]

Logic:
    1. Selects base dataset information.
    2. Joins with relevant views to get additional file property attributes.
    3. Creates markers for source file properties based on the dataset configurations.

Source Data:
    - [bld].[vw_Dataset]: Contains dataset definitions.
    - [bld].[vw_FileProperties]: Contains file property definitions.
    - [bld].[vw_Attribute]: Contains attribute definitions for datasets.

Markers and Example Values:
    - **Marker for Date in Filename Format**
        - **Marker:** `<!<dateinfilenameformat>>`
        - **Marker Value:** `yyyyMMdd`
    - **Marker for Date in Filename Length**
        - **Marker:** `<!<dateinfilenamelength>>`
        - **Marker Value:** `8`
    - **Marker for Date in Filename Start Position**
        - **Marker:** `<!<dateinfilenamestartpos>>`
        - **Marker Value:** `1`
    - **Marker for Date in Filename Expression**
        - **Marker:** `<!<dateinfilenameexpression>>`
        - **Marker Value:** `SUBSTRING(Filename, 1, 8)`
    - **Marker for Filename**
        - **Marker:** `<!<filename>>`
        - **Marker Value:** `datafile_20230101.csv`
    - **Marker for File Mask**
        - **Marker:** `<!<filemask>>`
        - **Marker Value:** `datafile_*.csv`
    - **Marker for File System**
        - **Marker:** `<!<filesystem>>`
        - **Marker Value:** `HDFS`
    - **Marker for Folder**
        - **Marker:** `<!<folder>>`
        - **Marker Value:** `/data/files/`
    - **Marker for File Format**
        - **Marker:** `<!<fileformat>>`
        - **Marker Value:** `CSV`
    - **Marker for File Column Delimiter**
        - **Marker:** `<!<filecolumndelimiter>>`
        - **Marker Value:** `,`
    - **Marker for File Row Delimiter**
        - **Marker:** `<!<filerowdelimiter>>`
        - **Marker Value:** `\n`
    - **Marker for File Quote Character**
        - **Marker:** `<!<filequotecharacter>>`
        - **Marker Value:** `"`
    - **Marker for File Compression Level**
        - **Marker:** `<!<filecompressionlevel>>`
        - **Marker Value:** `gzip`
	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230226	1400		K. Vermeij				Added column [mta_rectype] to Activate SmartLoad
20230403	1944		K. Vermeij				If ROWTERMINATOR is empty in excel no line will be added. So synapse will take the default
=======================================================
*/

WITH base AS (

	SELECT DISTINCT
		 bk							= tgt.bk
		, bkbase					= base.bk
		, dd.code 
		, bksource					= src.bk
		, bktarget					= tgt.bk

		-- File Properties
		, dateinfilenameformat		= CAST(fp.dateinfilenameformat														AS varchar(MAX))
		, dateinfilenamelength		= CAST(isnull(fp.dateinfilenamelength	,'Marker not defined in the repository...')	AS varchar(MAX))
		, dateinfilenamestartpos	= CAST(isnull(fp.dateinfilenamestartpos	,'Marker not defined in the repository...')	AS varchar(MAX))
		, dateinfilenameexpression	= CAST(isnull(iif(fp.dateinfilenameexpression='',null,fp.dateinfilenameexpression), '[mta_DateInFileName]')	AS varchar(MAX))
								  
		, [Filename]				= CAST(fp.[Filename]																AS varchar(MAX))
		, filemask					= CAST(fp.filemask																	AS varchar(MAX))
		, filesystem				= CAST(fp.filesystem																AS varchar(MAX))
		, folder					= CAST(fp.folder																	AS varchar(MAX))

		, fileformat				= CAST(fp.ff_fileformat																AS varchar(MAX))			  
		, filecolumndelimiter		= CAST(fp.ff_columndelimiter														AS varchar(MAX))
		, filerowdelimiter			= CAST(isnull(fp.ff_rowdelimiter,'')												AS varchar(MAX))
		, filequotecharacter		= CAST(fp.ff_quotecharacter															AS varchar(MAX))
		, filecompressionlevel		= CAST(fp.ff_compressionlevel														AS varchar(MAX))
		, filecompressiontype		= CAST(fp.ff_compressiontype														AS varchar(MAX))
		, fileenablecdc				= CAST(fp.ff_enablecdc																AS varchar(MAX))
		, fileescapecharacter		= CAST(fp.ff_escapecharacter														AS varchar(MAX))
		, filefileencoding			= CAST(fp.ff_fileencoding															AS varchar(MAX))
		, filefirstrow				= CAST(fp.ff_firstrow																AS varchar(MAX))
		, filefirstrowasheader		= CAST(fp.ff_firstrowasheader														AS varchar(MAX))
		, mta_rectype				= diff.rectype
	FROM   bld.dataset base
	JOIN bld.vw_markerssmartload	diff ON diff.code  =  base.code
	JOIN bld.vw_datasetdependency	dd	ON base.code		= dd.code
	JOIN bld.vw_dataset				src ON src.bk		= dd.bk_parent
	JOIN bld.vw_dataset				tgt ON tgt.bk		= dd.bk_child
	LEFT JOIN bld.vw_fileproperties	fp	ON fp.bk		= base.bk
	WHERE 1=1
	--and tgt.bk = 'DWH|pst|vw|WMIA|IncidentReport|cur'
		AND dd.dependencytype = 'SrcToTgt'
		AND dd.mta_source != '[bld].[tr_400_DatasetDependency_030_TransformationViewsDWH]'
		AND dd.bk_parent != 'src'
		AND base.code=base.bk
		AND base.datasettype = 'SRC'
		AND CAST(diff.rectype AS int) > -99
)
, markerbuild AS (
	

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<DateInFileNameLength>>'
		, markervalue			= src.dateinfilenamelength
		, markerdescription		= ''
	FROM base src

	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<DateInFileNameFormat>>'
		, markervalue			= src.dateinfilenameformat
		, markerdescription		= ''
	FROM base src

	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<DateInFileNameStartPos>>'
		, markervalue			= src.dateinfilenamestartpos
		, markerdescription		= ''
	FROM base src

	
	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<DateInFileNameExpression>>'
		, markervalue			= src.dateinfilenameexpression
		, markerdescription		= ''
	FROM base src

	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<Filename>>'
		, markervalue			= src.[Filename]
		, markerdescription		= ''
	FROM base src

	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<FileMask>>'
		, markervalue			= src.filemask
		, markerdescription		= ''
	FROM base src


	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<FileSystem>>'
		, markervalue			= src.filesystem
		, markerdescription		= ''
	FROM base src


	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<Folder>>'
		, markervalue			= src.folder
		, markerdescription		= ''
	FROM base src

	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<FileFormat>>'
		, markervalue			= src.fileformat
		, markerdescription		= ''
	FROM base src


	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<FileColumnDelimiter>>'
		, markervalue			= src.filecolumndelimiter
		, markerdescription		= ''
	FROM base src


	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<FileRowDelimiter>>'
		, markervalue			= CASE WHEN src.filerowdelimiter = ''
									THEN ''
									ELSE ',ROWTERMINATOR			= '''''+src.filerowdelimiter+''''''
									END
		, markerdescription		= ''
	FROM base src


	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<FileCompressionLevel>>'
		, markervalue			= src.filecompressionlevel
		, markerdescription		= ''
	FROM base src


	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<FileCompressionType>>'
		, markervalue			= src.filecompressiontype
		, markerdescription		= ''
	FROM base src


	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<FileEnableCDC>>'
		, markervalue			= src.fileenablecdc
		, markerdescription		= ''
	FROM base src


	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<FileEscapeCharacter>>'
		, markervalue			= src.fileescapecharacter
		, markerdescription		= ''
	FROM base src


	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<FileEncoding>>'
		, markervalue			= src.filefileencoding
		, markerdescription		= ''
	FROM base src


	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<FileFirstRow>>'
		, markervalue			= src.filefirstrow
		, markerdescription		= ''
	FROM base src

	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<FileFirstRowAsHeader>>'
		, markervalue			= src.filefirstrowasheader
		, markerdescription		= ''
	FROM base src


	UNION ALL

	SELECT
		  src.bk		
		, src.code
		, marker				= '<!<FileQuoteCharacter>>'
		, markervalue			= src.filequotecharacter
		, markerdescription		= ''
	FROM base src
	)
SELECT
	bk					= LEFT(Concat( mb.bk,'|',mb.marker),255)
	, bk_dataset		= mb.bk		
	, code				= mb.code
	, markertype		= 'Dynamic'
	, markerdescription
	, mb.marker
	, markervalue		= CAST(isnull(mb.markervalue,'') AS varchar(MAX))
	, [Pre]				= 0
	, [Post]			= 0
	, mta_rectype		= diff.rectype
FROM markerbuild mb
LEFT JOIN [bld].[vw_MarkersSmartLoad] diff ON diff.code  =  mb.code
WHERE 1=1
--and marker = '<!<DateInFileNameLength>>'
--and  left(Concat( mb.bk,'|',MB.Marker),255) = 'DWH|pst|vw|WMIA|IncidentReport|cur|<!<DateInFileNameLength>>'