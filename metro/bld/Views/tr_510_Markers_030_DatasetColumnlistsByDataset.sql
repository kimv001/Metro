







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
		, createdummies				= CASE WHEN tgt.createdummies =1 AND tgt.TGT_ObjectType = 'Table' THEN 1 ELSE 0 END
	FROM   bld.vw_Dataset base
	JOIN bld.vw_MarkersSmartLoad	Diff	ON base.Code	= Diff.Code 
	JOIN bld.vw_DatasetDependency	DD		ON base.code	= dd.code
	JOIN bld.vw_Dataset				src		ON src.BK		= dd.BK_Parent
	JOIN bld.vw_Dataset				tgt		ON tgt.BK		= dd.BK_Child

	WHERE 1=1
		AND dd.DependencyType = 'SrcToTgt'
		AND dd.mta_Source != '[bld].[tr_400_DatasetDependency_030_TransformationViewsDWH]'
		AND dd.BK_Parent != 'src'
		AND base.code=base.bk
		AND CAST(diff.RecType AS int)>-99
	)


						




, MarkerBuild AS (



	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<TGT_DDLcolumnlist>>'

		-- example value:
		--   [Id] [varchar](8000) NULL ,  [Id] [varchar](8000) NULL ,  [Id] [varchar](8000) NULL 
		, markervalue		= STRING_AGG(
									CONVERT(VARCHAR(MAX), QUOTENAME(A.AttributeName) + ' ' + a.[DDL_Type2] + char(10))  
									, CHAR(9) + ', '
								) WITHIN GROUP (ORDER BY CAST(a.OrdinalPosition AS int))

		, MarkerDescription		=	
'Start marker at posistion with 1 tab
Output should look like this:
	[monitor_datasetSk] [int] NULL 
'+CHAR(9) +', [expected_datesk] [int] NULL 
'+CHAR(9) +', [delivered_datesk] [int] NULL'
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BKtarget = a.bk_dataset
	WHERE 1=1
		AND src.BK_RefType_ObjectType  = 'OT|T|Table'
	GROUP BY 
		src.BK_Dataset		
		, src.Code


	UNION ALL


	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<TGT_ColumnList>>'
		-- example value:
		--  [Id], [Name], [ProductCode], [Description]
		, markervalue			= STRING_AGG(
										CHAR(9)+
										CONVERT(VARCHAR(MAX),
											QUOTENAME(A.AttributeName)
											+char(10)
										)
									,', ' ) WITHIN GROUP (ORDER BY  CAST(a.OrdinalPosition AS int))		
		, MarkerDescription		= ''
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BKTarget = a.bk_dataset
	WHERE 1=1
	GROUP BY 
		src.BK_Dataset		
		, src.Code
	
	UNION ALL

	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_ColumnList_SRC>>'
		-- Example Value:
		--  SRC.[Id], SRC.[Name], SRC.[ProductCode], SRC.[Description], SRC.[QuantityScheduleType]
	
		, markervalue			= STRING_AGG(
										CHAR(9)+ 
										'src.'+
										CONVERT(VARCHAR(MAX),
											QUOTENAME(A.AttributeName)
											+char(10)
										)
									,', ' ) WITHIN GROUP (ORDER BY  CAST(a.OrdinalPosition AS int))	
		, MarkerDescription		= ''
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BKSource = a.bk_dataset
	WHERE 1=1
	GROUP BY 
		src.BK_Dataset		
		, src.Code

	UNION ALL

	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_ColumnList>>'
		-- Example value:
		--  [Id], [Name], [ProductCode], [Description], [QuantityScheduleType]
		, markervalue			= STRING_AGG(
										CHAR(9)+ 
										CONVERT(VARCHAR(MAX),
											QUOTENAME(A.AttributeName)
											+char(10)
										)
									,', ' ) WITHIN GROUP (ORDER BY  CAST(a.OrdinalPosition AS int))	
		, MarkerDescription		= ''
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BKSource = a.bk_dataset
	WHERE 1=1
	GROUP BY 
		src.BK_Dataset		
		, src.Code
	
	
	

UNION ALL

	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_BK_SRC>>'
		-- Example value:
		-- UPPER(CONCAT( ISNULL(CONVERT(NVARCHAR(4000),SRC.[Id]), N''),N''))
		, markervalue			= 'UPPER(CONCAT('+
									STRING_AGG(
										'ISNULL(CONVERT(NVARCHAR(4000),SRC.'+
										CONVERT(VARCHAR(MAX),
											QUOTENAME(A.AttributeName)
										) 
										+'), N'''')'
										
									,'+''|''+' ) WITHIN GROUP (ORDER BY  CAST(a.businesskey AS int))	
									+ ',N''''))'
		, MarkerDescription		= ''
	FROM Base src
	JOIN bld.vw_dataset d ON src.Code = d.Code 
	JOIN bld.vw_Attribute a ON src.BKSource = a.bk_dataset

	WHERE 1=1
	 AND CAST(A.BusinessKey AS int) > 0
	 AND(
			( d.[FirstDefaultDWHView] = 1 )--and d.LayerName = 'dwh') 
			OR 
			(LEFT(d.prefix,2) ='tr')-- and d.LayerName = 'pub')
			)
	GROUP BY 
		src.BK_Dataset		
		, src.Code


	UNION ALL

	SELECT
		  src.BK_Dataset		
		, src.Code
		, Marker				= '<!<SRC_Dummies_Unknown>>'

		-- Example value:
		-- '<Unknown>' AS [ProductId],'<Unknown>' AS [ProductCode],'<Unknown>' AS [ProductName],'<Unknown>' AS [ProductGroup]
		-- ,'<Unknown>' AS [ProductDescription],'<Unknown>' AS [ProductExternalId],-2 AS [ProductSLAinHours]
		, markervalue			= 
									STRING_AGG(
										CONVERT(VARCHAR(MAX),
											[rep].[GetDummyValueByAttributeBK](a.BK,'-2', '<Unknown>','9999-12-31') +' AS '+ QUOTENAME(A.AttributeName)
										) 
									
									,',' ) WITHIN GROUP (ORDER BY  CAST(a.OrdinalPosition AS int))	
									
		, MarkerDescription		= ''
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BKTarget = a.bk_dataset
	WHERE 1=1
	AND src.createdummies  =1
	AND CAST(isnull(a.IsMta,0) AS int) = 0
	GROUP BY 
		src.BK_Dataset		
		, src.Code


	UNION ALL

	SELECT
		 src.BK_Dataset
		, src.Code
		, Marker				= '<!<SRC_Dummies_Empty>>'

		-- Example value:
		-- '<Empty>' AS [ProductId],'<Empty>' AS [ProductCode],'<Empty>' AS [ProductName],'<Empty>' AS [ProductGroup]
		-- ,'<Empty>' AS [ProductDescription],'<Empty>' AS [ProductExternalId],-1 AS [ProductSLAinHours]
		, markervalue			= 
									STRING_AGG(
										CONVERT(VARCHAR(MAX),
											[rep].[GetDummyValueByAttributeBK](a.BK,'-1', '<Empty>','1900-01-01') +' AS '+ QUOTENAME(A.AttributeName)
										) 
									
									,',' ) WITHIN GROUP (ORDER BY  CAST(a.OrdinalPosition AS int))	
		, MarkerDescription		= ''
	FROM Base src
	JOIN bld.vw_Attribute a ON src.BKTarget = a.bk_dataset
	WHERE 1=1
	AND src.createdummies  =1
	AND CAST(isnull(a.IsMta,0) AS int) = 0
	--and src.BK_RefType_ObjectType = 'OT|T|Table'
	GROUP BY 
		src.BK_Dataset		
		, src.Code

	)
SELECT
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

FROM MarkerBuild MB
LEFT JOIN [bld].[vw_MarkersSmartLoad] Diff ON MB.Code = Diff.Code 
WHERE 1=1