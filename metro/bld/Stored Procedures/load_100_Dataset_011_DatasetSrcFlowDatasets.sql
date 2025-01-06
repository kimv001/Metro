﻿
CREATE proc [bld].[load_100_dataset_011_datasetsrcflowdatasets] AS /*
	Proc is generated by	: metro
	Generated at			: 2025-01-06 14:43:27

	exec [bld].[load_100_Dataset_011_DatasetSrcFlowDatasets]*/  DECLARE @routinename varchar(8000) = 'load_100_Dataset_011_DatasetSrcFlowDatasets' DECLARE @startdatetime datetime2 = getutcdate() DECLARE @enddatetime datetime2 DECLARE @duration bigint -- Create a helper temp table
 IF object_id('tempdb..#100_Dataset_011_DatasetSrcFlowDatasets') IS NOT NULL
DROP TABLE # 100_dataset_011_datasetsrcflowdatasets ; PRINT '-- create temp table:'
SELECT mta_bk = src.[bk] ,

       mta_bkh = convert(char(64),(hashbytes('sha2_512', upper(src.bk))),2) ,

       mta_rh = convert(char(64),(hashbytes('sha2_512', upper(isnull(cast(src.[bk] AS varchar(8000)), '-') + '|' + isnull(cast(src.[code] AS varchar(8000)), '-') + '|' + isnull(cast(src.[datasetname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schemaname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[layername] AS varchar(8000)), '-') + '|' + isnull(cast(src.[datasource] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_datasource] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_linkedservice] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_layer] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_schema] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_group] AS varchar(8000)), '-') + '|' + isnull(cast(src.[shortname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[src_shortname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[src_objecttype] AS varchar(8000)), '-') + '|' + isnull(cast(src.[dwhtargetshortname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[prefix] AS varchar(8000)), '-') + '|' + isnull(cast(src.[postfix] AS varchar(8000)), '-') + '|' + isnull(cast(src.[description] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_contactgroup] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_contactgroup_data_logistics] AS varchar(8000)), '-') + '|' + isnull(cast(src.[data_logistics_info] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_contactgroup_data_supplier] AS varchar(8000)), '-') + '|' + isnull(cast(src.[data_supplier_info] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_flow] AS varchar(8000)), '-') + '|' + isnull(cast(src.[floworder] AS varchar(8000)), '-') + '|' + isnull(cast(src.[floworderdesc] AS varchar(8000)), '-') + '|' + isnull(cast(src.[timestamp] AS varchar(8000)), '-') + '|' + isnull(cast(src.[businessdate] AS varchar(8000)), '-') + '|' + isnull(cast(src.[recordsrcdate] AS varchar(8000)), '-') + '|' + isnull(cast(src.[distinctvalues] AS varchar(8000)), '-') + '|' + isnull(cast(src.[wherefilter] AS varchar(8000)), '-') + '|' + isnull(cast(src.[partitionstatement] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_reftype_objecttype] AS varchar(8000)), '-') + '|' + isnull(cast(src.[fullload] AS varchar(8000)), '-') + '|' + isnull(cast(src.[insertonly] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bigdata] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_template_load] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_template_create] AS varchar(8000)), '-') + '|' + isnull(cast(src.[customstagingview] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_reftype_repositorystatus] AS varchar(8000)), '-') + '|' + isnull(cast(src.[issystem] AS varchar(8000)), '-') + '|' + isnull(cast(src.[isdwh] AS varchar(8000)), '-') + '|' + isnull(cast(src.[issrc] AS varchar(8000)), '-') + '|' + isnull(cast(src.[istgt] AS varchar(8000)), '-') + '|' + isnull(cast(src.[isrep] AS varchar(8000)), '-') + '|' + isnull(cast(src.[firstdefaultdwhview] AS varchar(8000)), '-') + '|' + isnull(cast(src.[createdummies] AS varchar(8000)), '-') + '|' + isnull(cast(src.[objecttype] AS varchar(8000)), '-') + '|' + isnull(cast(src.[repositorystatusname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[repositorystatuscode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[view_defintion_contains_business_logic] AS varchar(8000)), '-') + '|' + isnull(cast(src.[view_defintion] AS varchar(8000)), '-') + '|' + isnull(cast(src.[todeploy] AS varchar(8000)), '-')))),2) ,

       mta_source = '[bld].[tr_100_Dataset_011_DatasetSrcFlowDatasets]' ,

       mta_rectype = CASE
                         WHEN tgt.[bk] IS NULL                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            THEN 1

            WHEN tgt.[mta_rh] != convert(char(64),(hashbytes('sha2_512', upper(isnull(cast(src.[bk] AS varchar(8000)), '-') + '|' + isnull(cast(src.[code] AS varchar(8000)), '-') + '|' + isnull(cast(src.[datasetname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[schemaname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[layername] AS varchar(8000)), '-') + '|' + isnull(cast(src.[datasource] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_datasource] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_linkedservice] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_layer] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_schema] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_group] AS varchar(8000)), '-') + '|' + isnull(cast(src.[shortname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[src_shortname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[src_objecttype] AS varchar(8000)), '-') + '|' + isnull(cast(src.[dwhtargetshortname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[prefix] AS varchar(8000)), '-') + '|' + isnull(cast(src.[postfix] AS varchar(8000)), '-') + '|' + isnull(cast(src.[description] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_contactgroup] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_contactgroup_data_logistics] AS varchar(8000)), '-') + '|' + isnull(cast(src.[data_logistics_info] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_contactgroup_data_supplier] AS varchar(8000)), '-') + '|' + isnull(cast(src.[data_supplier_info] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_flow] AS varchar(8000)), '-') + '|' + isnull(cast(src.[floworder] AS varchar(8000)), '-') + '|' + isnull(cast(src.[floworderdesc] AS varchar(8000)), '-') + '|' + isnull(cast(src.[timestamp] AS varchar(8000)), '-') + '|' + isnull(cast(src.[businessdate] AS varchar(8000)), '-') + '|' + isnull(cast(src.[recordsrcdate] AS varchar(8000)), '-') + '|' + isnull(cast(src.[distinctvalues] AS varchar(8000)), '-') + '|' + isnull(cast(src.[wherefilter] AS varchar(8000)), '-') + '|' + isnull(cast(src.[partitionstatement] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_reftype_objecttype] AS varchar(8000)), '-') + '|' + isnull(cast(src.[fullload] AS varchar(8000)), '-') + '|' + isnull(cast(src.[insertonly] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bigdata] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_template_load] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_template_create] AS varchar(8000)), '-') + '|' + isnull(cast(src.[customstagingview] AS varchar(8000)), '-') + '|' + isnull(cast(src.[bk_reftype_repositorystatus] AS varchar(8000)), '-') + '|' + isnull(cast(src.[issystem] AS varchar(8000)), '-') + '|' + isnull(cast(src.[isdwh] AS varchar(8000)), '-') + '|' + isnull(cast(src.[issrc] AS varchar(8000)), '-') + '|' + isnull(cast(src.[istgt] AS varchar(8000)), '-') + '|' + isnull(cast(src.[isrep] AS varchar(8000)), '-') + '|' + isnull(cast(src.[firstdefaultdwhview] AS varchar(8000)), '-') + '|' + isnull(cast(src.[createdummies] AS varchar(8000)), '-') + '|' + isnull(cast(src.[objecttype] AS varchar(8000)), '-') + '|' + isnull(cast(src.[repositorystatusname] AS varchar(8000)), '-') + '|' + isnull(cast(src.[repositorystatuscode] AS varchar(8000)), '-') + '|' + isnull(cast(src.[view_defintion_contains_business_logic] AS varchar(8000)), '-') + '|' + isnull(cast(src.[view_defintion] AS varchar(8000)), '-') + '|' + isnull(cast(src.[todeploy] AS varchar(8000)), '-')))),2) THEN 0

            ELSE -99

             END INTO # 100_dataset_011_datasetsrcflowdatasets

  FROM [bld].[tr_100_dataset_011_datasetsrcflowdatasets] src

  LEFT JOIN [bld].[vw_dataset] tgt
    ON src.[bk] = tgt.[bk]
CREATE clustered INDEX [ix_tr_100_dataset_011_datasetsrcflowdatasets]
    ON # 100_dataset_011_datasetsrcflowdatasets([mta_bkh] ASC, [mta_rh] ASC) --------------------- start loading data
 PRINT '-- new records:'

   SET @startdatetime = getdate()
INSERT INTO [bld].[dataset] ([bk], [code], [datasetname], [schemaname], [layername], [datasource], [bk_datasource], [bk_linkedservice], [bk_layer], [bk_schema], [bk_group], [shortname], [src_shortname], [src_objecttype], [dwhtargetshortname], [prefix], [postfix], [description], [bk_contactgroup], [bk_contactgroup_data_logistics], [data_logistics_info], [bk_contactgroup_data_supplier], [data_supplier_info], [bk_flow], [floworder], [floworderdesc], [timestamp], [businessdate], [recordsrcdate], [distinctvalues], [wherefilter], [partitionstatement], [bk_reftype_objecttype], [fullload], [insertonly], [bigdata], [bk_template_load], [bk_template_create], [customstagingview], [bk_reftype_repositorystatus], [issystem], [isdwh], [issrc], [istgt], [isrep], [firstdefaultdwhview], [createdummies], [objecttype], [repositorystatusname], [repositorystatuscode], [view_defintion_contains_business_logic], [view_defintion], [todeploy] , [mta_bk], [mta_bkh], [mta_rh], [mta_source], [mta_rectype])
SELECT src.[bk],

       src.[code],

       src.[datasetname],

       src.[schemaname],

       src.[layername],

       src.[datasource],

       src.[bk_datasource],

       src.[bk_linkedservice],

       src.[bk_layer],

       src.[bk_schema],

       src.[bk_group],

       src.[shortname],

       src.[src_shortname],

       src.[src_objecttype],

       src.[dwhtargetshortname],

       src.[prefix],

       src.[postfix],

       src.[description],

       src.[bk_contactgroup],

       src.[bk_contactgroup_data_logistics],

       src.[data_logistics_info],

       src.[bk_contactgroup_data_supplier],

       src.[data_supplier_info],

       src.[bk_flow],

       src.[floworder],

       src.[floworderdesc],

       src.[timestamp],

       src.[businessdate],

       src.[recordsrcdate],

       src.[distinctvalues],

       src.[wherefilter],

       src.[partitionstatement],

       src.[bk_reftype_objecttype],

       src.[fullload],

       src.[insertonly],

       src.[bigdata],

       src.[bk_template_load],

       src.[bk_template_create],

       src.[customstagingview],

       src.[bk_reftype_repositorystatus],

       src.[issystem],

       src.[isdwh],

       src.[issrc],

       src.[istgt],

       src.[isrep],

       src.[firstdefaultdwhview],

       src.[createdummies],

       src.[objecttype],

       src.[repositorystatusname],

       src.[repositorystatuscode],

       src.[view_defintion_contains_business_logic],

       src.[view_defintion],

       src.[todeploy] ,

       h.[mta_bk],

       h.[mta_bkh],

       h.[mta_rh],

       h.[mta_source],

       h.[mta_rectype]

  FROM [bld].[tr_100_dataset_011_datasetsrcflowdatasets] src

  JOIN # 100_dataset_011_datasetsrcflowdatasets h
    ON h.[mta_bk] = src.[bk]

  LEFT JOIN [bld].[vw_dataset] tgt
    ON h.[mta_bkh] = tgt.[mta_bkh]

 WHERE 1 = 1

   AND cast(h.mta_rectype AS int) = 1

   AND tgt.[mta_bkh] IS NULL

   SET @enddatetime = getutcdate() EXEC [aud].[proc_log_procedure] @logaction = 'INSERT - NEW',

       @lognote = 'New Records',

       @logprocedure = @routinename,

       @logsql = 'Insert Into [bld].[Dataset]',

       @logrowcount = @@ rowcount,

       @log_timestart = @startdatetime,

       @log_timeend = @enddatetime; PRINT '-- changed records:'

   SET @startdatetime = getdate()
  INSERT INTO [bld].[dataset] ([bk], [code], [datasetname], [schemaname], [layername], [datasource], [bk_datasource], [bk_linkedservice], [bk_layer], [bk_schema], [bk_group], [shortname], [src_shortname], [src_objecttype], [dwhtargetshortname], [prefix], [postfix], [description], [bk_contactgroup], [bk_contactgroup_data_logistics], [data_logistics_info], [bk_contactgroup_data_supplier], [data_supplier_info], [bk_flow], [floworder], [floworderdesc], [timestamp], [businessdate], [recordsrcdate], [distinctvalues], [wherefilter], [partitionstatement], [bk_reftype_objecttype], [fullload], [insertonly], [bigdata], [bk_template_load], [bk_template_create], [customstagingview], [bk_reftype_repositorystatus], [issystem], [isdwh], [issrc], [istgt], [isrep], [firstdefaultdwhview], [createdummies], [objecttype], [repositorystatusname], [repositorystatuscode], [view_defintion_contains_business_logic], [view_defintion], [todeploy] , [mta_bk], [mta_bkh], [mta_rh], [mta_source], [mta_rectype])
SELECT src.[bk],

       src.[code],

       src.[datasetname],

       src.[schemaname],

       src.[layername],

       src.[datasource],

       src.[bk_datasource],

       src.[bk_linkedservice],

       src.[bk_layer],

       src.[bk_schema],

       src.[bk_group],

       src.[shortname],

       src.[src_shortname],

       src.[src_objecttype],

       src.[dwhtargetshortname],

       src.[prefix],

       src.[postfix],

       src.[description],

       src.[bk_contactgroup],

       src.[bk_contactgroup_data_logistics],

       src.[data_logistics_info],

       src.[bk_contactgroup_data_supplier],

       src.[data_supplier_info],

       src.[bk_flow],

       src.[floworder],

       src.[floworderdesc],

       src.[timestamp],

       src.[businessdate],

       src.[recordsrcdate],

       src.[distinctvalues],

       src.[wherefilter],

       src.[partitionstatement],

       src.[bk_reftype_objecttype],

       src.[fullload],

       src.[insertonly],

       src.[bigdata],

       src.[bk_template_load],

       src.[bk_template_create],

       src.[customstagingview],

       src.[bk_reftype_repositorystatus],

       src.[issystem],

       src.[isdwh],

       src.[issrc],

       src.[istgt],

       src.[isrep],

       src.[firstdefaultdwhview],

       src.[createdummies],

       src.[objecttype],

       src.[repositorystatusname],

       src.[repositorystatuscode],

       src.[view_defintion_contains_business_logic],

       src.[view_defintion],

       src.[todeploy] ,

       h.[mta_bk],

       h.[mta_bkh],

       h.[mta_rh],

       h.[mta_source],

       h.[mta_rectype]

  FROM [bld].[tr_100_dataset_011_datasetsrcflowdatasets] src

  JOIN # 100_dataset_011_datasetsrcflowdatasets h
    ON h.[mta_bk] = src.[bk]

 WHERE 1 = 1

   AND cast(h.mta_rectype AS int) = 0

   SET @enddatetime = getutcdate() EXEC [aud].[proc_log_procedure] @logaction = 'INSERT - CHG',

       @lognote = 'Changed Records',

       @logprocedure = @routinename,

       @logsql = 'Insert Into [bld].[Dataset]',

       @logrowcount = @@ rowcount,

       @log_timestart = @startdatetime,

       @log_timeend = @enddatetime; PRINT '-- deleted records:'

   SET @startdatetime = getdate()
  INSERT INTO [bld].[dataset] ([bk], [code], [datasetname], [schemaname], [layername], [datasource], [bk_datasource], [bk_linkedservice], [bk_layer], [bk_schema], [bk_group], [shortname], [src_shortname], [src_objecttype], [dwhtargetshortname], [prefix], [postfix], [description], [bk_contactgroup], [bk_contactgroup_data_logistics], [data_logistics_info], [bk_contactgroup_data_supplier], [data_supplier_info], [bk_flow], [floworder], [floworderdesc], [timestamp], [businessdate], [recordsrcdate], [distinctvalues], [wherefilter], [partitionstatement], [bk_reftype_objecttype], [fullload], [insertonly], [bigdata], [bk_template_load], [bk_template_create], [customstagingview], [bk_reftype_repositorystatus], [issystem], [isdwh], [issrc], [istgt], [isrep], [firstdefaultdwhview], [createdummies], [objecttype], [repositorystatusname], [repositorystatuscode], [view_defintion_contains_business_logic], [view_defintion], [todeploy] , [mta_bk], [mta_bkh], [mta_rh], [mta_source], [mta_rectype])
SELECT src.[bk],

       src.[code],

       src.[datasetname],

       src.[schemaname],

       src.[layername],

       src.[datasource],

       src.[bk_datasource],

       src.[bk_linkedservice],

       src.[bk_layer],

       src.[bk_schema],

       src.[bk_group],

       src.[shortname],

       src.[src_shortname],

       src.[src_objecttype],

       src.[dwhtargetshortname],

       src.[prefix],

       src.[postfix],

       src.[description],

       src.[bk_contactgroup],

       src.[bk_contactgroup_data_logistics],

       src.[data_logistics_info],

       src.[bk_contactgroup_data_supplier],

       src.[data_supplier_info],

       src.[bk_flow],

       src.[floworder],

       src.[floworderdesc],

       src.[timestamp],

       src.[businessdate],

       src.[recordsrcdate],

       src.[distinctvalues],

       src.[wherefilter],

       src.[partitionstatement],

       src.[bk_reftype_objecttype],

       src.[fullload],

       src.[insertonly],

       src.[bigdata],

       src.[bk_template_load],

       src.[bk_template_create],

       src.[customstagingview],

       src.[bk_reftype_repositorystatus],

       src.[issystem],

       src.[isdwh],

       src.[issrc],

       src.[istgt],

       src.[isrep],

       src.[firstdefaultdwhview],

       src.[createdummies],

       src.[objecttype],

       src.[repositorystatusname],

       src.[repositorystatuscode],

       src.[view_defintion_contains_business_logic],

       src.[view_defintion],

       src.[todeploy] ,

       src.[mta_bk],

       src.[mta_bkh],

       src.[mta_rh],

       src.[mta_source],

       [mta_rectype] = -1

  FROM [bld].[vw_dataset] src

  LEFT JOIN # 100_dataset_011_datasetsrcflowdatasets h
    ON h.[mta_bkh] = src.[mta_bkh]

   AND h.[mta_source] = src.[mta_source]

 WHERE 1 = 1

   AND h.[mta_bkh] IS NULL

   AND src.mta_source = '[bld].[tr_100_Dataset_011_DatasetSrcFlowDatasets]'

   SET @enddatetime = getutcdate() EXEC [aud].[proc_log_procedure] @logaction = 'INSERT - DEL',

       @lognote = 'Changed Deleted',

       @logprocedure = @routinename,

       @logsql = 'Insert Into [bld].[Dataset]',

       @logrowcount = @@ rowcount,

       @log_timestart = @startdatetime,

       @log_timeend = @enddatetime ; -- Clean up ...
 IF object_id('tempdb..#100_Dataset_011_DatasetSrcFlowDatasets') IS NOT NULL
  DROP TABLE # 100_dataset_011_datasetsrcflowdatasets;

   SET @enddatetime = getutcdate()

   SET @duration = datediff(ss, @startdatetime, @enddatetime) PRINT 'Load "load_100_Dataset_011_DatasetSrcFlowDatasets" took ' + cast(@duration AS varchar(10)) + ' second(s)'
