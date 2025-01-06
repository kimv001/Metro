CREATE PROCEDURE [adf].[ImportDefaultMaintenanceProject]
AS


BEGIN

		BEGIN
			IF EXISTS ( SELECT ProjectName FROM adf.Projects WHERE ProjectName = 'Maintenance')
				DELETE FROM adf.Projects WHERE ProjectName = 'Maintenance' 
		END
		
		BEGIN
			INSERT INTO [adf].[Projects]
				([ProjectName], [ProjectDescription])
			VALUES
				('Maintenance',	'Maintenance and helper related flows')
		END

		BEGIN
			INSERT INTO [adf].[Flows]
				([FlowName], [FlowDescription], [ProjectId], [FlowGroup], [FlowOrder])
			VALUES
				('adfImportExport', 'Flow to import or export Project and subsequent adf', 'Maintenance', 1, 1)
		END

		BEGIN
			INSERT INTO [adf].[Jobs]
				([JobName], [JobDescription], [FlowId], [JobType], [JobGroup], [JobOrder])
			VALUES
				('Run', 'Start import or export of adf', 'Maintenance|adfImportExport', 'adfImportExport', 1, 1)
		END

		BEGIN
			INSERT INTO [adf].[ProjectParameters]
				([ProjectParameterName], [ProjectParameterValue], [ProjectParameterJobType], [ProjectId])
			VALUES
				('SourceDatabaseName', db_name(), 'adfImportExport', 'Maintenance'),
				('SinkDatabaseName', db_name(), 'adfImportExport', 'Maintenance'),
				('SourceServerFQDN', CONCAT(@@SERVERNAME, '.database.windows.net'), 'adfImportExport', 'Maintenance'),
				('SinkServerFQDN', CONCAT(@@SERVERNAME, '.database.windows.net'), 'adfImportExport', 'Maintenance')
		END
END