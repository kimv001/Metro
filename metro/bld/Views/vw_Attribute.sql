﻿
        CREATE   VIEW [bld].[vw_Attribute] AS
        /*
        View is generated by  : metro
        Generated at          : 2024-12-24 08:25:25
        Description           : View on stage table
        */
        WITH Cur AS (
            SELECT 
                [AttributeId] AS [AttributeId],
                [BK] AS [BK],
                [Code] AS [Code],
                [Name] AS [Name],
                [BK_Dataset] AS [BK_Dataset],
                [Dataset] AS [Dataset],
                [AttributeName] AS [AttributeName],
                [Description] AS [Description],
                [Expression] AS [Expression],
                [DistributionHashKey] AS [DistributionHashKey],
                [NotInRH] AS [NotInRH],
                [BusinessKey] AS [BusinessKey],
                [isMta] AS [isMta],
                [SrcName] AS [SrcName],
                [BK_RefType_DataType] AS [BK_RefType_DataType],
                [DataType] AS [DataType],
                [FixedSchemaDataType] AS [FixedSchemaDataType],
                [OrgMappedDataType] AS [OrgMappedDataType],
                [Isnullable] AS [Isnullable],
                [OrdinalPosition] AS [OrdinalPosition],
                [MaximumLength] AS [MaximumLength],
                [Precision] AS [Precision],
                [Scale] AS [Scale],
                [Collation] AS [Collation],
                [Active] AS [Active],
                [FlowOrder] AS [FlowOrder],
                [BK_RefType_ObjectType] AS [BK_RefType_ObjectType],
                [BK_RefType_RepositoryStatus] AS [BK_RefType_RepositoryStatus],
                [DefaultValue] AS [DefaultValue],
                [DDL_Type1] AS [DDL_Type1],
                [DDL_Type2] AS [DDL_Type2],
                [DDL_Type3] AS [DDL_Type3],
                [DDL_Type4] AS [DDL_Type4],
                [mta_RecType], [mta_CreateDate], [mta_Source], [mta_BK], [mta_BKH], [mta_RH],
                [mta_CurrentFlag] = ROW_NUMBER() OVER (PARTITION BY [mta_BKH] ORDER BY [mta_CreateDate] DESC)
            FROM [bld].[Attribute]
               
        )
        SELECT 
            [AttributeId] AS [AttributeId],
            [BK] AS [BK],
            [Code] AS [Code],
            [Name] AS [Name],
            [BK_Dataset] AS [BK_Dataset],
            [Dataset] AS [Dataset],
            [AttributeName] AS [AttributeName],
            [Description] AS [Description],
            [Expression] AS [Expression],
            [DistributionHashKey] AS [DistributionHashKey],
            [NotInRH] AS [NotInRH],
            [BusinessKey] AS [BusinessKey],
            [isMta] AS [isMta],
            [SrcName] AS [SrcName],
            [BK_RefType_DataType] AS [BK_RefType_DataType],
            [DataType] AS [DataType],
            [FixedSchemaDataType] AS [FixedSchemaDataType],
            [OrgMappedDataType] AS [OrgMappedDataType],
            [Isnullable] AS [Isnullable],
            [OrdinalPosition] AS [OrdinalPosition],
            [MaximumLength] AS [MaximumLength],
            [Precision] AS [Precision],
            [Scale] AS [Scale],
            [Collation] AS [Collation],
            [Active] AS [Active],
            [FlowOrder] AS [FlowOrder],
            [BK_RefType_ObjectType] AS [BK_RefType_ObjectType],
            [BK_RefType_RepositoryStatus] AS [BK_RefType_RepositoryStatus],
            [DefaultValue] AS [DefaultValue],
            [DDL_Type1] AS [DDL_Type1],
            [DDL_Type2] AS [DDL_Type2],
            [DDL_Type3] AS [DDL_Type3],
            [DDL_Type4] AS [DDL_Type4],
            [mta_RecType], [mta_CreateDate], [mta_Source], [mta_BK], [mta_BKH], [mta_RH],
            [mta_IsDeleted] = IIF([mta_RecType] = -1, 1, 0)
        FROM Cur
        WHERE [mta_CurrentFlag] = 1 AND [mta_RecType] > -1