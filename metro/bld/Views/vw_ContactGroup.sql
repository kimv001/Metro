﻿
        CREATE   VIEW [bld].[vw_ContactGroup] AS
        /*
        View is generated by  : metro
        Generated at          : 2025-01-21 08:32:48
        Description           : View on stage table
        */
        WITH Cur AS (
            SELECT 
                [ContactGroupId] AS [ContactGroupId], [BK] AS [BK], [Code] AS [Code], [Name] AS [Name], [Description] AS [Description], [Active] AS [Active],
                [mta_RecType], [mta_CreateDate], [mta_Source], [mta_BK], [mta_BKH], [mta_RH],
                [mta_CurrentFlag] = ROW_NUMBER() OVER (PARTITION BY [mta_BKH] ORDER BY [mta_CreateDate] DESC)
            FROM [bld].[ContactGroup]
               
        )
        SELECT 
            [ContactGroupId] AS [ContactGroupId], [BK] AS [BK], [Code] AS [Code], [Name] AS [Name], [Description] AS [Description], [Active] AS [Active],
            [mta_RecType], [mta_CreateDate], [mta_Source], [mta_BK], [mta_BKH], [mta_RH],
            [mta_IsDeleted] = IIF([mta_RecType] = -1, 1, 0)
        FROM Cur
        WHERE [mta_CurrentFlag] = 1 AND [mta_RecType] > -1