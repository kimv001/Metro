CREATE VIEW [adf].[vw_TGT_Export_from_SRC] AS
SELECT 
    TGT                   = e.[export_name],	 
    SRC_BK_DataSet        = e.bk_dataset,
    [SRC_DataSet]         = e.[export_name], -- e.src_dataset,
    [SRC_ShortName]       = e.SRC_ShortName,
    SRC_SourceName        = e.[export_name], -- e.SRC_Group + '_' + e.SRC_ShortName,
    SRC_DatasetType       = e.SRC_DatasetType,
    TGT_DatasetType       = 'File',
    [SRC_Group]           = e.src_group,
    [SRC_Schema]          = e.src_schema,
    [SRC_Layer]           = e.src_layer,
    generation_number     = 1, -- DENSE_RANK() OVER (PARTITION BY [TGT_Group] ORDER BY [generation_number])
    DependencyType        = 'export-file',
    [RepositoryStatusName]= e.RepositoryStatusName,
    [RepositoryStatusCode]= e.RepositoryStatusCode
FROM bld.vw_Exports e;
