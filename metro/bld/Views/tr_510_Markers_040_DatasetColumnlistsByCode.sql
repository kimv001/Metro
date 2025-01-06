
CREATE VIEW [bld].[tr_510_markers_040_datasetcolumnlistsbycode] AS /*
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
*/ WITH base AS

        (SELECT bk_dataset = src.bk ,

               code = src.code ,

               bk_reftype_objecttype = src.bk_reftype_objecttype ,

               bk_schema = src.bk_schema ,

               schemaname = src.schemaname ,

               mta_rectype = diff.rectype

          FROM bld.vw_dataset src

          JOIN bld.vw_markerssmartload diff
            ON src.code = diff.code

         WHERE 1 = 1

           AND src.bk = src.code

           AND cast(diff.rectype AS int) > -99
       ),

       markerbuild AS

        (SELECT src.bk_dataset ,

               src.code ,

               marker = '<!<SRC_ColumnList_SRC_bk_data_TryCast>>' ,

               markervalue =

                (SELECT trim(',' + char(13) + char(10) + char(9) + char(9) + char(9)
                  FROM string_agg('try_cast(src.' + convert(varchar(MAX), isnull(cast(a.expression AS varchar(MAX)), quotename(a.attributename))) + ' ' + a.[ddl_type3] + ') AS ' + quotename(cast(a.attributename AS varchar(MAX))), ',' + char(13) + char(10) + char(9) + char(9) + char(9)) within GROUP (
                                                                                                                                                                                                                                                                                                             ORDER BY cast(a.ordinalposition AS INT)))
               ) ,

               markerdescription = ''

          FROM base src

          JOIN bld.vw_attribute a
            ON src.bk_dataset = a.bk_dataset

         WHERE 1 = 1

           AND cast(isnull(a.ismta, 0) AS int) = 0

         GROUP BY src.bk_dataset ,

                  src.code

     UNION ALL SELECT src.bk_dataset ,

               src.code ,

               marker = '<!<TGT_ColumnList_TryCast>>' ,

               markervalue = string_agg(char(9) + char(9) + 'try_cast(' + convert(varchar(MAX), isnull(cast(a.expression AS varchar(MAX)), quotename(a.attributename)) + ' ' + a.[ddl_type3] + ') as ' + quotename(cast(a.attributename AS varchar(MAX))) + char(10)), ', ') within GROUP (
                                                                                                                                                                                                                                                                                                ORDER BY cast(a.ordinalposition AS int)) , markerdescription = ''

          FROM base src

          JOIN bld.vw_attribute a
            ON src.bk_dataset = a.bk_dataset

         WHERE 1 = 1

           AND isnull(a.ismta, 0) = 0

         GROUP BY src.bk_dataset ,

                  src.code

     UNION ALL SELECT src.bk_dataset ,

               src.code ,

               marker = '<!<SRC_ColumnList_SRC_bk_data_CTAS>>' ,

               markervalue =

                (SELECT trim(',' + char(13) + char(10) + char(9) + char(9) + char(9)
                  FROM string_agg(CASE
                                      WHEN a.isnullable = 0 THEN 'isnull(cast(src.'
                                      ELSE 'try_cast(src.'
                                  END + convert(varchar(MAX), isnull(cast(a.expression AS varchar(MAX)), quotename(a.attributename)) + ' ' + a.[ddl_type3]) + CASE
                                                                                                                                                                  WHEN a.isnullable = 0 THEN '),''' + a.defaultvalue + ''') AS '
                                                                                                                                                                  ELSE ') AS '
                                                                                                                                                              END + quotename(cast(a.attributename AS varchar(MAX))), ',' + char(13) + char(10) + char(9) + char(9) + char(9)) within GROUP (
                                                                                                                                                                                                                                                                                             ORDER BY cast(a.ordinalposition AS int)))
               ) ,

               markerdescription = ''

          FROM base src

          JOIN bld.vw_attribute a
            ON src.bk_dataset = a.bk_dataset

         WHERE 1 = 1

           AND isnull(a.ismta, 0) = 0

         GROUP BY src.bk_dataset ,

                  src.code

     UNION ALL SELECT src.bk_dataset ,

               src.code ,

               marker = '<!<businesskey_attributes>>' ,

               markervalue =

                (SELECT trim(',' + char(13) + char(10)
                  FROM string_agg(convert(varchar(MAX), isnull(cast(a.expression AS varchar(MAX)), quotename(a.attributename))) , ',' + char(13) + char(10)) within GROUP (
                                                                                                                                                                           ORDER BY cast(a.ordinalposition AS int)))
               ) ,

               markerdescription = ''

          FROM base src

          JOIN bld.vw_attribute a
            ON src.bk_dataset = a.bk_dataset

         WHERE 1 = 1

           AND iif(coalesce(a.businesskey, 0) = '', 0, a.businesskey) > 0

         GROUP BY src.bk_dataset ,

                  src.code

     UNION ALL SELECT src.bk_dataset ,

               src.code ,

               marker = '<!<dataset_attributes>>' ,

               markervalue =

                (SELECT trim(',' + char(13) + char(10)
                  FROM string_agg(convert(varchar(MAX), isnull(cast(a.expression AS varchar(MAX)), quotename(a.attributename)) + ' ' + a.[ddl_type3]) , ',' + char(13) + char(10)) within GROUP (
                                                                                                                                                                                                 ORDER BY cast(a.ordinalposition AS int)))
               ) ,

               markerdescription = ''

          FROM base src

          JOIN bld.vw_attribute a
            ON src.bk_dataset = a.bk_dataset

         WHERE 1 = 1

           AND isnull(a.ismta, 0) = 0

         GROUP BY src.bk_dataset ,

                  src.code

     UNION ALL SELECT src.bk_dataset ,

               src.code ,

               marker = '<!<TGT_ColumnList_bk>>' -- Example value:
 --  [Id]
 ,

               markervalue = string_agg(char(9) + convert(varchar(MAX), quotename(a.attributename) + char(10)) , ', ') within GROUP (
                                                                                                                                          ORDER BY cast(a.businesskey AS int)) , markerdescription = ''

          FROM base src

          JOIN bld.vw_attribute a
            ON src.bk_dataset = a.bk_dataset

         WHERE 1 = 1

           AND iif(coalesce(a.businesskey, 0) = '', 0, a.businesskey) > 0

         GROUP BY src.bk_dataset ,

                  src.code

     UNION ALL SELECT src.bk_dataset ,

               src.code ,

               marker = '<!<SRC_ColumnList_SRC_bk>>' -- Example value:
 --  SRC.[Id]
 ,

               markervalue = string_agg(char(9) + 'src.' + convert(varchar(MAX), quotename(a.attributename)) + char(10) , ', ') within GROUP (
                                                                                                                                                   ORDER BY cast(a.businesskey AS int)) , markerdescription = ''

          FROM base src

          JOIN bld.vw_attribute a
            ON src.bk_dataset = a.bk_dataset

         WHERE 1 = 1

           AND iif(coalesce(a.businesskey, 0) = '', 0, a.businesskey) > 0

         GROUP BY src.bk_dataset ,

                  src.code

     UNION ALL SELECT src.bk_dataset ,

               src.code ,

               marker = '<!<TGT_ColumnList_bk_data>>' -- example value:
 --  [Id],  [Name],  [ProductCode],  [Description],  [QuantityScheduleType],  [QuantityInstallmentPeriod],  [NumberOfQuantityInstallments],  [RevenueScheduleType],  [RevenueInstallmentPeriod],  [NumberOfRevenueInstallments],  [CanUseQuantitySchedule],  [CanUseRevenueSchedule],  [IsActive],  [CreatedDate],  [CreatedbyId],  [LastModifiedDate],  [LastModifiedbyId],  [SystemModstamp],  [Family],  [ExternalDataSourceId],  [ExternalId],  [DisplayUrl],  [QuantityUnitOfMeasure],  [IsDeleted],  [IsArchived],  [LastViewedDate],  [LastReferencedDate],  [StockKeepingUnit],  [External_Id__c],  [Product_Id__c],  [SLA_hours__c]
 ,

               markervalue =

                (SELECT trim(',' + char(13) + char(10) + char(9) + char(9) + char(9)
                  FROM string_agg(convert(varchar(MAX), quotename(a.attributename)), ',' + char(13) + char(10) + char(9) + char(9) + char(9)) within GROUP (
                                                                                                                                                            ORDER BY cast(a.ordinalposition AS INT)))
               ) ,

               markerdescription = ''

          FROM base src

          JOIN bld.vw_attribute a
            ON src.bk_dataset = a.bk_dataset

         WHERE 1 = 1

           AND cast(isnull(a.ismta, 0) AS int) = 0

         GROUP BY src.bk_dataset ,

                  src.code

     UNION ALL SELECT src.bk_dataset ,

               src.code ,

               marker = '<!<SRC_ColumnList_SRC_bk_data>>' -- example values:
 --  SRC.[Id], SRC.[Name], SRC.[ProductCode], SRC.[Description], SRC.[QuantityScheduleType], SRC.[QuantityInstallmentPeriod], SRC.[NumberOfQuantityInstallments], SRC.[RevenueScheduleType], SRC.[RevenueInstallmentPeriod], SRC.[NumberOfRevenueInstallments], SRC.[CanUseQuantitySchedule], SRC.[CanUseRevenueSchedule], SRC.[IsActive], SRC.[CreatedDate], SRC.[CreatedbyId], SRC.[LastModifiedDate], SRC.[LastModifiedbyId], SRC.[SystemModstamp], SRC.[Family], SRC.[ExternalDataSourceId], SRC.[ExternalId], SRC.[DisplayUrl], SRC.[QuantityUnitOfMeasure], SRC.[IsDeleted], SRC.[IsArchived], SRC.[LastViewedDate], SRC.[LastReferencedDate], SRC.[StockKeepingUnit], SRC.[External_Id__c], SRC.[Product_Id__c], SRC.[SLA_hours__c]
 ,

               markervalue =

                (SELECT trim(',' + char(13) + char(10) + char(9) + char(9) + char(9)
                  FROM string_agg('src.' + convert(varchar(MAX), quotename(a.attributename)), ',' + char(13) + char(10) + char(9) + char(9) + char(9)) within GROUP (
                                                                                                                                                                     ORDER BY cast(a.ordinalposition AS INT)))
               ) --, markervalue			= STRING_AGG(
 --									'src.' + CONVERT(VARCHAR(MAX), QUOTENAME(A.AttributeName)),
 --									+ ',' + CHAR(13) + CHAR(10) + CHAR(9) + CHAR(9) + CHAR(9)
 --								) WITHIN GROUP (ORDER BY CAST(A.OrdinalPosition AS INT)) + CHAR(13) + CHAR(10)
 ,

               markerdescription = ''

          FROM base src

          JOIN bld.vw_attribute a
            ON src.bk_dataset = a.bk_dataset

         WHERE 1 = 1

           AND cast(isnull(a.ismta, 0) AS int) = 0

         GROUP BY src.bk_dataset ,

                  src.code

     UNION ALL SELECT src.bk_dataset ,

               src.code ,

               marker = '<!<TGT_ColumnList_data>>' -- Example value:
 --  [Name],  [ProductCode],  [Description],  [QuantityScheduleType],  [QuantityInstallmentPeriod],  [NumberOfQuantityInstallments],  [RevenueScheduleType],  [RevenueInstallmentPeriod],  [NumberOfRevenueInstallments],  [CanUseQuantitySchedule],  [CanUseRevenueSchedule],  [IsActive],  [CreatedDate],  [CreatedbyId],  [LastModifiedDate],  [LastModifiedbyId],  [SystemModstamp],  [Family],  [ExternalDataSourceId],  [ExternalId],  [DisplayUrl],  [QuantityUnitOfMeasure],  [IsDeleted],  [IsArchived],  [LastViewedDate],  [LastReferencedDate],  [StockKeepingUnit],  [External_Id__c],  [Product_Id__c],  [SLA_hours__c]
 ,

               markervalue = string_agg(convert(varchar(MAX), quotename(a.attributename)), + ',' + char(13) + char(10) + char(9) + char(9) + char(9)) within GROUP (
                                                                                                                                                                         ORDER BY cast(a.ordinalposition AS INT)) + char(13) + char(10) ,

               markerdescription = ''

          FROM base src

          JOIN bld.vw_attribute a
            ON src.bk_dataset = a.bk_dataset

         WHERE 1 = 1

           AND cast(a.businesskey AS int) = 0

           AND cast(isnull(a.ismta, 0) AS int) = 0

         GROUP BY src.bk_dataset ,

                  src.code

     UNION ALL SELECT src.bk_dataset ,

               src.code ,

               marker = '<!<SRC_ColumnList_SRC_data>>' -- example value:
 --  src.[Name],  src.[ProductCode],  src.[Description],  src.[QuantityScheduleType],  src.[QuantityInstallmentPeriod],  src.[NumberOfQuantityInstallments],  src.[RevenueScheduleType],  src.[RevenueInstallmentPeriod],  src.[NumberOfRevenueInstallments],  src.[CanUseQuantitySchedule],  src.[CanUseRevenueSchedule],  src.[IsActive],  src.[CreatedDate],  src.[CreatedbyId],  src.[LastModifiedDate],  src.[LastModifiedbyId],  src.[SystemModstamp],  src.[Family],  src.[ExternalDataSourceId],  src.[ExternalId],  src.[DisplayUrl],  src.[QuantityUnitOfMeasure],  src.[IsDeleted],  src.[IsArchived],  src.[LastViewedDate],  src.[LastReferencedDate],  src.[StockKeepingUnit],  src.[External_Id__c],  src.[Product_Id__c],  src.[SLA_hours__c]
 ,

               markervalue = string_agg('src.' + convert(varchar(MAX), quotename(a.attributename)), + ',' + char(13) + char(10) + char(9) + char(9) + char(9)) within GROUP (
                                                                                                                                                                                  ORDER BY cast(a.ordinalposition AS INT)) + char(13) + char(10) ,

               markerdescription = ''

          FROM base src

          JOIN bld.vw_attribute a
            ON src.bk_dataset = a.bk_dataset

         WHERE 1 = 1

           AND cast(a.businesskey AS int) = 0

           AND cast(isnull(a.ismta, 0) AS int) = 0

         GROUP BY src.bk_dataset ,

                  src.code

     UNION ALL SELECT src.bk_dataset ,

               src.code ,

               marker = '<!<TGT_BK>>' ,

               markervalue = 'upper(concat('''',' + string_agg(convert(varchar(MAX), quotename(a.attributename)) , ',''|'',') within GROUP (
                                                                                                                                                 ORDER BY cast(a.businesskey AS int)) + '))' ,

               markerdescription = ''

          FROM base src

          JOIN bld.vw_attribute a
            ON src.bk_dataset = a.bk_dataset

         WHERE 1 = 1

           AND cast(isnull(a.businesskey, 0) AS int) > 0

         GROUP BY src.bk_dataset ,

                  src.code

     UNION ALL SELECT src.bk_dataset ,

               src.code ,

               marker = '<!<SRC_BK_SRC>>' ,

               markervalue = 'upper(concat('''',' + string_agg(convert(varchar(MAX), + 'src.' + quotename(a.attributename)) , ',''|'',') within GROUP (
                                                                                                                                                            ORDER BY cast(a.businesskey AS int)) + '))' ,

               markerdescription = ''

          FROM base src

          JOIN bld.vw_attribute a
            ON src.bk_dataset = a.bk_dataset

         WHERE 1 = 1

           AND cast(isnull(a.businesskey, 0) AS int) > 0

         GROUP BY src.bk_dataset ,

                  src.code

     UNION ALL SELECT src.bk_dataset ,

               src.code ,

               marker = '<!<TGT_BKH>>' ,

               markervalue = 'convert(char(128), hashbytes(''SHA2_512'', 
									upper(concat('''',' + string_agg(convert(varchar(MAX), quotename(a.attributename)) , ',''|'',') within GROUP (
                                                                                                                       ORDER BY cast(a.businesskey AS int)) + '))' + '), 2)' ,

               markerdescription = ''

          FROM base src

          JOIN bld.vw_attribute a
            ON src.bk_dataset = a.bk_dataset

         WHERE 1 = 1

           AND cast(isnull(a.businesskey, 0) AS int) > 0

         GROUP BY src.bk_dataset ,

                  src.code

     UNION ALL SELECT src.bk_dataset ,

               src.code ,

               marker = '<!<SRC_BKH_SRC>>' ,

               markervalue = 'convert(char(128), hashbytes(''SHA2_512'', 
									upper(concat('''',' + string_agg(convert(varchar(MAX), + 'src.' + quotename(a.attributename)) , ',''|'',') within GROUP (
                                                                                                                                  ORDER BY cast(a.businesskey AS int)) + '))' + '), 2)' ,

               markerdescription = ''

          FROM base src

          JOIN bld.vw_attribute a
            ON src.bk_dataset = a.bk_dataset

         WHERE 1 = 1

           AND cast(isnull(a.businesskey, 0) AS int) > 0

         GROUP BY src.bk_dataset ,

                  src.code

     UNION ALL SELECT src.bk_dataset ,

               src.code ,

               marker = '<!<TGT_RH>>' ,

               markervalue = isnull(cast('convert(char(128), hashbytes(''SHA2_512'', concat('''',' + string_agg(convert(varchar(MAX), quotename(a.attributename)) , ',''|'',') within GROUP (
                                                                                                                                                                                                  ORDER BY cast(a.ordinalposition AS int)) + ')), 2)' AS varchar(MAX)), 'NULL') ,

               markerdescription = ''

          FROM base src

          LEFT JOIN bld.vw_attribute a
            ON src.bk_dataset = a.bk_dataset

           AND cast(isnull(a.businesskey, 0) AS int) = 0

           AND isnull(a.ismta, 0) = 0

           AND cast(isnull(a.notinrh, 0) AS int) = 0

         WHERE 1 = 1

         GROUP BY src.bk_dataset ,

                  src.code

     UNION ALL SELECT src.bk_dataset ,

               src.code ,

               marker = '<!<SRC_RH_SRC>>' ,

               markervalue = isnull(cast('convert(char(128), hashbytes(''SHA2_512'', concat('''',' + string_agg(convert(varchar(MAX), 'src.' + quotename(a.attributename)) , ',''|'',') within GROUP (
                                                                                                                                                                                                           ORDER BY cast(a.ordinalposition AS int)) + ')), 2)' AS varchar(MAX)), 'NULL') ,

               markerdescription = ''

          FROM base src

          LEFT JOIN bld.vw_attribute a
            ON src.bk_dataset = a.bk_dataset

           AND cast(a.businesskey AS int) = 0

           AND isnull(a.ismta, 0) = 0

           AND cast(isnull(a.notinrh, 0) AS int) = 0

         WHERE 1 = 1

         GROUP BY src.bk_dataset ,

                  src.code
       )
SELECT bk = concat(tgt.bk, '|', mb.marker, '|', 'Dynamic') ,

       bk_dataset = tgt.bk ,

       code = mb.code ,

       markertype = 'Dynamic' ,

       markerdescription ,

       mb.marker ,

       mb.markervalue ,

       [pre] = 0 ,

       [post] = 0 ,

       mta_rectype = diff.rectype

  FROM markerbuild mb

  JOIN bld.vw_dataset tgt
    ON mb.code = tgt.code

  LEFT JOIN [bld].[vw_markerssmartload] diff
    ON mb.code = diff.code

 WHERE 1 = 1 --and marker = '<!<TGT_ColumnList_TryCast>>'
--and tgt.bk = 'DWH|cds||ODF|Wholesale|'
--order by MB.Marker asc
