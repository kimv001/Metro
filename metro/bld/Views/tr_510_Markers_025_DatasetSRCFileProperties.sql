
CREATE VIEW [bld].[tr_510_markers_025_datasetsrcfileproperties] AS /*
=== Comments =========================================

Description:
	creates dataset markers

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230226	1400		K. Vermeij				Added column [mta_rectype] to Activate SmartLoad
20230403	1944		K. Vermeij				If ROWTERMINATOR is empty in excel no line will be added. So synapse will take the default
=======================================================
*/ WITH base AS

        (SELECT DISTINCT bk = tgt.bk ,

               bkbase = base.bk ,

               dd.code ,

               bksource = src.bk ,

               bktarget = tgt.bk -- File Properties
 ,

               dateinfilenameformat = cast(fp.dateinfilenameformat AS varchar(MAX)) ,

               dateinfilenamelength = cast(isnull(fp.dateinfilenamelength, 'Marker not defined in the repository...') AS varchar(MAX)) ,

               dateinfilenamestartpos = cast(isnull(fp.dateinfilenamestartpos, 'Marker not defined in the repository...') AS varchar(MAX)) ,

               dateinfilenameexpression = cast(isnull(iif(fp.dateinfilenameexpression = '', NULL, fp.dateinfilenameexpression), '[mta_DateInFileName]') AS varchar(MAX)) ,

               [filename] = cast(fp.[filename] AS varchar(MAX)) ,

               filemask = cast(fp.filemask AS varchar(MAX)) ,

               filesystem = cast(fp.filesystem AS varchar(MAX)) ,

               folder = cast(fp.folder AS varchar(MAX)) ,

               fileformat = cast(fp.ff_fileformat AS varchar(MAX)) ,

               filecolumndelimiter = cast(fp.ff_columndelimiter AS varchar(MAX)) ,

               filerowdelimiter = cast(isnull(fp.ff_rowdelimiter, '') AS varchar(MAX)) ,

               filequotecharacter = cast(fp.ff_quotecharacter AS varchar(MAX)) ,

               filecompressionlevel = cast(fp.ff_compressionlevel AS varchar(MAX)) ,

               filecompressiontype = cast(fp.ff_compressiontype AS varchar(MAX)) ,

               fileenablecdc = cast(fp.ff_enablecdc AS varchar(MAX)) ,

               fileescapecharacter = cast(fp.ff_escapecharacter AS varchar(MAX)) ,

               filefileencoding = cast(fp.ff_fileencoding AS varchar(MAX)) ,

               filefirstrow = cast(fp.ff_firstrow AS varchar(MAX)) ,

               filefirstrowasheader = cast(fp.ff_firstrowasheader AS varchar(MAX)) ,

               mta_rectype = diff.rectype

          FROM bld.dataset base

          JOIN bld.vw_markerssmartload diff
            ON diff.code = base.code

          JOIN bld.vw_datasetdependency dd
            ON base.code = dd.code

          JOIN bld.vw_dataset src
            ON src.bk = dd.bk_parent

          JOIN bld.vw_dataset tgt
            ON tgt.bk = dd.bk_child

          LEFT JOIN bld.vw_fileproperties fp
            ON fp.bk = base.bk

         WHERE 1 = 1 --and tgt.bk = 'DWH|pst|vw|WMIA|IncidentReport|cur'

           AND dd.dependencytype = 'SrcToTgt'

           AND dd.mta_source != '[bld].[tr_400_DatasetDependency_030_TransformationViewsDWH]'

           AND dd.bk_parent != 'src'

           AND base.code = base.bk

           AND base.datasettype = 'SRC'

           AND cast(diff.rectype AS int) > -99
       ),

       markerbuild AS

        (SELECT src.bk ,

               src.code ,

               marker = '<!<DateInFileNameLength>>' ,

               markervalue = src.dateinfilenamelength ,

               markerdescription = ''

          FROM base src

     UNION ALL SELECT src.bk ,

               src.code ,

               marker = '<!<DateInFileNameFormat>>' ,

               markervalue = src.dateinfilenameformat ,

               markerdescription = ''

          FROM base src

     UNION ALL SELECT src.bk ,

               src.code ,

               marker = '<!<DateInFileNameStartPos>>' ,

               markervalue = src.dateinfilenamestartpos ,

               markerdescription = ''

          FROM base src

     UNION ALL SELECT src.bk ,

               src.code ,

               marker = '<!<DateInFileNameExpression>>' ,

               markervalue = src.dateinfilenameexpression ,

               markerdescription = ''

          FROM base src

     UNION ALL SELECT src.bk ,

               src.code ,

               marker = '<!<Filename>>' ,

               markervalue = src.[filename] ,

               markerdescription = ''

          FROM base src

     UNION ALL SELECT src.bk ,

               src.code ,

               marker = '<!<FileMask>>' ,

               markervalue = src.filemask ,

               markerdescription = ''

          FROM base src

     UNION ALL SELECT src.bk ,

               src.code ,

               marker = '<!<FileSystem>>' ,

               markervalue = src.filesystem ,

               markerdescription = ''

          FROM base src

     UNION ALL SELECT src.bk ,

               src.code ,

               marker = '<!<Folder>>' ,

               markervalue = src.folder ,

               markerdescription = ''

          FROM base src

     UNION ALL SELECT src.bk ,

               src.code ,

               marker = '<!<FileFormat>>' ,

               markervalue = src.fileformat ,

               markerdescription = ''

          FROM base src

     UNION ALL SELECT src.bk ,

               src.code ,

               marker = '<!<FileColumnDelimiter>>' ,

               markervalue = src.filecolumndelimiter ,

               markerdescription = ''

          FROM base src

     UNION ALL SELECT src.bk ,

               src.code ,

               marker = '<!<FileRowDelimiter>>' ,

               markervalue = CASE
                                      WHEN src.filerowdelimiter = '' THEN ''

                    ELSE ',ROWTERMINATOR			= ''''' + src.filerowdelimiter + ''''''

                     END ,

               markerdescription = ''

          FROM base src

     UNION ALL SELECT src.bk ,

               src.code ,

               marker = '<!<FileCompressionLevel>>' ,

               markervalue = src.filecompressionlevel ,

               markerdescription = ''

          FROM base src

     UNION ALL SELECT src.bk ,

               src.code ,

               marker = '<!<FileCompressionType>>' ,

               markervalue = src.filecompressiontype ,

               markerdescription = ''

          FROM base src

     UNION ALL SELECT src.bk ,

               src.code ,

               marker = '<!<FileEnableCDC>>' ,

               markervalue = src.fileenablecdc ,

               markerdescription = ''

          FROM base src

     UNION ALL SELECT src.bk ,

               src.code ,

               marker = '<!<FileEscapeCharacter>>' ,

               markervalue = src.fileescapecharacter ,

               markerdescription = ''

          FROM base src

     UNION ALL SELECT src.bk ,

               src.code ,

               marker = '<!<FileEncoding>>' ,

               markervalue = src.filefileencoding ,

               markerdescription = ''

          FROM base src

     UNION ALL SELECT src.bk ,

               src.code ,

               marker = '<!<FileFirstRow>>' ,

               markervalue = src.filefirstrow ,

               markerdescription = ''

          FROM base src

     UNION ALL SELECT src.bk ,

               src.code ,

               marker = '<!<FileFirstRowAsHeader>>' ,

               markervalue = src.filefirstrowasheader ,

               markerdescription = ''

          FROM base src

     UNION ALL SELECT src.bk ,

               src.code ,

               marker = '<!<FileQuoteCharacter>>' ,

               markervalue = src.filequotecharacter ,

               markerdescription = ''

          FROM base src
       )
SELECT bk = left(concat(mb.bk, '|', mb.marker), 255) ,

       bk_dataset = mb.bk ,

       code = mb.code ,

       markertype = 'Dynamic' ,

       markerdescription ,

       mb.marker ,

       markervalue = cast(isnull(mb.markervalue, '') AS varchar(MAX)) ,

       [pre] = 0 ,

       [post] = 0 ,

       mta_rectype = diff.rectype

  FROM markerbuild mb

  LEFT JOIN [bld].[vw_markerssmartload] diff
    ON diff.code = mb.code

 WHERE 1 = 1 --and marker = '<!<DateInFileNameLength>>'
--and  left(Concat( mb.bk,'|',MB.Marker),255) = 'DWH|pst|vw|WMIA|IncidentReport|cur|<!<DateInFileNameLength>>'
