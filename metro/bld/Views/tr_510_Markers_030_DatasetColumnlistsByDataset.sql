 -- noqa: PRS
 -- noqa: LT05


CREATE VIEW [bld].[tr_510_Markers_030_DatasetColumnlistsByDataset] AS 
/* 
=== Comments =========================================

Description:
	creates dataset markers unique by dataset. Mostly when all columns or all mta columns are selected
	Builded markers:
	<!<TGT_DDLcolumnlist>>
	<!<TGT_ColumnList>>
	<!<SRC_ColumnList_SRC>>
	<!<SRC_ColumnList>>
	<!<SRC_BK_SRC>>
	<!<SRC_Dummies_Unknown>>
	<!<SRC_Dummies_Empty>>

get actual list:
select distinct marker, MarkerDescription from [bld].[tr_510_Markers_030_DatasetColumnlistsByDataset]

DECLARE @Output NVARCHAR(MAX);

SELECT distinct @Output = STRING_AGG(
    'Marker: ' + cast(Marker as NVARCHAR(MAX)) + CHAR(13) + CHAR(10) + 
    'Description: ' + cast(MarkerDescription as NVARCHAR(MAX)) + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10),
    ''
) WITHIN GROUP (ORDER BY Marker)
FROM (
    SELECT DISTINCT Marker, MarkerDescription
    FROM [bld].[tr_510_Markers_030_DatasetColumnlistsByDataset]
) AS DistinctMarkers;

PRINT @Output;

DECLARE @Output NVARCHAR(MAX);

WITH RankedMarkers AS (
    SELECT 
        Marker, 
        markervalue,
        ROW_NUMBER() OVER (PARTITION BY Marker ORDER BY Marker) AS rn
    FROM [bld].[tr_510_Markers_030_DatasetColumnlistsByDataset]
)
SELECT @Output = STRING_AGG(
     
    'Marker: ' + cast(Marker as NVARCHAR(MAX)) + CHAR(13) + CHAR(10) + 
    'Description: ' + CHAR(10) +cast(markervalue as NVARCHAR(MAX)) + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10),
    CHAR(9) + '' + CHAR(10)
) WITHIN GROUP (ORDER BY Marker)
FROM (
    SELECT TOP 100  Marker, markervalue
    FROM RankedMarkers
    WHERE rn = 1
    ORDER BY Marker
) AS TopDistinctMarkers;

PRINT @Output;

	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230226	1400		K. Vermeij				Add column [mta_rectype] to Activate SmartLoad
20230917	1231		K. Vermeij				instead of calling a function which worked with a "FOR XML PATH('')" the view uses 
												STRING_AGG( CONVERT(VARCHAR(max), QUOTENAME(A.AttributeName)) 
												with the convert max you can extend the 8000 characters :-D
												and it works really fast in comparison with "FOR XML PATH('')"
=======================================================
*/



WITH base AS (

	SELECT  

		 bk							= tgt.bk
		, bkbase					= base.bk
		, dd.code 
		, bksource					= src.bk
		, bktarget					= tgt.bk


		, bk_dataset				= tgt.bk
	
		, bk_reftype_objecttype		= tgt.bk_reftype_objecttype
		, bk_schema					= tgt.bk_schema
		, schemaname				= tgt.schemaname
		, mta_rectype				= diff.rectype
		--, tgt.TGT_ObjectType
		, createdummies				= CASE WHEN tgt.createdummies =1 AND tgt.tgt_objecttype = 'Table' THEN 1 ELSE 0 END
	FROM   bld.vw_dataset base
	JOIN bld.vw_markerssmartload	diff	ON base.code	= diff.code 
	JOIN bld.vw_datasetdependency	dd		ON base.code	= dd.code
	JOIN bld.vw_dataset				src		ON src.bk		= dd.bk_parent
	JOIN bld.vw_dataset				tgt		ON tgt.bk		= dd.bk_child

	WHERE 1=1
		AND dd.dependencytype = 'SrcToTgt'
		AND dd.mta_source != '[bld].[tr_400_DatasetDependency_030_TransformationViewsDWH]'
		AND dd.bk_parent != 'src'
		AND base.code=base.bk
		AND CAST(diff.rectype AS int)>-99
	)


						




, markerbuild AS (



	SELECT
		  src.bk_dataset		
		, src.code
		, marker				= '<!<TGT_DDLcolumnlist>>'

		-- example value:
		--   [Id] [varchar](8000) NULL ,  [Id] [varchar](8000) NULL ,  [Id] [varchar](8000) NULL ,  [Id] [varchar](8000) NULL ,  [Id] [varchar](8000) NULL ,  [Id] [varchar](8000) NULL ,  [Name] [varchar](8000) NULL ,  [Name] [varchar](8000) NULL ,  [Name] [varchar](8000) NULL ,  [Name] [varchar](8000) NULL ,  [Name] [varchar](8000) NULL ,  [Name] [varchar](8000) NULL ,  [ProductCode] [varchar](8000) NULL ,  [ProductCode] [varchar](8000) NULL ,  [ProductCode] [varchar](8000) NULL ,  [ProductCode] [varchar](8000) NULL ,  [ProductCode] [varchar](8000) NULL ,  [ProductCode] [varchar](8000) NULL ,  [Description] [varchar](8000) NULL ,  [Description] [varchar](8000) NULL ,  [Description] [varchar](8000) NULL ,  [Description] [varchar](8000) NULL ,  [Description] [varchar](8000) NULL ,  [Description] [varchar](8000) NULL ,  [QuantityScheduleType] [varchar](8000) NULL ,  [QuantityScheduleType] [varchar](8000) NULL ,  [QuantityScheduleType] [varchar](8000) NULL ,  [QuantityScheduleType] [varchar](8000) NULL ,  [QuantityScheduleType] [varchar](8000) NULL ,  [QuantityScheduleType] [varchar](8000) NULL ,  [QuantityInstallmentPeriod] [varchar](8000) NULL ,  [QuantityInstallmentPeriod] [varchar](8000) NULL ,  [QuantityInstallmentPeriod] [varchar](8000) NULL ,  [QuantityInstallmentPeriod] [varchar](8000) NULL ,  [QuantityInstallmentPeriod] [varchar](8000) NULL ,  [QuantityInstallmentPeriod] [varchar](8000) NULL ,  [NumberOfQuantityInstallments] [varchar](8000) NULL ,  [NumberOfQuantityInstallments] [varchar](8000) NULL ,  [NumberOfQuantityInstallments] [varchar](8000) NULL ,  [NumberOfQuantityInstallments] [varchar](8000) NULL ,  [NumberOfQuantityInstallments] [varchar](8000) NULL ,  [NumberOfQuantityInstallments] [varchar](8000) NULL ,  [RevenueScheduleType] [varchar](8000) NULL ,  [RevenueScheduleType] [varchar](8000) NULL ,  [RevenueScheduleType] [varchar](8000) NULL ,  [RevenueScheduleType] [varchar](8000) NULL ,  [RevenueScheduleType] [varchar](8000) NULL ,  [RevenueScheduleType] [varchar](8000) NULL ,  [RevenueInstallmentPeriod] [varchar](8000) NULL ,  [RevenueInstallmentPeriod] [varchar](8000) NULL ,  [RevenueInstallmentPeriod] [varchar](8000) NULL ,  [RevenueInstallmentPeriod] [varchar](8000) NULL ,  [RevenueInstallmentPeriod] [varchar](8000) NULL ,  [RevenueInstallmentPeriod] [varchar](8000) NULL ,  [NumberOfRevenueInstallments] [varchar](8000) NULL ,  [NumberOfRevenueInstallments] [varchar](8000) NULL ,  [NumberOfRevenueInstallments] [varchar](8000) NULL ,  [NumberOfRevenueInstallments] [varchar](8000) NULL ,  [NumberOfRevenueInstallments] [varchar](8000) NULL ,  [NumberOfRevenueInstallments] [varchar](8000) NULL ,  [CanUseQuantitySchedule] [varchar](8000) NULL ,  [CanUseQuantitySchedule] [varchar](8000) NULL ,  [CanUseQuantitySchedule] [varchar](8000) NULL ,  [CanUseQuantitySchedule] [varchar](8000) NULL ,  [CanUseQuantitySchedule] [varchar](8000) NULL ,  [CanUseQuantitySchedule] [varchar](8000) NULL ,  [CanUseRevenueSchedule] [varchar](8000) NULL ,  [CanUseRevenueSchedule] [varchar](8000) NULL ,  [CanUseRevenueSchedule] [varchar](8000) NULL ,  [CanUseRevenueSchedule] [varchar](8000) NULL ,  [CanUseRevenueSchedule] [varchar](8000) NULL ,  [CanUseRevenueSchedule] [varchar](8000) NULL ,  [IsActive] [varchar](8000) NULL ,  [IsActive] [varchar](8000) NULL ,  [IsActive] [varchar](8000) NULL ,  [IsActive] [varchar](8000) NULL ,  [IsActive] [varchar](8000) NULL ,  [IsActive] [varchar](8000) NULL ,  [CreatedDate] [varchar](8000) NULL ,  [CreatedDate] [varchar](8000) NULL ,  [CreatedDate] [varchar](8000) NULL ,  [CreatedDate] [varchar](8000) NULL ,  [CreatedDate] [varchar](8000) NULL ,  [CreatedDate] [varchar](8000) NULL ,  [CreatedById] [varchar](8000) NULL ,  [CreatedById] [varchar](8000) NULL ,  [CreatedById] [varchar](8000) NULL ,  [CreatedById] [varchar](8000) NULL ,  [CreatedById] [varchar](8000) NULL ,  [CreatedById] [varchar](8000) NULL ,  [LastModifiedDate] [varchar](8000) NULL ,  [LastModifiedDate] [varchar](8000) NULL ,  [LastModifiedDate] [varchar](8000) NULL ,  [LastModifiedDate] [varchar](8000) NULL ,  [LastModifiedDate] [varchar](8000) NULL ,  [LastModifiedDate] [varchar](8000) NULL ,  [LastModifiedById] [varchar](8000) NULL ,  [LastModifiedById] [varchar](8000) NULL ,  [LastModifiedById] [varchar](8000) NULL ,  [LastModifiedById] [varchar](8000) NULL ,  [LastModifiedById] [varchar](8000) NULL ,  [LastModifiedById] [varchar](8000) NULL ,  [SystemModstamp] [varchar](8000) NULL ,  [SystemModstamp] [varchar](8000) NULL ,  [SystemModstamp] [varchar](8000) NULL ,  [SystemModstamp] [varchar](8000) NULL ,  [SystemModstamp] [varchar](8000) NULL ,  [SystemModstamp] [varchar](8000) NULL ,  [Family] [varchar](8000) NULL ,  [Family] [varchar](8000) NULL ,  [Family] [varchar](8000) NULL ,  [Family] [varchar](8000) NULL ,  [Family] [varchar](8000) NULL ,  [Family] [varchar](8000) NULL ,  [ExternalDataSourceId] [varchar](8000) NULL ,  [ExternalDataSourceId] [varchar](8000) NULL ,  [ExternalDataSourceId] [varchar](8000) NULL ,  [ExternalDataSourceId] [varchar](8000) NULL ,  [ExternalDataSourceId] [varchar](8000) NULL ,  [ExternalDataSourceId] [varchar](8000) NULL ,  [ExternalId] [varchar](8000) NULL ,  [ExternalId] [varchar](8000) NULL ,  [ExternalId] [varchar](8000) NULL ,  [ExternalId] [varchar](8000) NULL ,  [ExternalId] [varchar](8000) NULL ,  [ExternalId] [varchar](8000) NULL ,  [DisplayUrl] [varchar](8000) NULL ,  [DisplayUrl] [varchar](8000) NULL ,  [DisplayUrl] [varchar](8000) NULL ,  [DisplayUrl] [varchar](8000) NULL ,  [DisplayUrl] [varchar](8000) NULL ,  [DisplayUrl] [varchar](8000) NULL ,  [QuantityUnitOfMeasure] [varchar](8000) NULL ,  [QuantityUnitOfMeasure] [varchar](8000) NULL ,  [QuantityUnitOfMeasure] [varchar](8000) NULL ,  [QuantityUnitOfMeasure] [varchar](8000) NULL ,  [QuantityUnitOfMeasure] [varchar](8000) NULL ,  [QuantityUnitOfMeasure] [varchar](8000) NULL ,  [IsDeleted] [varchar](8000) NULL ,  [IsDeleted] [varchar](8000) NULL ,  [IsDeleted] [varchar](8000) NULL ,  [IsDeleted] [varchar](8000) NULL ,  [IsDeleted] [varchar](8000) NULL ,  [IsDeleted] [varchar](8000) NULL ,  [IsArchived] [varchar](8000) NULL ,  [IsArchived] [varchar](8000) NULL ,  [IsArchived] [varchar](8000) NULL ,  [IsArchived] [varchar](8000) NULL ,  [IsArchived] [varchar](8000) NULL ,  [IsArchived] [varchar](8000) NULL ,  [LastViewedDate] [varchar](8000) NULL ,  [LastViewedDate] [varchar](8000) NULL ,  [LastViewedDate] [varchar](8000) NULL ,  [LastViewedDate] [varchar](8000) NULL ,  [LastViewedDate] [varchar](8000) NULL ,  [LastViewedDate] [varchar](8000) NULL ,  [LastReferencedDate] [varchar](8000) NULL ,  [LastReferencedDate] [varchar](8000) NULL ,  [LastReferencedDate] [varchar](8000) NULL ,  [LastReferencedDate] [varchar](8000) NULL ,  [LastReferencedDate] [varchar](8000) NULL ,  [LastReferencedDate] [varchar](8000) NULL ,  [StockKeepingUnit] [varchar](8000) NULL ,  [StockKeepingUnit] [varchar](8000) NULL ,  [StockKeepingUnit] [varchar](8000) NULL ,  [StockKeepingUnit] [varchar](8000) NULL ,  [StockKeepingUnit] [varchar](8000) NULL ,  [StockKeepingUnit] [varchar](8000) NULL ,  [External_Id__c] [varchar](8000) NULL ,  [External_Id__c] [varchar](8000) NULL ,  [External_Id__c] [varchar](8000) NULL ,  [External_Id__c] [varchar](8000) NULL ,  [External_Id__c] [varchar](8000) NULL ,  [External_Id__c] [varchar](8000) NULL ,  [Product_Id__c] [varchar](8000) NULL ,  [Product_Id__c] [varchar](8000) NULL ,  [Product_Id__c] [varchar](8000) NULL ,  [Product_Id__c] [varchar](8000) NULL ,  [Product_Id__c] [varchar](8000) NULL ,  [Product_Id__c] [varchar](8000) NULL ,  [SLA_hours__c] [varchar](8000) NULL ,  [SLA_hours__c] [varchar](8000) NULL ,  [SLA_hours__c] [varchar](8000) NULL ,  [SLA_hours__c] [varchar](8000) NULL ,  [SLA_hours__c] [varchar](8000) NULL ,  [SLA_hours__c] [varchar](8000) NULL ,  [mta_LoadDate] [datetime2] NULL ,  [mta_LoadDate] [datetime2] NULL ,  [mta_LoadDate] [datetime2] NULL ,  [mta_LoadDate] [datetime2] NULL ,  [mta_LoadDate] [datetime2] NULL ,  [mta_LoadDate] [datetime2] NULL ,  [mta_Source] [varchar](255) NULL ,  [mta_Source] [varchar](255) NULL ,  [mta_Source] [varchar](255) NULL ,  [mta_Source] [varchar](255) NULL ,  [mta_Source] [varchar](255) NULL ,  [mta_Source] [varchar](255) NULL ,  [mta_DateInFileName] [varchar](20) NULL ,  [mta_DateInFileName] [varchar](20) NULL ,  [mta_DateInFileName] [varchar](20) NULL ,  [mta_DateInFileName] [varchar](20) NULL ,  [mta_DateInFileName] [varchar](20) NULL ,  [mta_DateInFileName] [varchar](20) NULL ,  [mta_PipelineRunID] [varchar](255) NULL ,  [mta_PipelineRunID] [varchar](255) NULL ,  [mta_PipelineRunID] [varchar](255) NULL ,  [mta_PipelineRunID] [varchar](255) NULL ,  [mta_PipelineRunID] [varchar](255) NULL ,  [mta_PipelineRunID] [varchar](255) NULL ,  [mta_PipelineTriggerID] [varchar](255) NULL ,  [mta_PipelineTriggerID] [varchar](255) NULL ,  [mta_PipelineTriggerID] [varchar](255) NULL ,  [mta_PipelineTriggerID] [varchar](255) NULL ,  [mta_PipelineTriggerID] [varchar](255) NULL ,  [mta_PipelineTriggerID] [varchar](255) NULL ,  [mta_Valid] [smallint] NULL ,  [mta_Valid] [smallint] NULL ,  [mta_Valid] [smallint] NULL ,  [mta_Valid] [smallint] NULL ,  [mta_Valid] [smallint] NULL ,  [mta_Valid] [smallint] NULL 
		, markervalue		= STRING_AGG(
									CONVERT(VARCHAR(MAX), QUOTENAME(a.attributename) + ' ' + a.[DDL_Type2] + char(10))  
									, CHAR(9) + ', '
								) WITHIN GROUP (ORDER BY CAST(a.ordinalposition AS int))

	
		
								--STRING_AGG(
								--		CHAR(9)+CONVERT(VARCHAR(max),
								--			QUOTENAME(A.AttributeName)+' ' +a.[DDL_Type2] 
								--			+char(10)
								--		)
								--	,', ' ) WITHIN GROUP (ORDER BY  cast(a.OrdinalPosition as int))						
								
	

		, markerdescription		=	
'Start marker at posistion with 1 tab
Output should look like this:
	[monitor_datasetSk] [int] NULL 
'+CHAR(9) +', [expected_datesk] [int] NULL 
'+CHAR(9) +', [delivered_datesk] [int] NULL'
	FROM base src
	JOIN bld.vw_attribute a ON src.bktarget = a.bk_dataset
	WHERE 1=1
		AND src.bk_reftype_objecttype  = 'OT|T|Table'
	GROUP BY 
		src.bk_dataset		
		, src.code


	UNION ALL


	SELECT
		  src.bk_dataset		
		, src.code
		, marker				= '<!<TGT_ColumnList>>'
		-- example value:
		--  [Id], [Name], [ProductCode], [Description], [QuantityScheduleType], [QuantityInstallmentPeriod], [NumberOfQuantityInstallments], [RevenueScheduleType], [RevenueInstallmentPeriod], [NumberOfRevenueInstallments], [CanUseQuantitySchedule], [CanUseRevenueSchedule], [IsActive], [CreatedDate], [CreatedById], [LastModifiedDate], [LastModifiedById], [SystemModstamp], [Family], [ExternalDataSourceId], [ExternalId], [DisplayUrl], [QuantityUnitOfMeasure], [IsDeleted], [IsArchived], [LastViewedDate], [LastReferencedDate], [StockKeepingUnit], [External_Id__c], [Product_Id__c], [SLA_hours__c], [mta_LoadDate], [mta_Source], [mta_DateInFileName], [mta_PipelineRunID], [mta_PipelineTriggerID], [mta_Valid]
		, markervalue			= STRING_AGG(
										CHAR(9)+
										CONVERT(VARCHAR(MAX),
											QUOTENAME(a.attributename)
											+char(10)
										)
									,', ' ) WITHIN GROUP (ORDER BY  CAST(a.ordinalposition AS int))		
		, markerdescription		= ''
	FROM base src
	JOIN bld.vw_attribute a ON src.bktarget = a.bk_dataset
	WHERE 1=1
	GROUP BY 
		src.bk_dataset		
		, src.code
	
	UNION ALL

	SELECT
		  src.bk_dataset		
		, src.code
		, marker				= '<!<SRC_ColumnList_SRC>>'
		-- Example Value:
		--  SRC.[Id], SRC.[Name], SRC.[ProductCode], SRC.[Description], SRC.[QuantityScheduleType], SRC.[QuantityInstallmentPeriod], SRC.[NumberOfQuantityInstallments], SRC.[RevenueScheduleType], SRC.[RevenueInstallmentPeriod], SRC.[NumberOfRevenueInstallments], SRC.[CanUseQuantitySchedule], SRC.[CanUseRevenueSchedule], SRC.[IsActive], SRC.[CreatedDate], SRC.[CreatedById], SRC.[LastModifiedDate], SRC.[LastModifiedById], SRC.[SystemModstamp], SRC.[Family], SRC.[ExternalDataSourceId], SRC.[ExternalId], SRC.[DisplayUrl], SRC.[QuantityUnitOfMeasure], SRC.[IsDeleted], SRC.[IsArchived], SRC.[LastViewedDate], SRC.[LastReferencedDate], SRC.[StockKeepingUnit], SRC.[External_Id__c], SRC.[Product_Id__c], SRC.[SLA_hours__c]
	--	, MarkerValue			= CAST([rep].[GetColumnListPerDatasetBK] (src.BKSource,-1,'all'	,'SRC.'	,''	,''	,''	, ',',0) as varchar(max))
		, markervalue			= STRING_AGG(
										CHAR(9)+ 
										'src.'+
										CONVERT(VARCHAR(MAX),
											QUOTENAME(a.attributename)
											+char(10)
										)
									,', ' ) WITHIN GROUP (ORDER BY  CAST(a.ordinalposition AS int))	
		, markerdescription		= ''
	FROM base src
	JOIN bld.vw_attribute a ON src.bksource = a.bk_dataset
	WHERE 1=1
	GROUP BY 
		src.bk_dataset		
		, src.code

	UNION ALL

	SELECT
		  src.bk_dataset		
		, src.code
		, marker				= '<!<SRC_ColumnList>>'
		-- Example value:
		--  [Id], [Name], [ProductCode], [Description], [QuantityScheduleType], [QuantityInstallmentPeriod], [NumberOfQuantityInstallments], [RevenueScheduleType], [RevenueInstallmentPeriod], [NumberOfRevenueInstallments], [CanUseQuantitySchedule], [CanUseRevenueSchedule], [IsActive], [CreatedDate], [CreatedById], [LastModifiedDate], [LastModifiedById], [SystemModstamp], [Family], [ExternalDataSourceId], [ExternalId], [DisplayUrl], [QuantityUnitOfMeasure], [IsDeleted], [IsArchived], [LastViewedDate], [LastReferencedDate], [StockKeepingUnit], [External_Id__c], [Product_Id__c], [SLA_hours__c]
		, markervalue			= STRING_AGG(
										CHAR(9)+ 
										CONVERT(VARCHAR(MAX),
											QUOTENAME(a.attributename)
											+char(10)
										)
									,', ' ) WITHIN GROUP (ORDER BY  CAST(a.ordinalposition AS int))	
		, markerdescription		= ''
	FROM base src
	JOIN bld.vw_attribute a ON src.bksource = a.bk_dataset
	WHERE 1=1
	GROUP BY 
		src.bk_dataset		
		, src.code
	
	
	

UNION ALL

	SELECT
		  src.bk_dataset		
		, src.code
		, marker				= '<!<SRC_BK_SRC>>'
		-- Example value:
		-- UPPER(CONCAT( ISNULL(CONVERT(NVARCHAR(4000),SRC.[Id]), N''),N''))
		, markervalue			= 'UPPER(CONCAT('+
									STRING_AGG(
										'ISNULL(CONVERT(NVARCHAR(4000),SRC.'+
										CONVERT(VARCHAR(MAX),
											QUOTENAME(a.attributename)
										) 
										+'), N'''')'
										
									,'+''|''+' ) WITHIN GROUP (ORDER BY  CAST(a.businesskey AS int))	
									+ ',N''''))'
		, markerdescription		= ''
	FROM base src
	JOIN bld.vw_dataset d ON src.code = d.code 
	JOIN bld.vw_attribute a ON src.bksource = a.bk_dataset

	WHERE 1=1
	 AND CAST(a.businesskey AS int) > 0
	 AND(
			( d.[FirstDefaultDWHView] = 1 )--and d.LayerName = 'dwh') 
			OR 
			(LEFT(d.prefix,2) ='tr')-- and d.LayerName = 'pub')
			)
	GROUP BY 
		src.bk_dataset		
		, src.code


	UNION ALL

	SELECT
		  src.bk_dataset		
		, src.code
		, marker				= '<!<SRC_Dummies_Unknown>>'

		-- Example value:
		-- '<Unknown>' AS [ProductId],'<Unknown>' AS [ProductCode],'<Unknown>' AS [ProductName],'<Unknown>' AS [ProductGroup],'<Unknown>' AS [ProductDescription],'<Unknown>' AS [ProductExternalId],-2 AS [ProductSLAinHours],'0' AS [SalesForce_IsActive],'0' AS [SalesForce_IsArchived],'0' AS [SalesForce_IsDeleted],'1900-01-01' AS [SalesForce_CreatedDate],'<Unknown>' AS [SalesForce_CreatedBy],'1900-01-01' AS [SalesForce_ModifiedDate],'<Unknown>' AS [SalesForce_ModifiedBy]
		, markervalue			= 
									STRING_AGG(
										CONVERT(VARCHAR(MAX),
											[rep].[GetDummyValueByAttributeBK](a.bk,'-2', '<Unknown>','9999-12-31') +' AS '+ QUOTENAME(a.attributename)
										) 
									
									,',' ) WITHIN GROUP (ORDER BY  CAST(a.ordinalposition AS int))	
									
		, markerdescription		= ''
	FROM base src
	JOIN bld.vw_attribute a ON src.bktarget = a.bk_dataset
	WHERE 1=1
	AND src.createdummies  =1
	AND CAST(isnull(a.ismta,0) AS int) = 0
	 --and src.[SchemaName] = 'dim'
	 --and src.BK_RefType_ObjectType = 'OT|T|Table'
	 GROUP BY 
		src.bk_dataset		
		, src.code


	UNION ALL

	SELECT
		 src.bk_dataset
		, src.code
		, marker				= '<!<SRC_Dummies_Empty>>'

		-- Example value:
		-- '<Empty>' AS [ProductId],'<Empty>' AS [ProductCode],'<Empty>' AS [ProductName],'<Empty>' AS [ProductGroup],'<Empty>' AS [ProductDescription],'<Empty>' AS [ProductExternalId],-1 AS [ProductSLAinHours],'0' AS [SalesForce_IsActive],'0' AS [SalesForce_IsArchived],'0' AS [SalesForce_IsDeleted],'1900-01-01' AS [SalesForce_CreatedDate],'<Empty>' AS [SalesForce_CreatedBy],'1900-01-01' AS [SalesForce_ModifiedDate],'<Empty>' AS [SalesForce_ModifiedBy]
		, markervalue			= 
									STRING_AGG(
										CONVERT(VARCHAR(MAX),
											[rep].[GetDummyValueByAttributeBK](a.bk,'-1', '<Empty>','1900-01-01') +' AS '+ QUOTENAME(a.attributename)
										) 
									
									,',' ) WITHIN GROUP (ORDER BY  CAST(a.ordinalposition AS int))	
		, markerdescription		= ''
	FROM base src
	JOIN bld.vw_attribute a ON src.bktarget = a.bk_dataset
	WHERE 1=1
	AND src.createdummies  =1
	AND CAST(isnull(a.ismta,0) AS int) = 0
	--and src.BK_RefType_ObjectType = 'OT|T|Table'
	GROUP BY 
		src.bk_dataset		
		, src.code

	)
SELECT
	bk					= Concat(mb.bk_dataset,'|',mb.marker,'|','Dynamic')
	, bk_dataset		= mb.bk_dataset
	, code				= mb.code
	, markertype		= 'Dynamic'
	, markerdescription
	, mb.marker
	, mb.markervalue
	--, len_value = len(MB.MarkerValue)
	, [Pre]				= 0
	, [Post]			= 0
	, mta_rectype		= diff.rectype

FROM markerbuild mb
LEFT JOIN [bld].[vw_MarkersSmartLoad] diff ON mb.code = diff.code 
WHERE 1=1