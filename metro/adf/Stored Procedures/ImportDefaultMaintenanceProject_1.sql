
CREATE PROCEDURE [adf].[importdefaultmaintenanceproject] AS BEGIN BEGIN IF EXISTS

        (SELECT projectname

          FROM adf.projects

         WHERE projectname = 'Maintenance'
       )
DELETE

  FROM adf.projects

 WHERE projectname = 'Maintenance' END BEGIN
INSERT INTO [adf].[projects] ([projectname], [projectdescription])

VALUES ('Maintenance',
        'Maintenance and helper related flows') END BEGIN
INSERT INTO [adf].[flows] ([flowname], [flowdescription], [projectid], [flowgroup], [floworder])

VALUES ('adfImportExport',
        'Flow to import or export Project and subsequent adf',
        'Maintenance',
        1,
        1) END BEGIN
INSERT INTO [adf].[jobs] ([jobname], [jobdescription], [flowid], [jobtype], [jobgroup], [joborder])

VALUES ('Run',
        'Start import or export of adf',
        'Maintenance|adfImportExport',
        'adfImportExport',
        1,
        1) END BEGIN
INSERT INTO [adf].[projectparameters] ([projectparametername], [projectparametervalue], [projectparameterjobtype], [projectid])

VALUES ('SourceDatabaseName',
        db_name(),
        'adfImportExport',
        'Maintenance'), ('SinkDatabaseName',
                         db_name(),
                         'adfImportExport',
                         'Maintenance'), ('SourceServerFQDN',
                                          concat(@@ servername, '.database.windows.net'),
                                          'adfImportExport',
                                          'Maintenance'), ('SinkServerFQDN',
                                                           concat(@@ servername, '.database.windows.net'),
                                                           'adfImportExport',
                                                           'Maintenance') END END
