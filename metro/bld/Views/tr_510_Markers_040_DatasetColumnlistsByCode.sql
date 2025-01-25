﻿









CREATE VIEW [bld].[tr_510_Markers_040_DatasetColumnlistsByCode] AS 
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
	<!<ColumnList_SCDdate>>
	<!<SRC_BKSCD_SRC>>
	<!<SRC_BKSCDH_SRC>>


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



WITH base AS (

	SELECT  
		  BK_Dataset			= src.BK
		, Code					= src.code
		, BK_RefType_ObjectType	= src.BK_RefType_ObjectType
		, BK_Schema				= src.BK_Schema
		, SchemaName			= src.SchemaName
		, mta_RecType			= diff.RecType
	FROM bld.vw_dataset src
	JOIN bld.vw_MarkersSmartLoad Diff ON src.Code = Diff.Code 
	WHERE 1=1
	AND src.bk= src.code
	AND CAST(diff.RecType AS int) > -99

)
, MarkerBuild AS (

	SELECT
		src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_ColumnList_SRC_bk_data_TryCast>>'
		, markervalue			=  (
									SELECT TRIM(
										',' + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(9) + CHAR(9)
										FROM STRING_AGG(
											'try_cast(src.'
											+ CONVERT(VARCHAR(MAX), ISNULL(CAST(A.Expression AS VARCHAR(MAX)), QUOTENAME(A.AttributeName)))
											+ ' '
											+ A.[DDL_Type3]
											+ ') AS '
											+ QUOTENAME(CAST(A.AttributeName AS VARCHAR(MAX))),
											',' + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(9) + CHAR(9)
										) WITHIN GROUP (ORDER BY CAST(A.OrdinalPosition AS INT))
									)
								)
		, MarkerDescription		= ''
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BK_Dataset = a.bk_dataset
	WHERE 1=1
		AND CAST(isnull(a.Ismta,0) AS int) = 0
	GROUP BY 
		src.BK_Dataset		
		, src.Code


UNION ALL

	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<TGT_ColumnList_TryCast>>'
		, MarkerValue			= STRING_AGG(
										char(9) + char(9) + 
										'try_cast(' +
										CONVERT(varchar(MAX),
										isnull(CAST(A.Expression AS varchar(MAX)), quotename(A.AttributeName))
										+ ' '
										+ a.[DDL_Type3]
										+ ') as '
										+ quotename(CAST(A.AttributeName AS varchar(MAX)))
										+char(10)
									),', ') WITHIN GROUP (ORDER BY CAST(a.ordinalposition AS int))
		, MarkerDescription		= ''
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BK_Dataset = a.bk_dataset
	WHERE 1=1
		AND isnull(a.IsMta,0) = 0
	GROUP BY 
		src.BK_Dataset		
		, src.Code

UNION ALL

	SELECT
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
												CONVERT(varchar(MAX), ISNULL(CAST(A.Expression AS varchar(MAX)), QUOTENAME(A.AttributeName)) + ' ' + a.[DDL_Type3]) +
												CASE 
													WHEN a.isnullable = 0 THEN '),''' + a.DefaultValue + ''') AS ' 
													ELSE ') AS ' 
												END +
												QUOTENAME(CAST(A.AttributeName AS varchar(MAX))),
												',' + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(9) + CHAR(9)
											) 
											WITHIN GROUP (ORDER BY CAST(a.ordinalposition AS int))
										)
								)
		, MarkerDescription		= ''
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BK_Dataset = a.bk_dataset
	WHERE 1=1
		AND isnull(a.IsMta,0) = 0
	GROUP BY 
		src.BK_Dataset		
		, src.Code


	UNION ALL

	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<businesskey_attributes>>'
		, markervalue			= (
									SELECT TRIM(
											',' + CHAR(13) + CHAR(10)
											FROM STRING_AGG(
												
												CONVERT(varchar(MAX), ISNULL(CAST(A.Expression AS varchar(MAX)), QUOTENAME(A.AttributeName)) ) 
												,
												',' + CHAR(13) + CHAR(10)
											) 
											WITHIN GROUP (ORDER BY CAST(a.ordinalposition AS int))
										)
								)
		, MarkerDescription		= ''
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BK_Dataset = a.bk_dataset
	WHERE 1=1
		AND iif(COALESCE(A.BusinessKey,0)='',0,A.BusinessKey) > 0
	GROUP BY 
		src.BK_Dataset		
		, src.Code
		
	UNION ALL
	
	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<dataset_attributes>>'
		, markervalue			= (
									SELECT TRIM(
											',' + CHAR(13) + CHAR(10)
											FROM STRING_AGG(
												
												CONVERT(varchar(MAX), ISNULL(CAST(A.Expression AS varchar(MAX)), QUOTENAME(A.AttributeName)) + ' ' + a.[DDL_Type3]) 
												,
												',' + CHAR(13) + CHAR(10) 
											) 
											WITHIN GROUP (ORDER BY CAST(a.ordinalposition AS int))
										)
								)
		, MarkerDescription		= ''
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BK_Dataset = a.bk_dataset
	WHERE 1=1
		AND isnull(a.IsMta,0) = 0
	GROUP BY 
		src.BK_Dataset		
		, src.Code

	UNION ALL
	--  <!<ColumnList_SCDdate>>

	SELECT
			  src.BK_Dataset		
			, src.Code
			, Marker				= '<!<ColumnList_SCDdate>>'
			, markervalue			= (
										SELECT TRIM(
												',' + CHAR(13) + CHAR(10)
												FROM STRING_AGG(
												
													CONVERT(varchar(MAX), ISNULL(CAST(A.Expression AS varchar(MAX)), QUOTENAME(A.AttributeName)) --+ ' ' + a.[DDL_Type3]
													) 
													,
													',' + CHAR(13) + CHAR(10) 
												) 
												WITHIN GROUP (ORDER BY CAST(a.ordinalposition AS int))
											)
									)
			, MarkerDescription		= ''
		FROM Base src
		JOIN bld.vw_Attribute a ON src.BK_Dataset = a.bk_dataset
		WHERE 1=1
			AND isnull(a.[SCDDate],0) > 0
		GROUP BY 
			src.BK_Dataset		
			, src.Code


UNION ALL	

	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<TGT_ColumnList_bk>>'
		
		-- Example value:
		--  [Id]
		, markervalue			= STRING_AGG(
										char(9)+
										CONVERT(varchar(MAX),
											quotename(A.AttributeName)
											+char(10)
										)
									,', ' ) WITHIN GROUP (ORDER BY  CAST(a.businesskey AS int))
		, MarkerDescription		= ''
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BK_Dataset = a.bk_dataset
	WHERE 1=1
		AND iif(COALESCE(A.BusinessKey,0)='',0,A.BusinessKey) > 0
	GROUP BY 
		src.BK_Dataset		
		, src.Code

	UNION ALL

	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_ColumnList_SRC_bk>>'
		
		-- Example value:
		--  SRC.[Id]
		, markervalue			= STRING_AGG(
										char(9)+
										'src.'+
										CONVERT(varchar(MAX),
											quotename(A.AttributeName)
										)+char(10)
									,', ') WITHIN GROUP (ORDER BY  CAST(a.businesskey AS int))
		, MarkerDescription		= ''
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BK_Dataset = a.bk_dataset
	WHERE 1=1
		AND iif(COALESCE(A.BusinessKey,0)='',0,A.BusinessKey) > 0
	GROUP BY 
		src.BK_Dataset		
		, src.Code

	UNION ALL 

	SELECT
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
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BK_Dataset = a.bk_dataset
	WHERE 1=1
		AND CAST(isnull(a.Ismta,0) AS int) = 0
	GROUP BY 
		src.BK_Dataset		
		, src.Code

	UNION ALL 

	SELECT
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
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BK_Dataset = a.bk_dataset
	WHERE 1=1
		AND CAST(isnull(a.Ismta,0) AS int) = 0
	GROUP BY 
		src.BK_Dataset		
		, src.Code

	UNION ALL
	
	

	SELECT
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
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BK_Dataset = a.bk_dataset
	WHERE 1=1
		AND CAST(A.BusinessKey AS int) = 0 AND CAST(isnull(a.IsMta,0) AS int) = 0
	GROUP BY 
		src.BK_Dataset		
		, src.Code


	UNION ALL

	SELECT
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
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BK_Dataset = a.bk_dataset
	WHERE 1=1
		AND CAST(A.BusinessKey AS int) = 0 AND CAST(isnull(a.IsMta,0) AS int) = 0
	GROUP BY 
		src.BK_Dataset		
		, src.Code

	
	UNION ALL

	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<TGT_BK>>'
		, MarkerValue			= 'upper(concat('''','+
									STRING_AGG( 
										CONVERT(varchar(MAX),
											quotename(A.AttributeName)
												)
									,',''|'',' ) WITHIN GROUP (ORDER BY  CAST(a.BusinessKey AS int))
									+ '))'
		, MarkerDescription		= ''
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BK_Dataset = a.bk_dataset
	WHERE 1=1
		AND CAST(isnull(a.BusinessKey,0) AS int) > 0
	GROUP BY 
		src.BK_Dataset		
		, src.Code

	UNION ALL

	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_BK_SRC>>'
		, MarkerValue			= 'upper(concat('''','+
									STRING_AGG( 
										CONVERT(varchar(MAX),
											+'src.'+quotename(A.AttributeName)
												)
									,',''|'',' ) WITHIN GROUP (ORDER BY  CAST(a.BusinessKey AS int))
									+ '))'
		, MarkerDescription		= ''
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BK_Dataset = a.bk_dataset
	WHERE 1=1
		AND CAST(isnull(a.BusinessKey,0) AS int) > 0
	GROUP BY 
		src.BK_Dataset		
		, src.Code

	UNION ALL

	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_BKSCD_SRC>>'
		, MarkerValue			= 'upper(concat('''','+
									STRING_AGG( 
										CONVERT(varchar(MAX),
											+'src.'+quotename(A.AttributeName)
												)
									,',''|'',' ) WITHIN GROUP (ORDER BY  CAST(isnull(a.BusinessKey,0) AS int)*1+ CAST(isnull(a.[SCDDate],0) AS int)*1000 ASC)
									+ '))'
		, MarkerDescription		= ''
	FROM Base src
	-- select * from
	JOIN bld.vw_Attribute a ON src.BK_Dataset = a.bk_dataset
	WHERE 1=1
		AND (CAST(isnull(a.BusinessKey,0) AS int) > 0 OR CAST(isnull(a.[SCDDate],0) AS int) > 0)
	GROUP BY 
		src.BK_Dataset		
		, src.Code


	UNION ALL

	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<TGT_BKH>>'
		, MarkerValue				= 'convert(char(128), hashbytes(''SHA2_512'', 
									upper(concat('''','+
									STRING_AGG(
										CONVERT(varchar(MAX),
											quotename(A.AttributeName)
												)
									,',''|'',' ) WITHIN GROUP (ORDER BY  CAST(a.BusinessKey AS int))
									+ '))'
									+'), 2)'
		, MarkerDescription		= ''
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BK_Dataset = a.bk_dataset
	WHERE 1=1
		AND CAST(isnull(a.BusinessKey,0) AS int) > 0
	GROUP BY 
		src.BK_Dataset		
		, src.Code

	
	UNION ALL

	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_BKH_SRC>>'
		, markervalue				= 'convert(char(128), hashbytes(''SHA2_512'', 
									upper(concat('''','+
									STRING_AGG(
										CONVERT(varchar(MAX),
											+'src.'+quotename(A.AttributeName)
												)
									,',''|'',' ) WITHIN GROUP (ORDER BY  CAST(a.BusinessKey AS int))
									+ '))'
									+'), 2)'
		, MarkerDescription		= ''
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BK_Dataset = a.bk_dataset
	WHERE 1=1
		AND CAST(isnull(a.BusinessKey,0) AS int) > 0
	GROUP BY 
		src.BK_Dataset		
		, src.Code

	-- <!<SRC_BKSCDH_SRC>>
	UNION ALL

	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_BKSCDH_SRC>>'
		, markervalue				= 'convert(char(128), hashbytes(''SHA2_512'', 
									upper(concat('''','+
									STRING_AGG(
										CONVERT(varchar(MAX),
											+'src.'+quotename(A.AttributeName)
												)
									,',''|'',' ) WITHIN GROUP (ORDER BY  CAST(isnull(a.BusinessKey,0) AS int)*1+ CAST(isnull(a.[SCDDate],0) AS int)*1000 ASC)
									+ '))'
									+'), 2)'
		, MarkerDescription		= ''
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BK_Dataset = a.bk_dataset
	WHERE 1=1
		AND (CAST(isnull(a.BusinessKey,0) AS int) > 0 OR CAST(isnull(a.[SCDDate],0) AS int) > 0)
	GROUP BY 
		src.BK_Dataset		
		, src.Code

	UNION ALL

	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<TGT_RH>>'
		, Markervalue			= isnull(CAST(
									'convert(char(128), hashbytes(''SHA2_512'', concat('''','+
										STRING_AGG(
											CONVERT(varchar(MAX),
												quotename(A.AttributeName)
											)
										,',''|'',' ) WITHIN GROUP (ORDER BY  CAST(a.ordinalposition AS int))
										+ ')), 2)'
									 AS varchar(MAX)),'NULL')
		, MarkerDescription		= ''
	FROM Base src
	LEFT JOIN
	    bld.vw_Attribute a
	ON src.BK_Dataset = a.bk_dataset AND CAST(isnull(A.BusinessKey,0) AS int) = 0 AND isnull(a.IsMta,0) = 0 AND CAST(isnull(a.NotInRH,0) AS int)=0
	WHERE 1=1
		
	GROUP BY 
		src.BK_Dataset		
		, src.Code

	UNION ALL

	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_RH_SRC>>'
		, Markervalue			= isnull(CAST(
									'convert(char(128), hashbytes(''SHA2_512'', concat('''','+
										STRING_AGG(
										
											
											CONVERT(varchar(MAX),
												'src.'+quotename(A.AttributeName)
												
											)
										,',''|'',' ) WITHIN GROUP (ORDER BY  CAST(a.ordinalposition AS int))
										+ ')), 2)'
									 AS varchar(MAX)),'NULL')
		, MarkerDescription		= ''
	FROM Base src
	LEFT JOIN
	    bld.vw_Attribute a
	ON src.BK_Dataset = a.bk_dataset AND CAST(A.BusinessKey AS int) = 0 AND isnull(a.IsMta,0) = 0 AND CAST(isnull(a.NotInRH,0) AS int)=0
	WHERE 1=1
		
	GROUP BY 
		src.BK_Dataset		
		, src.Code

	


	)
SELECT
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

FROM MarkerBuild MB
JOIN bld.vw_dataset TGT ON MB.Code = TGT.Code
LEFT JOIN [bld].[vw_MarkersSmartLoad] Diff ON MB.Code = Diff.Code 
WHERE 1=1
--and  Marker				= '<!<SRC_BKSCD_SRC>>'
--and marker = '<!<TGT_ColumnList_TryCast>>'
--and tgt.bk = 'DWH|dim|trvs|Wholesale|Customer_History|'
--order by MB.Marker asc