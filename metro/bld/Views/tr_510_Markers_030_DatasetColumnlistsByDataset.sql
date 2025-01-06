







CREATE view [bld].[tr_510_Markers_030_DatasetColumnlistsByDataset] as 
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



with base as (

	Select  

		 BK							= tgt.BK
		, BKBase					= base.bk
		, dd.Code 
		, BKSource					= src.BK
		, BKTarget					= tgt.BK


		, BK_Dataset				= TGT.BK
	
		, BK_RefType_ObjectType		= TGT.BK_RefType_ObjectType
		, BK_Schema					= TGT.BK_Schema
		, SchemaName				= TGT.SchemaName
		, mta_RecType				= diff.RecType
		--, tgt.TGT_ObjectType
		, createdummies				= case when tgt.createdummies =1 and tgt.TGT_ObjectType = 'Table' then 1 else 0 end
	from   bld.vw_Dataset base
	join bld.vw_MarkersSmartLoad	Diff	on base.Code	= Diff.Code 
	join bld.vw_DatasetDependency	DD		on base.code	= dd.code
	join bld.vw_Dataset				src		on src.BK		= dd.BK_Parent
	join bld.vw_Dataset				tgt		on tgt.BK		= dd.BK_Child

	where 1=1
		and dd.DependencyType = 'SrcToTgt'
		and dd.mta_Source != '[bld].[tr_400_DatasetDependency_030_TransformationViewsDWH]'
		and dd.BK_Parent != 'src'
		and base.code=base.bk
		and cast(diff.RecType as int)>-99
	)


						




, MarkerBuild as (



	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<TGT_DDLcolumnlist>>'

		-- example value:
		--   [Id] [varchar](8000) NULL ,  [Id] [varchar](8000) NULL ,  [Id] [varchar](8000) NULL ,  [Id] [varchar](8000) NULL ,  [Id] [varchar](8000) NULL ,  [Id] [varchar](8000) NULL ,  [Name] [varchar](8000) NULL ,  [Name] [varchar](8000) NULL ,  [Name] [varchar](8000) NULL ,  [Name] [varchar](8000) NULL ,  [Name] [varchar](8000) NULL ,  [Name] [varchar](8000) NULL ,  [ProductCode] [varchar](8000) NULL ,  [ProductCode] [varchar](8000) NULL ,  [ProductCode] [varchar](8000) NULL ,  [ProductCode] [varchar](8000) NULL ,  [ProductCode] [varchar](8000) NULL ,  [ProductCode] [varchar](8000) NULL ,  [Description] [varchar](8000) NULL ,  [Description] [varchar](8000) NULL ,  [Description] [varchar](8000) NULL ,  [Description] [varchar](8000) NULL ,  [Description] [varchar](8000) NULL ,  [Description] [varchar](8000) NULL ,  [QuantityScheduleType] [varchar](8000) NULL ,  [QuantityScheduleType] [varchar](8000) NULL ,  [QuantityScheduleType] [varchar](8000) NULL ,  [QuantityScheduleType] [varchar](8000) NULL ,  [QuantityScheduleType] [varchar](8000) NULL ,  [QuantityScheduleType] [varchar](8000) NULL ,  [QuantityInstallmentPeriod] [varchar](8000) NULL ,  [QuantityInstallmentPeriod] [varchar](8000) NULL ,  [QuantityInstallmentPeriod] [varchar](8000) NULL ,  [QuantityInstallmentPeriod] [varchar](8000) NULL ,  [QuantityInstallmentPeriod] [varchar](8000) NULL ,  [QuantityInstallmentPeriod] [varchar](8000) NULL ,  [NumberOfQuantityInstallments] [varchar](8000) NULL ,  [NumberOfQuantityInstallments] [varchar](8000) NULL ,  [NumberOfQuantityInstallments] [varchar](8000) NULL ,  [NumberOfQuantityInstallments] [varchar](8000) NULL ,  [NumberOfQuantityInstallments] [varchar](8000) NULL ,  [NumberOfQuantityInstallments] [varchar](8000) NULL ,  [RevenueScheduleType] [varchar](8000) NULL ,  [RevenueScheduleType] [varchar](8000) NULL ,  [RevenueScheduleType] [varchar](8000) NULL ,  [RevenueScheduleType] [varchar](8000) NULL ,  [RevenueScheduleType] [varchar](8000) NULL ,  [RevenueScheduleType] [varchar](8000) NULL ,  [RevenueInstallmentPeriod] [varchar](8000) NULL ,  [RevenueInstallmentPeriod] [varchar](8000) NULL ,  [RevenueInstallmentPeriod] [varchar](8000) NULL ,  [RevenueInstallmentPeriod] [varchar](8000) NULL ,  [RevenueInstallmentPeriod] [varchar](8000) NULL ,  [RevenueInstallmentPeriod] [varchar](8000) NULL ,  [NumberOfRevenueInstallments] [varchar](8000) NULL ,  [NumberOfRevenueInstallments] [varchar](8000) NULL ,  [NumberOfRevenueInstallments] [varchar](8000) NULL ,  [NumberOfRevenueInstallments] [varchar](8000) NULL ,  [NumberOfRevenueInstallments] [varchar](8000) NULL ,  [NumberOfRevenueInstallments] [varchar](8000) NULL ,  [CanUseQuantitySchedule] [varchar](8000) NULL ,  [CanUseQuantitySchedule] [varchar](8000) NULL ,  [CanUseQuantitySchedule] [varchar](8000) NULL ,  [CanUseQuantitySchedule] [varchar](8000) NULL ,  [CanUseQuantitySchedule] [varchar](8000) NULL ,  [CanUseQuantitySchedule] [varchar](8000) NULL ,  [CanUseRevenueSchedule] [varchar](8000) NULL ,  [CanUseRevenueSchedule] [varchar](8000) NULL ,  [CanUseRevenueSchedule] [varchar](8000) NULL ,  [CanUseRevenueSchedule] [varchar](8000) NULL ,  [CanUseRevenueSchedule] [varchar](8000) NULL ,  [CanUseRevenueSchedule] [varchar](8000) NULL ,  [IsActive] [varchar](8000) NULL ,  [IsActive] [varchar](8000) NULL ,  [IsActive] [varchar](8000) NULL ,  [IsActive] [varchar](8000) NULL ,  [IsActive] [varchar](8000) NULL ,  [IsActive] [varchar](8000) NULL ,  [CreatedDate] [varchar](8000) NULL ,  [CreatedDate] [varchar](8000) NULL ,  [CreatedDate] [varchar](8000) NULL ,  [CreatedDate] [varchar](8000) NULL ,  [CreatedDate] [varchar](8000) NULL ,  [CreatedDate] [varchar](8000) NULL ,  [CreatedById] [varchar](8000) NULL ,  [CreatedById] [varchar](8000) NULL ,  [CreatedById] [varchar](8000) NULL ,  [CreatedById] [varchar](8000) NULL ,  [CreatedById] [varchar](8000) NULL ,  [CreatedById] [varchar](8000) NULL ,  [LastModifiedDate] [varchar](8000) NULL ,  [LastModifiedDate] [varchar](8000) NULL ,  [LastModifiedDate] [varchar](8000) NULL ,  [LastModifiedDate] [varchar](8000) NULL ,  [LastModifiedDate] [varchar](8000) NULL ,  [LastModifiedDate] [varchar](8000) NULL ,  [LastModifiedById] [varchar](8000) NULL ,  [LastModifiedById] [varchar](8000) NULL ,  [LastModifiedById] [varchar](8000) NULL ,  [LastModifiedById] [varchar](8000) NULL ,  [LastModifiedById] [varchar](8000) NULL ,  [LastModifiedById] [varchar](8000) NULL ,  [SystemModstamp] [varchar](8000) NULL ,  [SystemModstamp] [varchar](8000) NULL ,  [SystemModstamp] [varchar](8000) NULL ,  [SystemModstamp] [varchar](8000) NULL ,  [SystemModstamp] [varchar](8000) NULL ,  [SystemModstamp] [varchar](8000) NULL ,  [Family] [varchar](8000) NULL ,  [Family] [varchar](8000) NULL ,  [Family] [varchar](8000) NULL ,  [Family] [varchar](8000) NULL ,  [Family] [varchar](8000) NULL ,  [Family] [varchar](8000) NULL ,  [ExternalDataSourceId] [varchar](8000) NULL ,  [ExternalDataSourceId] [varchar](8000) NULL ,  [ExternalDataSourceId] [varchar](8000) NULL ,  [ExternalDataSourceId] [varchar](8000) NULL ,  [ExternalDataSourceId] [varchar](8000) NULL ,  [ExternalDataSourceId] [varchar](8000) NULL ,  [ExternalId] [varchar](8000) NULL ,  [ExternalId] [varchar](8000) NULL ,  [ExternalId] [varchar](8000) NULL ,  [ExternalId] [varchar](8000) NULL ,  [ExternalId] [varchar](8000) NULL ,  [ExternalId] [varchar](8000) NULL ,  [DisplayUrl] [varchar](8000) NULL ,  [DisplayUrl] [varchar](8000) NULL ,  [DisplayUrl] [varchar](8000) NULL ,  [DisplayUrl] [varchar](8000) NULL ,  [DisplayUrl] [varchar](8000) NULL ,  [DisplayUrl] [varchar](8000) NULL ,  [QuantityUnitOfMeasure] [varchar](8000) NULL ,  [QuantityUnitOfMeasure] [varchar](8000) NULL ,  [QuantityUnitOfMeasure] [varchar](8000) NULL ,  [QuantityUnitOfMeasure] [varchar](8000) NULL ,  [QuantityUnitOfMeasure] [varchar](8000) NULL ,  [QuantityUnitOfMeasure] [varchar](8000) NULL ,  [IsDeleted] [varchar](8000) NULL ,  [IsDeleted] [varchar](8000) NULL ,  [IsDeleted] [varchar](8000) NULL ,  [IsDeleted] [varchar](8000) NULL ,  [IsDeleted] [varchar](8000) NULL ,  [IsDeleted] [varchar](8000) NULL ,  [IsArchived] [varchar](8000) NULL ,  [IsArchived] [varchar](8000) NULL ,  [IsArchived] [varchar](8000) NULL ,  [IsArchived] [varchar](8000) NULL ,  [IsArchived] [varchar](8000) NULL ,  [IsArchived] [varchar](8000) NULL ,  [LastViewedDate] [varchar](8000) NULL ,  [LastViewedDate] [varchar](8000) NULL ,  [LastViewedDate] [varchar](8000) NULL ,  [LastViewedDate] [varchar](8000) NULL ,  [LastViewedDate] [varchar](8000) NULL ,  [LastViewedDate] [varchar](8000) NULL ,  [LastReferencedDate] [varchar](8000) NULL ,  [LastReferencedDate] [varchar](8000) NULL ,  [LastReferencedDate] [varchar](8000) NULL ,  [LastReferencedDate] [varchar](8000) NULL ,  [LastReferencedDate] [varchar](8000) NULL ,  [LastReferencedDate] [varchar](8000) NULL ,  [StockKeepingUnit] [varchar](8000) NULL ,  [StockKeepingUnit] [varchar](8000) NULL ,  [StockKeepingUnit] [varchar](8000) NULL ,  [StockKeepingUnit] [varchar](8000) NULL ,  [StockKeepingUnit] [varchar](8000) NULL ,  [StockKeepingUnit] [varchar](8000) NULL ,  [External_Id__c] [varchar](8000) NULL ,  [External_Id__c] [varchar](8000) NULL ,  [External_Id__c] [varchar](8000) NULL ,  [External_Id__c] [varchar](8000) NULL ,  [External_Id__c] [varchar](8000) NULL ,  [External_Id__c] [varchar](8000) NULL ,  [Product_Id__c] [varchar](8000) NULL ,  [Product_Id__c] [varchar](8000) NULL ,  [Product_Id__c] [varchar](8000) NULL ,  [Product_Id__c] [varchar](8000) NULL ,  [Product_Id__c] [varchar](8000) NULL ,  [Product_Id__c] [varchar](8000) NULL ,  [SLA_hours__c] [varchar](8000) NULL ,  [SLA_hours__c] [varchar](8000) NULL ,  [SLA_hours__c] [varchar](8000) NULL ,  [SLA_hours__c] [varchar](8000) NULL ,  [SLA_hours__c] [varchar](8000) NULL ,  [SLA_hours__c] [varchar](8000) NULL ,  [mta_LoadDate] [datetime2] NULL ,  [mta_LoadDate] [datetime2] NULL ,  [mta_LoadDate] [datetime2] NULL ,  [mta_LoadDate] [datetime2] NULL ,  [mta_LoadDate] [datetime2] NULL ,  [mta_LoadDate] [datetime2] NULL ,  [mta_Source] [varchar](255) NULL ,  [mta_Source] [varchar](255) NULL ,  [mta_Source] [varchar](255) NULL ,  [mta_Source] [varchar](255) NULL ,  [mta_Source] [varchar](255) NULL ,  [mta_Source] [varchar](255) NULL ,  [mta_DateInFileName] [varchar](20) NULL ,  [mta_DateInFileName] [varchar](20) NULL ,  [mta_DateInFileName] [varchar](20) NULL ,  [mta_DateInFileName] [varchar](20) NULL ,  [mta_DateInFileName] [varchar](20) NULL ,  [mta_DateInFileName] [varchar](20) NULL ,  [mta_PipelineRunID] [varchar](255) NULL ,  [mta_PipelineRunID] [varchar](255) NULL ,  [mta_PipelineRunID] [varchar](255) NULL ,  [mta_PipelineRunID] [varchar](255) NULL ,  [mta_PipelineRunID] [varchar](255) NULL ,  [mta_PipelineRunID] [varchar](255) NULL ,  [mta_PipelineTriggerID] [varchar](255) NULL ,  [mta_PipelineTriggerID] [varchar](255) NULL ,  [mta_PipelineTriggerID] [varchar](255) NULL ,  [mta_PipelineTriggerID] [varchar](255) NULL ,  [mta_PipelineTriggerID] [varchar](255) NULL ,  [mta_PipelineTriggerID] [varchar](255) NULL ,  [mta_Valid] [smallint] NULL ,  [mta_Valid] [smallint] NULL ,  [mta_Valid] [smallint] NULL ,  [mta_Valid] [smallint] NULL ,  [mta_Valid] [smallint] NULL ,  [mta_Valid] [smallint] NULL 
		, markervalue		= STRING_AGG(
									CONVERT(VARCHAR(max), QUOTENAME(A.AttributeName) + ' ' + a.[DDL_Type2] + char(10))  
									, CHAR(9) + ', '
								) WITHIN GROUP (ORDER BY cast(a.OrdinalPosition as int))

	
		
								--STRING_AGG(
								--		CHAR(9)+CONVERT(VARCHAR(max),
								--			QUOTENAME(A.AttributeName)+' ' +a.[DDL_Type2] 
								--			+char(10)
								--		)
								--	,', ' ) WITHIN GROUP (ORDER BY  cast(a.OrdinalPosition as int))						
								
	

		, MarkerDescription		=	
'Start marker at posistion with 1 tab
Output should look like this:
	[monitor_datasetSk] [int] NULL 
'+CHAR(9) +', [expected_datesk] [int] NULL 
'+CHAR(9) +', [delivered_datesk] [int] NULL'
	From Base src
	join bld.vw_Attribute a on src.BKtarget = a.bk_dataset
	where 1=1
		and src.BK_RefType_ObjectType  = 'OT|T|Table'
	group by 
		src.BK_Dataset		
		, src.Code


	union all


	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<TGT_ColumnList>>'
		-- example value:
		--  [Id], [Name], [ProductCode], [Description], [QuantityScheduleType], [QuantityInstallmentPeriod], [NumberOfQuantityInstallments], [RevenueScheduleType], [RevenueInstallmentPeriod], [NumberOfRevenueInstallments], [CanUseQuantitySchedule], [CanUseRevenueSchedule], [IsActive], [CreatedDate], [CreatedById], [LastModifiedDate], [LastModifiedById], [SystemModstamp], [Family], [ExternalDataSourceId], [ExternalId], [DisplayUrl], [QuantityUnitOfMeasure], [IsDeleted], [IsArchived], [LastViewedDate], [LastReferencedDate], [StockKeepingUnit], [External_Id__c], [Product_Id__c], [SLA_hours__c], [mta_LoadDate], [mta_Source], [mta_DateInFileName], [mta_PipelineRunID], [mta_PipelineTriggerID], [mta_Valid]
		, markervalue			= STRING_AGG(
										CHAR(9)+
										CONVERT(VARCHAR(max),
											QUOTENAME(A.AttributeName)
											+char(10)
										)
									,', ' ) WITHIN GROUP (ORDER BY  cast(a.OrdinalPosition as int))		
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BKTarget = a.bk_dataset
	where 1=1
	group by 
		src.BK_Dataset		
		, src.Code
	
	union all

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_ColumnList_SRC>>'
		-- Example Value:
		--  SRC.[Id], SRC.[Name], SRC.[ProductCode], SRC.[Description], SRC.[QuantityScheduleType], SRC.[QuantityInstallmentPeriod], SRC.[NumberOfQuantityInstallments], SRC.[RevenueScheduleType], SRC.[RevenueInstallmentPeriod], SRC.[NumberOfRevenueInstallments], SRC.[CanUseQuantitySchedule], SRC.[CanUseRevenueSchedule], SRC.[IsActive], SRC.[CreatedDate], SRC.[CreatedById], SRC.[LastModifiedDate], SRC.[LastModifiedById], SRC.[SystemModstamp], SRC.[Family], SRC.[ExternalDataSourceId], SRC.[ExternalId], SRC.[DisplayUrl], SRC.[QuantityUnitOfMeasure], SRC.[IsDeleted], SRC.[IsArchived], SRC.[LastViewedDate], SRC.[LastReferencedDate], SRC.[StockKeepingUnit], SRC.[External_Id__c], SRC.[Product_Id__c], SRC.[SLA_hours__c]
	--	, MarkerValue			= CAST([rep].[GetColumnListPerDatasetBK] (src.BKSource,-1,'all'	,'SRC.'	,''	,''	,''	, ',',0) as varchar(max))
		, markervalue			= STRING_AGG(
										CHAR(9)+ 
										'src.'+
										CONVERT(VARCHAR(max),
											QUOTENAME(A.AttributeName)
											+char(10)
										)
									,', ' ) WITHIN GROUP (ORDER BY  cast(a.OrdinalPosition as int))	
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BKSource = a.bk_dataset
	where 1=1
	group by 
		src.BK_Dataset		
		, src.Code

	union all

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_ColumnList>>'
		-- Example value:
		--  [Id], [Name], [ProductCode], [Description], [QuantityScheduleType], [QuantityInstallmentPeriod], [NumberOfQuantityInstallments], [RevenueScheduleType], [RevenueInstallmentPeriod], [NumberOfRevenueInstallments], [CanUseQuantitySchedule], [CanUseRevenueSchedule], [IsActive], [CreatedDate], [CreatedById], [LastModifiedDate], [LastModifiedById], [SystemModstamp], [Family], [ExternalDataSourceId], [ExternalId], [DisplayUrl], [QuantityUnitOfMeasure], [IsDeleted], [IsArchived], [LastViewedDate], [LastReferencedDate], [StockKeepingUnit], [External_Id__c], [Product_Id__c], [SLA_hours__c]
		, markervalue			= STRING_AGG(
										CHAR(9)+ 
										CONVERT(VARCHAR(max),
											QUOTENAME(A.AttributeName)
											+char(10)
										)
									,', ' ) WITHIN GROUP (ORDER BY  cast(a.OrdinalPosition as int))	
		, MarkerDescription		= ''
	from Base src
	join bld.vw_Attribute a on src.BKSource = a.bk_dataset
	where 1=1
	group by 
		src.BK_Dataset		
		, src.Code
	
	
	

union all

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_BK_SRC>>'
		-- Example value:
		-- UPPER(CONCAT( ISNULL(CONVERT(NVARCHAR(4000),SRC.[Id]), N''),N''))
		, markervalue			= 'UPPER(CONCAT('+
									STRING_AGG(
										'ISNULL(CONVERT(NVARCHAR(4000),SRC.'+
										CONVERT(VARCHAR(max),
											QUOTENAME(A.AttributeName)
										) 
										+'), N'''')'
										
									,'+''|''+' ) WITHIN GROUP (ORDER BY  cast(a.businesskey as int))	
									+ ',N''''))'
		, MarkerDescription		= ''
	From Base src
	join bld.vw_dataset d on src.Code = d.Code 
	join bld.vw_Attribute a on src.BKSource = a.bk_dataset

	where 1=1
	 and cast(A.BusinessKey as int) > 0
	 and(
			( d.[FirstDefaultDWHView] = 1 )--and d.LayerName = 'dwh') 
			or 
			(left(d.prefix,2) ='tr')-- and d.LayerName = 'pub')
			)
	group by 
		src.BK_Dataset		
		, src.Code


	union all

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_Dummies_Unknown>>'

		-- Example value:
		-- '<Unknown>' AS [ProductId],'<Unknown>' AS [ProductCode],'<Unknown>' AS [ProductName],'<Unknown>' AS [ProductGroup],'<Unknown>' AS [ProductDescription],'<Unknown>' AS [ProductExternalId],-2 AS [ProductSLAinHours],'0' AS [SalesForce_IsActive],'0' AS [SalesForce_IsArchived],'0' AS [SalesForce_IsDeleted],'1900-01-01' AS [SalesForce_CreatedDate],'<Unknown>' AS [SalesForce_CreatedBy],'1900-01-01' AS [SalesForce_ModifiedDate],'<Unknown>' AS [SalesForce_ModifiedBy]
		, markervalue			= 
									STRING_AGG(
										CONVERT(VARCHAR(max),
											[rep].[GetDummyValueByAttributeBK](a.BK,'-2', '<Unknown>','9999-12-31') +' AS '+ QUOTENAME(A.AttributeName)
										) 
									
									,',' ) WITHIN GROUP (ORDER BY  cast(a.OrdinalPosition as int))	
									
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BKTarget = a.bk_dataset
	where 1=1
	and src.createdummies  =1
	and cast(isnull(a.IsMta,0) as int) = 0
	 --and src.[SchemaName] = 'dim'
	 --and src.BK_RefType_ObjectType = 'OT|T|Table'
	 group by 
		src.BK_Dataset		
		, src.Code


	union all

	Select
		 src.BK_Dataset
		, src.Code
		, Marker				= '<!<SRC_Dummies_Empty>>'

		-- Example value:
		-- '<Empty>' AS [ProductId],'<Empty>' AS [ProductCode],'<Empty>' AS [ProductName],'<Empty>' AS [ProductGroup],'<Empty>' AS [ProductDescription],'<Empty>' AS [ProductExternalId],-1 AS [ProductSLAinHours],'0' AS [SalesForce_IsActive],'0' AS [SalesForce_IsArchived],'0' AS [SalesForce_IsDeleted],'1900-01-01' AS [SalesForce_CreatedDate],'<Empty>' AS [SalesForce_CreatedBy],'1900-01-01' AS [SalesForce_ModifiedDate],'<Empty>' AS [SalesForce_ModifiedBy]
		, markervalue			= 
									STRING_AGG(
										CONVERT(VARCHAR(max),
											[rep].[GetDummyValueByAttributeBK](a.BK,'-1', '<Empty>','1900-01-01') +' AS '+ QUOTENAME(A.AttributeName)
										) 
									
									,',' ) WITHIN GROUP (ORDER BY  cast(a.OrdinalPosition as int))	
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BKTarget = a.bk_dataset
	where 1=1
	and src.createdummies  =1
	and cast(isnull(a.IsMta,0) as int) = 0
	--and src.BK_RefType_ObjectType = 'OT|T|Table'
	group by 
		src.BK_Dataset		
		, src.Code

	)
select
	BK					= Concat(MB.BK_Dataset,'|',MB.Marker,'|','Dynamic')
	, BK_Dataset		= MB.BK_Dataset
	, Code				= MB.Code
	, MarkerType		= 'Dynamic'
	, MarkerDescription
	, MB.Marker
	, MB.MarkerValue
	--, len_value = len(MB.MarkerValue)
	, [Pre]				= 0
	, [Post]			= 0
	, mta_RecType		= diff.RecType

From MarkerBuild MB
left join [bld].[vw_MarkersSmartLoad] Diff on MB.Code = Diff.Code 
where 1=1