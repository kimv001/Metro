﻿
CREATE VIEW [bld].[vw_fileproperties] AS /*
        View is generated by  : metro
        Generated at          : 2024-12-24 08:25:26
        Description           : View on stage table
        */  WITH cur AS

        (SELECT [filepropertiesid] AS [filepropertiesid],

               [bk] AS [bk],

               [code] AS [code],

               [description] AS [description],

               [filemask] AS [filemask],

               [filename] AS [filename],

               [filesystem] AS [filesystem],

               [folder] AS [folder],

               [ispgp] AS [ispgp],

               [expectedfilecount] AS [expectedfilecount],

               [expectedfilesize] AS [expectedfilesize],

               [bk_schedule_fileexpected] AS [bk_schedule_fileexpected],

               [dateinfilenameformat] AS [dateinfilenameformat],

               [dateinfilenamelength] AS [dateinfilenamelength],

               [dateinfilenamestartpos] AS [dateinfilenamestartpos],

               [dateinfilenameexpression] AS [dateinfilenameexpression],

               [testdateinfilename] AS [testdateinfilename],

               [ff_name] AS [ff_name],

               [ff_fileformat] AS [ff_fileformat],

               [ff_columndelimiter] AS [ff_columndelimiter],

               [ff_rowdelimiter] AS [ff_rowdelimiter],

               [ff_quotecharacter] AS [ff_quotecharacter],

               [ff_compressionlevel] AS [ff_compressionlevel],

               [ff_compressiontype] AS [ff_compressiontype],

               [ff_enablecdc] AS [ff_enablecdc],

               [ff_escapecharacter] AS [ff_escapecharacter],

               [ff_fileencoding] AS [ff_fileencoding],

               [ff_firstrow] AS [ff_firstrow],

               [ff_firstrowasheader] AS [ff_firstrowasheader],

               [ff_filesize] AS [ff_filesize],

               [ff_threshold] AS [ff_threshold],

               [mta_rectype],

               [mta_createdate],

               [mta_source],

               [mta_bk],

               [mta_bkh],

               [mta_rh],

               [mta_currentflag] = row_number() OVER (PARTITION BY [mta_bkh]
                                                 ORDER BY [mta_createdate] DESC)

          FROM [bld].[fileproperties]
       )
SELECT [filepropertiesid] AS [filepropertiesid],

       [bk] AS [bk],

       [code] AS [code],

       [description] AS [description],

       [filemask] AS [filemask],

       [filename] AS [filename],

       [filesystem] AS [filesystem],

       [folder] AS [folder],

       [ispgp] AS [ispgp],

       [expectedfilecount] AS [expectedfilecount],

       [expectedfilesize] AS [expectedfilesize],

       [bk_schedule_fileexpected] AS [bk_schedule_fileexpected],

       [dateinfilenameformat] AS [dateinfilenameformat],

       [dateinfilenamelength] AS [dateinfilenamelength],

       [dateinfilenamestartpos] AS [dateinfilenamestartpos],

       [dateinfilenameexpression] AS [dateinfilenameexpression],

       [testdateinfilename] AS [testdateinfilename],

       [ff_name] AS [ff_name],

       [ff_fileformat] AS [ff_fileformat],

       [ff_columndelimiter] AS [ff_columndelimiter],

       [ff_rowdelimiter] AS [ff_rowdelimiter],

       [ff_quotecharacter] AS [ff_quotecharacter],

       [ff_compressionlevel] AS [ff_compressionlevel],

       [ff_compressiontype] AS [ff_compressiontype],

       [ff_enablecdc] AS [ff_enablecdc],

       [ff_escapecharacter] AS [ff_escapecharacter],

       [ff_fileencoding] AS [ff_fileencoding],

       [ff_firstrow] AS [ff_firstrow],

       [ff_firstrowasheader] AS [ff_firstrowasheader],

       [ff_filesize] AS [ff_filesize],

       [ff_threshold] AS [ff_threshold],

       [mta_rectype],

       [mta_createdate],

       [mta_source],

       [mta_bk],

       [mta_bkh],

       [mta_rh],

       [mta_isdeleted] = iif([mta_rectype] = -1, 1, 0)

  FROM cur

 WHERE [mta_currentflag] = 1

   AND [mta_rectype] > -1
