﻿
        CREATE   VIEW [bld].[vw_Dataset] AS
        /*
        View is generated by  : metro
        Generated at          : 2025-01-21 08:32:48
        Description           : View on stage table
        */
        WITH Cur AS (
            SELECT 
                [DatasetId] AS [DatasetId],
                [BK] AS [BK],
                [Code] AS [Code],
                [DatasetName] AS [DatasetName],
                [SchemaName] AS [SchemaName],
                [DataSource] AS [DataSource],
                [BK_Schema] AS [BK_Schema],
                [BK_Group] AS [BK_Group],
                [BK_Segment] AS [BK_Segment],
                [BK_Bucket] AS [BK_Bucket],
                [ShortName] AS [ShortName],
                [SRC_ShortName] AS [SRC_ShortName],
                [dwhTargetShortName] AS [dwhTargetShortName],
                [ReplaceAttributeNames] AS [ReplaceAttributeNames],
                [Prefix] AS [Prefix],
                [PostFix] AS [PostFix],
                [Description] AS [Description],
                [BK_ContactGroup] AS [BK_ContactGroup],
                [bk_ContactGroup_Data_Logistics] AS [bk_ContactGroup_Data_Logistics],
                [Data_Logistics_Info] AS [Data_Logistics_Info],
                [bk_ContactGroup_Data_Supplier] AS [bk_ContactGroup_Data_Supplier],
                [Data_Supplier_Info] AS [Data_Supplier_Info],
                [BK_Flow] AS [BK_Flow],
                [TimeStamp] AS [TimeStamp],
                [BusinessDate] AS [BusinessDate],
                [RecordSrcDate] AS [RecordSrcDate],
                [WhereFilter] AS [WhereFilter],
                [SCD] AS [SCD],
                [DistinctValues] AS [DistinctValues],
                [PartitionStatement] AS [PartitionStatement],
                [BK_RefType_ObjectType] AS [BK_RefType_ObjectType],
                [FullLoad] AS [FullLoad],
                [InsertOnly] AS [InsertOnly],
                [InsertNoCheck] AS [InsertNoCheck],
                [BigData] AS [BigData],
                [BK_Template_Load] AS [BK_Template_Load],
                [BK_Template_Create] AS [BK_Template_Create],
                [CustomStagingView] AS [CustomStagingView],
                [BK_RefType_RepositoryStatus] AS [BK_RefType_RepositoryStatus],
                [IsSystem] AS [IsSystem],
                [LayerName] AS [LayerName],
                [BK_LinkedService] AS [BK_LinkedService],
                [LinkedServiceName] AS [LinkedServiceName],
                [BK_DataSource] AS [BK_DataSource],
                [BK_Layer] AS [BK_Layer],
                [CreateDummies] AS [CreateDummies],
                [FlowOrder] AS [FlowOrder],
                [FlowOrderDesc] AS [FlowOrderDesc],
                [FirstDefaultDWHView] AS [FirstDefaultDWHView],
                [DatasetType] AS [DatasetType],
                [ObjectType] AS [ObjectType],
                [SRC_ObjectType] AS [SRC_ObjectType],
                [TGT_ObjectType] AS [TGT_ObjectType],
                [RepositoryStatusName] AS [RepositoryStatusName],
                [RepositoryStatusCode] AS [RepositoryStatusCode],
                [isDWH] AS [isDWH],
                [isSRC] AS [isSRC],
                [isTGT] AS [isTGT],
                [isRep] AS [isRep],
                [view_defintion_contains_business_logic] AS [view_defintion_contains_business_logic],
                [view_defintion] AS [view_defintion],
                [ToDeploy] AS [ToDeploy],
                [mta_RecType], [mta_CreateDate], [mta_Source], [mta_BK], [mta_BKH], [mta_RH],
                [mta_CurrentFlag] = ROW_NUMBER() OVER (PARTITION BY [mta_BKH] ORDER BY [mta_CreateDate] DESC)
            FROM [bld].[Dataset]
               
        )
        SELECT 
            [DatasetId] AS [DatasetId],
            [BK] AS [BK],
            [Code] AS [Code],
            [DatasetName] AS [DatasetName],
            [SchemaName] AS [SchemaName],
            [DataSource] AS [DataSource],
            [BK_Schema] AS [BK_Schema],
            [BK_Group] AS [BK_Group],
            [BK_Segment] AS [BK_Segment],
            [BK_Bucket] AS [BK_Bucket],
            [ShortName] AS [ShortName],
            [SRC_ShortName] AS [SRC_ShortName],
            [dwhTargetShortName] AS [dwhTargetShortName],
            [ReplaceAttributeNames] AS [ReplaceAttributeNames],
            [Prefix] AS [Prefix],
            [PostFix] AS [PostFix],
            [Description] AS [Description],
            [BK_ContactGroup] AS [BK_ContactGroup],
            [bk_ContactGroup_Data_Logistics] AS [bk_ContactGroup_Data_Logistics],
            [Data_Logistics_Info] AS [Data_Logistics_Info],
            [bk_ContactGroup_Data_Supplier] AS [bk_ContactGroup_Data_Supplier],
            [Data_Supplier_Info] AS [Data_Supplier_Info],
            [BK_Flow] AS [BK_Flow],
            [TimeStamp] AS [TimeStamp],
            [BusinessDate] AS [BusinessDate],
            [RecordSrcDate] AS [RecordSrcDate],
            [WhereFilter] AS [WhereFilter],
            [SCD] AS [SCD],
            [DistinctValues] AS [DistinctValues],
            [PartitionStatement] AS [PartitionStatement],
            [BK_RefType_ObjectType] AS [BK_RefType_ObjectType],
            [FullLoad] AS [FullLoad],
            [InsertOnly] AS [InsertOnly],
            [InsertNoCheck] AS [InsertNoCheck],
            [BigData] AS [BigData],
            [BK_Template_Load] AS [BK_Template_Load],
            [BK_Template_Create] AS [BK_Template_Create],
            [CustomStagingView] AS [CustomStagingView],
            [BK_RefType_RepositoryStatus] AS [BK_RefType_RepositoryStatus],
            [IsSystem] AS [IsSystem],
            [LayerName] AS [LayerName],
            [BK_LinkedService] AS [BK_LinkedService],
            [LinkedServiceName] AS [LinkedServiceName],
            [BK_DataSource] AS [BK_DataSource],
            [BK_Layer] AS [BK_Layer],
            [CreateDummies] AS [CreateDummies],
            [FlowOrder] AS [FlowOrder],
            [FlowOrderDesc] AS [FlowOrderDesc],
            [FirstDefaultDWHView] AS [FirstDefaultDWHView],
            [DatasetType] AS [DatasetType],
            [ObjectType] AS [ObjectType],
            [SRC_ObjectType] AS [SRC_ObjectType],
            [TGT_ObjectType] AS [TGT_ObjectType],
            [RepositoryStatusName] AS [RepositoryStatusName],
            [RepositoryStatusCode] AS [RepositoryStatusCode],
            [isDWH] AS [isDWH],
            [isSRC] AS [isSRC],
            [isTGT] AS [isTGT],
            [isRep] AS [isRep],
            [view_defintion_contains_business_logic] AS [view_defintion_contains_business_logic],
            [view_defintion] AS [view_defintion],
            [ToDeploy] AS [ToDeploy],
            [mta_RecType], [mta_CreateDate], [mta_Source], [mta_BK], [mta_BKH], [mta_RH],
            [mta_IsDeleted] = IIF([mta_RecType] = -1, 1, 0)
        FROM Cur
        WHERE [mta_CurrentFlag] = 1 AND [mta_RecType] > -1