








CREATE view [bld].[tr_510_Markers_040_DatasetColumnlistsByCode] as 
/* 
=== Comments =========================================

Description:
	creates dataset markers, by code (the origin dataset), mostly BK, RH and Data columns
	builded markers:
	<!<TGT_RH>>
	<!<TGT_BK>>
	<!<TGT_BKH>>
	<!<TGT_ColumnList_bk_data>>
	<!<SRC_BKH_SRC>>
	<!<SRC_ColumnList_SRC_bk>>
	<!<TGT_ColumnList_bk>>
	<!<TGT_ColumnList_data>>
	<!<TGT_ColumnList_TryCast>>
	<!<SRC_RH_SRC>>
	<!<SRC_ColumnList_SRC_data>>
	<!<SRC_ColumnList_SRC_bk_data>>


get actual list:
select distinct marker, MarkerDescription from [bld].[tr_510_Markers_040_DatasetColumnlistsByCode]

DECLARE @Output NVARCHAR(MAX);

WITH RankedMarkers AS (
    SELECT 
        Marker, 
        markervalue,
        ROW_NUMBER() OVER (PARTITION BY Marker ORDER BY Marker) AS rn
    FROM  [bld].[tr_510_Markers_040_DatasetColumnlistsByCode]
	where marker  = '<!<SRC_ColumnList_SRC_bk_data>>'
)
SELECT @Output = STRING_AGG(
    'Marker: ' + CAST(Marker AS NVARCHAR(MAX)) + CHAR(13) + CHAR(10) + 
    'Description: ' + CHAR(10) + CAST(markervalue AS NVARCHAR(MAX)) + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10),
    CHAR(9) + '' + CHAR(10)
) WITHIN GROUP (ORDER BY Marker)
FROM (
    SELECT TOP 100 Marker, markervalue
    FROM RankedMarkers
    WHERE rn = 1
    ORDER BY Marker
) AS TopDistinctMarkers;

-- Print the result in chunks
DECLARE @PrintMsg NVARCHAR(MAX) = @Output;
WHILE LEN(@PrintMsg) > 0
BEGIN
    PRINT LEFT(@PrintMsg, 4000);
    SET @PrintMsg = SUBSTRING(@PrintMsg, 4001, LEN(@PrintMsg));
END


	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230226	1400		K. Vermeij				Add column [mta_rectype] to Activate SmartLoad
20230917	1740		K. Vermeij				instead of calling a function which worked with a "FOR XML PATH('')" the view uses 
												STRING_AGG( CONVERT(VARCHAR(max), QUOTENAME(A.AttributeName)) 
												with the convert max you can extend the 8000 characters :-D
												and it works really fast in comparison with "FOR XML PATH('')"
=======================================================
*/



with base as (

	Select  
		  BK_Dataset			= src.BK
		, Code					= src.code
		, BK_RefType_ObjectType	= src.BK_RefType_ObjectType
		, BK_Schema				= src.BK_Schema
		, SchemaName			= src.SchemaName
		, mta_RecType			= diff.RecType
	from bld.vw_dataset src
	join bld.vw_MarkersSmartLoad Diff on src.Code = Diff.Code 
	where 1=1
	and src.bk= src.code
	and cast(diff.RecType as int) > -99

)
, MarkerBuild as (

	Select
		src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_ColumnList_SRC_bk_data_TryCast>>'
		, markervalue			=  (
									SELECT TRIM(
										',' + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(9) + CHAR(9)
										FROM STRING_AGG(
											'try_cast(src.' + CONVERT(VARCHAR(MAX), ISNULL(CAST(A.Expression AS VARCHAR(MAX)), QUOTENAME(A.AttributeName))) + ' ' + A.[DDL_Type3] + ') AS ' + QUOTENAME(CAST(A.AttributeName AS VARCHAR(MAX))),
											',' + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(9) + CHAR(9)
										) WITHIN GROUP (ORDER BY CAST(A.OrdinalPosition AS INT))
									)
								)
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BK_Dataset = a.bk_dataset
	where 1=1
		and cast(isnull(a.Ismta,0) as int) = 0
	group by 
		src.BK_Dataset		
		, src.Code


union all

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<TGT_ColumnList_TryCast>>'
		, MarkerValue			= STRING_AGG(
										char(9) + char(9) + 
										'try_cast(' +
										convert(varchar(max),
										isnull(cast(A.Expression as varchar(max)), quotename(A.AttributeName)) + ' ' + a.[DDL_Type3] + ') as ' + quotename(cast(A.AttributeName as varchar(max)))
										+char(10)
									),', ') WITHIN GROUP (ORDER BY cast(a.ordinalposition as int))
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BK_Dataset = a.bk_dataset
	where 1=1
		and isnull(a.IsMta,0) = 0
	group by 
		src.BK_Dataset		
		, src.Code

union all

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_ColumnList_SRC_bk_data_CTAS>>'
		, markervalue			= (
									SELECT TRIM(
											',' + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(9) + CHAR(9)
											FROM STRING_AGG(
												CASE 
													WHEN a.isnullable = 0 THEN 'isnull(cast(src.' 
													ELSE 'try_cast(src.' 
												END +
												CONVERT(varchar(max), ISNULL(CAST(A.Expression AS varchar(max)), QUOTENAME(A.AttributeName)) + ' ' + a.[DDL_Type3]) +
												CASE 
													WHEN a.isnullable = 0 THEN '),''' + a.DefaultValue + ''') AS ' 
													ELSE ') AS ' 
												END +
												QUOTENAME(CAST(A.AttributeName AS varchar(max))),
												',' + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(9) + CHAR(9)
											) 
											WITHIN GROUP (ORDER BY CAST(a.ordinalposition AS int))
										)
								)
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BK_Dataset = a.bk_dataset
	where 1=1
		and isnull(a.IsMta,0) = 0
	group by 
		src.BK_Dataset		
		, src.Code


	union all

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<businesskey_attributes>>'
		, markervalue			= (
									SELECT TRIM(
											',' + CHAR(13) + CHAR(10)
											FROM STRING_AGG(
												
												CONVERT(varchar(max), ISNULL(CAST(A.Expression AS varchar(max)), QUOTENAME(A.AttributeName)) ) 
												,
												',' + CHAR(13) + CHAR(10)
											) 
											WITHIN GROUP (ORDER BY CAST(a.ordinalposition AS int))
										)
								)
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BK_Dataset = a.bk_dataset
	where 1=1
		and iif(coalesce(A.BusinessKey,0)='',0,A.BusinessKey) > 0
	group by 
		src.BK_Dataset		
		, src.Code
		
	union all

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<dataset_attributes>>'
		, markervalue			= (
									SELECT TRIM(
											',' + CHAR(13) + CHAR(10)
											FROM STRING_AGG(
												
												CONVERT(varchar(max), ISNULL(CAST(A.Expression AS varchar(max)), QUOTENAME(A.AttributeName)) + ' ' + a.[DDL_Type3]) 
												,
												',' + CHAR(13) + CHAR(10) 
											) 
											WITHIN GROUP (ORDER BY CAST(a.ordinalposition AS int))
										)
								)
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BK_Dataset = a.bk_dataset
	where 1=1
		and isnull(a.IsMta,0) = 0
	group by 
		src.BK_Dataset		
		, src.Code



union all	

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<TGT_ColumnList_bk>>'
		
		-- Example value:
		--  [Id]
		, markervalue			= string_agg(
										char(9)+
										convert(varchar(max),
											quotename(A.AttributeName)
											+char(10)
										)
									,', ' ) within group (order by  cast(a.businesskey as int))
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BK_Dataset = a.bk_dataset
	where 1=1
		and iif(coalesce(A.BusinessKey,0)='',0,A.BusinessKey) > 0
	group by 
		src.BK_Dataset		
		, src.Code

	union all

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_ColumnList_SRC_bk>>'
		
		-- Example value:
		--  SRC.[Id]
		, markervalue			= string_agg(
										char(9)+
										'src.'+
										convert(varchar(max),
											quotename(A.AttributeName)
										)+char(10)
									,', ') within group (order by  cast(a.businesskey as int))
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BK_Dataset = a.bk_dataset
	where 1=1
		and iif(coalesce(A.BusinessKey,0)='',0,A.BusinessKey) > 0
	group by 
		src.BK_Dataset		
		, src.Code

	union all 

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<TGT_ColumnList_bk_data>>'
		-- example value:
		--  [Id],  [Name],  [ProductCode],  [Description],  [QuantityScheduleType],  [QuantityInstallmentPeriod],  [NumberOfQuantityInstallments],  [RevenueScheduleType],  [RevenueInstallmentPeriod],  [NumberOfRevenueInstallments],  [CanUseQuantitySchedule],  [CanUseRevenueSchedule],  [IsActive],  [CreatedDate],  [CreatedbyId],  [LastModifiedDate],  [LastModifiedbyId],  [SystemModstamp],  [Family],  [ExternalDataSourceId],  [ExternalId],  [DisplayUrl],  [QuantityUnitOfMeasure],  [IsDeleted],  [IsArchived],  [LastViewedDate],  [LastReferencedDate],  [StockKeepingUnit],  [External_Id__c],  [Product_Id__c],  [SLA_hours__c]
			
		, markervalue			=  (
						SELECT TRIM(
							',' + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(9) + CHAR(9)
							FROM STRING_AGG(
								 CONVERT(VARCHAR(MAX), QUOTENAME(A.AttributeName)),
								',' + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(9) + CHAR(9)
							) WITHIN GROUP (ORDER BY CAST(A.OrdinalPosition AS INT))
						))
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BK_Dataset = a.bk_dataset
	where 1=1
		and cast(isnull(a.Ismta,0) as int) = 0
	group by 
		src.BK_Dataset		
		, src.Code

	union all 

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_ColumnList_SRC_bk_data>>'
		
		-- example values:
		--  SRC.[Id], SRC.[Name], SRC.[ProductCode], SRC.[Description], SRC.[QuantityScheduleType], SRC.[QuantityInstallmentPeriod], SRC.[NumberOfQuantityInstallments], SRC.[RevenueScheduleType], SRC.[RevenueInstallmentPeriod], SRC.[NumberOfRevenueInstallments], SRC.[CanUseQuantitySchedule], SRC.[CanUseRevenueSchedule], SRC.[IsActive], SRC.[CreatedDate], SRC.[CreatedbyId], SRC.[LastModifiedDate], SRC.[LastModifiedbyId], SRC.[SystemModstamp], SRC.[Family], SRC.[ExternalDataSourceId], SRC.[ExternalId], SRC.[DisplayUrl], SRC.[QuantityUnitOfMeasure], SRC.[IsDeleted], SRC.[IsArchived], SRC.[LastViewedDate], SRC.[LastReferencedDate], SRC.[StockKeepingUnit], SRC.[External_Id__c], SRC.[Product_Id__c], SRC.[SLA_hours__c]
		
		, markervalue = (
						SELECT TRIM(
							',' + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(9) + CHAR(9)
							FROM STRING_AGG(
								'src.' + CONVERT(VARCHAR(MAX), QUOTENAME(A.AttributeName)),
								',' + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(9) + CHAR(9)
							) WITHIN GROUP (ORDER BY CAST(A.OrdinalPosition AS INT))
						))
		--, markervalue			= STRING_AGG(
		--									'src.' + CONVERT(VARCHAR(MAX), QUOTENAME(A.AttributeName)),
		--									+ ',' + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(9) + CHAR(9) 
		--								) WITHIN GROUP (ORDER BY CAST(A.OrdinalPosition AS INT)) + CHAR(13) + CHAR(10)
							
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BK_Dataset = a.bk_dataset
	where 1=1
		and cast(isnull(a.Ismta,0) as int) = 0
	group by 
		src.BK_Dataset		
		, src.Code

	union all
	
	

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<TGT_ColumnList_data>>'
		
		-- Example value:
		--  [Name],  [ProductCode],  [Description],  [QuantityScheduleType],  [QuantityInstallmentPeriod],  [NumberOfQuantityInstallments],  [RevenueScheduleType],  [RevenueInstallmentPeriod],  [NumberOfRevenueInstallments],  [CanUseQuantitySchedule],  [CanUseRevenueSchedule],  [IsActive],  [CreatedDate],  [CreatedbyId],  [LastModifiedDate],  [LastModifiedbyId],  [SystemModstamp],  [Family],  [ExternalDataSourceId],  [ExternalId],  [DisplayUrl],  [QuantityUnitOfMeasure],  [IsDeleted],  [IsArchived],  [LastViewedDate],  [LastReferencedDate],  [StockKeepingUnit],  [External_Id__c],  [Product_Id__c],  [SLA_hours__c]
		, markervalue			= STRING_AGG(
											CONVERT(VARCHAR(MAX), QUOTENAME(A.AttributeName)),
											+ ',' + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(9) + CHAR(9) 
										) WITHIN GROUP (ORDER BY CAST(A.OrdinalPosition AS INT)) + CHAR(13) + CHAR(10)
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BK_Dataset = a.bk_dataset
	where 1=1
		and cast(A.BusinessKey as int) = 0 and cast(isnull(a.IsMta,0) as int) = 0
	group by 
		src.BK_Dataset		
		, src.Code


	union all

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_ColumnList_SRC_data>>'
		
		-- example value:
		--  src.[Name],  src.[ProductCode],  src.[Description],  src.[QuantityScheduleType],  src.[QuantityInstallmentPeriod],  src.[NumberOfQuantityInstallments],  src.[RevenueScheduleType],  src.[RevenueInstallmentPeriod],  src.[NumberOfRevenueInstallments],  src.[CanUseQuantitySchedule],  src.[CanUseRevenueSchedule],  src.[IsActive],  src.[CreatedDate],  src.[CreatedbyId],  src.[LastModifiedDate],  src.[LastModifiedbyId],  src.[SystemModstamp],  src.[Family],  src.[ExternalDataSourceId],  src.[ExternalId],  src.[DisplayUrl],  src.[QuantityUnitOfMeasure],  src.[IsDeleted],  src.[IsArchived],  src.[LastViewedDate],  src.[LastReferencedDate],  src.[StockKeepingUnit],  src.[External_Id__c],  src.[Product_Id__c],  src.[SLA_hours__c]
		, markervalue			= STRING_AGG(
											'src.' + CONVERT(VARCHAR(MAX), QUOTENAME(A.AttributeName)),
											+ ',' + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(9) + CHAR(9) 
										) WITHIN GROUP (ORDER BY CAST(A.OrdinalPosition AS INT)) + CHAR(13) + CHAR(10)
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BK_Dataset = a.bk_dataset
	where 1=1
		and cast(A.BusinessKey as int) = 0 and cast(isnull(a.IsMta,0) as int) = 0
	group by 
		src.BK_Dataset		
		, src.Code

	
	union all

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<TGT_BK>>'
		, MarkerValue			= 'upper(concat('''','+
									string_agg( 
										convert(varchar(max),
											quotename(A.AttributeName)
												)
									,',''|'',' ) within group (order by  cast(a.BusinessKey as int))
									+ '))'
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BK_Dataset = a.bk_dataset
	where 1=1
		and cast(isnull(a.BusinessKey,0) as int) > 0
	group by 
		src.BK_Dataset		
		, src.Code

	union all

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_BK_SRC>>'
		, MarkerValue			= 'upper(concat('''','+
									string_agg( 
										convert(varchar(max),
											+'src.'+quotename(A.AttributeName)
												)
									,',''|'',' ) within group (order by  cast(a.BusinessKey as int))
									+ '))'
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BK_Dataset = a.bk_dataset
	where 1=1
		and cast(isnull(a.BusinessKey,0) as int) > 0
	group by 
		src.BK_Dataset		
		, src.Code


	union all

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<TGT_BKH>>'
		, MarkerValue				= 'convert(char(128), hashbytes(''SHA2_512'', 
									upper(concat('''','+
									string_agg(
										convert(varchar(max),
											quotename(A.AttributeName)
												)
									,',''|'',' ) within group (order by  cast(a.BusinessKey as int))
									+ '))'
									+'), 2)'
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BK_Dataset = a.bk_dataset
	where 1=1
		and cast(isnull(a.BusinessKey,0) as int) > 0
	group by 
		src.BK_Dataset		
		, src.Code

	
	union all

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_BKH_SRC>>'
		, markervalue				= 'convert(char(128), hashbytes(''SHA2_512'', 
									upper(concat('''','+
									string_agg(
										convert(varchar(max),
											+'src.'+quotename(A.AttributeName)
												)
									,',''|'',' ) within group (order by  cast(a.BusinessKey as int))
									+ '))'
									+'), 2)'
		, MarkerDescription		= ''
	From Base src
	join bld.vw_Attribute a on src.BK_Dataset = a.bk_dataset
	where 1=1
		and cast(isnull(a.BusinessKey,0) as int) > 0
	group by 
		src.BK_Dataset		
		, src.Code

	union all

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<TGT_RH>>'
		, Markervalue			= isnull(cast(
									'convert(char(128), hashbytes(''SHA2_512'', concat('''','+
										string_agg(
											convert(varchar(max),
												quotename(A.AttributeName)
											)
										,',''|'',' ) within group (order by  cast(a.ordinalposition as int))
										+ ')), 2)'
									 as varchar(max)),'NULL')
		, MarkerDescription		= ''
	From Base src
	left join bld.vw_Attribute a on src.BK_Dataset = a.bk_dataset and cast(isnull(A.BusinessKey,0) as int) = 0 and isnull(a.IsMta,0) = 0 and cast(isnull(a.NotInRH,0) as int)=0
	where 1=1
		
	group by 
		src.BK_Dataset		
		, src.Code

	union all

	Select
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_RH_SRC>>'
		, Markervalue			= isnull(cast(
									'convert(char(128), hashbytes(''SHA2_512'', concat('''','+
										string_agg(
										
											
											convert(varchar(max),
												'src.'+quotename(A.AttributeName)
												
											)
										,',''|'',' ) within group (order by  cast(a.ordinalposition as int))
										+ ')), 2)'
									 as varchar(max)),'NULL')
		, MarkerDescription		= ''
	From Base src
	left join bld.vw_Attribute a on src.BK_Dataset = a.bk_dataset and cast(A.BusinessKey as int) = 0 and isnull(a.IsMta,0) = 0 and cast(isnull(a.NotInRH,0) as int)=0
	where 1=1
		
	group by 
		src.BK_Dataset		
		, src.Code

	


	)
select
	BK					= concat(tgt.BK,'|',MB.Marker,'|','Dynamic')
	, BK_Dataset		= TGT.BK
	, Code				= MB.Code
	, MarkerType		= 'Dynamic'
	, MarkerDescription
	, MB.Marker
	, MB.MarkerValue
	, [Pre]				= 0
	, [Post]			= 0
	, mta_RecType		= diff.RecType

From MarkerBuild MB
join bld.vw_dataset TGT on MB.Code = TGT.Code
left join [bld].[vw_MarkersSmartLoad] Diff on MB.Code = Diff.Code 
where 1=1
--and marker = '<!<TGT_ColumnList_TryCast>>'
--and tgt.bk = 'DWH|cds||ODF|Wholesale|'
--order by MB.Marker asc