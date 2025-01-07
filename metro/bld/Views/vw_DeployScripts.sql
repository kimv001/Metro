﻿
        CREATE   VIEW [bld].[vw_DeployScripts] AS
        /*
        View is generated by  : metro
        Generated at          : 2024-12-24 08:25:25
        Description           : View on stage table
        */
        WITH Cur AS (
            SELECT 
                [DeployScriptsId] AS [DeployScriptsId],
                [BK] AS [BK],
                [Code] AS [Code],
                [BK_Template] AS [BK_Template],
                [BK_Dataset] AS [BK_Dataset],
                [TGT_ObjectName] AS [TGT_ObjectName],
                [ObjectType] AS [ObjectType],
                [ObjectTypeDeployOrder] AS [ObjectTypeDeployOrder],
                [TemplateType] AS [TemplateType],
                [ScriptLanguageCode] AS [ScriptLanguageCode],
                [ScriptLanguage] AS [ScriptLanguage],
                [TemplateSource] AS [TemplateSource],
                [TemplateName] AS [TemplateName],
                [TemplateScript] AS [TemplateScript],
                [TemplateVersion] AS [TemplateVersion],
                [ToDeploy] AS [ToDeploy],
                [mta_RecType], [mta_CreateDate], [mta_Source], [mta_BK], [mta_BKH], [mta_RH],
                [mta_CurrentFlag] = ROW_NUMBER() OVER (PARTITION BY [mta_BKH] ORDER BY [mta_CreateDate] DESC)
            FROM [bld].[DeployScripts]
               
        )
        SELECT 
            [DeployScriptsId] AS [DeployScriptsId],
            [BK] AS [BK],
            [Code] AS [Code],
            [BK_Template] AS [BK_Template],
            [BK_Dataset] AS [BK_Dataset],
            [TGT_ObjectName] AS [TGT_ObjectName],
            [ObjectType] AS [ObjectType],
            [ObjectTypeDeployOrder] AS [ObjectTypeDeployOrder],
            [TemplateType] AS [TemplateType],
            [ScriptLanguageCode] AS [ScriptLanguageCode],
            [ScriptLanguage] AS [ScriptLanguage],
            [TemplateSource] AS [TemplateSource],
            [TemplateName] AS [TemplateName],
            [TemplateScript] AS [TemplateScript],
            [TemplateVersion] AS [TemplateVersion],
            [ToDeploy] AS [ToDeploy],
            [mta_RecType], [mta_CreateDate], [mta_Source], [mta_BK], [mta_BKH], [mta_RH],
            [mta_IsDeleted] = IIF([mta_RecType] = -1, 1, 0)
        FROM Cur
        WHERE [mta_CurrentFlag] = 1 AND [mta_RecType] > -1