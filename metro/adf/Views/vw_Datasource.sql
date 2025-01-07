


CREATE  VIEW [adf].[vw_Datasource] AS

	SELECT 
		src.BK_DataSource
		, src.IsDWH
		, src.isRep
		, src.DataSourceServer
		, src.DataSourceDatabase
		, src.DataSourceURL
		, src.DataSourceUSR
		, src.Environment
		, rt.code AS RepositoryStatus
	FROM adf.vw_DataSourceProperties_SDTAP_Values src
	JOIN rep.vw_RefType rt ON rt.name = src.Environment
	WHERE src.IsDWH = 1