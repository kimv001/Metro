


CREATE  VIEW [adf].[vw_Datasource] AS

	Select 
		src.BK_DataSource
		, src.IsDWH
		, src.isRep
		, src.DataSourceServer
		, src.DataSourceDatabase
		, src.DataSourceURL
		, src.DataSourceUSR
		, src.Environment
		, rt.code as RepositoryStatus
	From adf.vw_DataSourceProperties_SDTAP_Values src
	join rep.vw_RefType rt on rt.name = src.Environment
	where src.IsDWH = 1