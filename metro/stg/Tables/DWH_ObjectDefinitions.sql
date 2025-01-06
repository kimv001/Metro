
CREATE TABLE [stg].[dwh_objectdefinitions] ([objectcatalog] NVARCHAR (128) NULL,
                                                                           [objectschema] NVARCHAR (128) NULL,
                                                                                                         [objectname] NVARCHAR (128) NULL,
                                                                                                                                     [objecttype] CHAR (2) NULL,
                                                                                                                                                           [objectdefinition] NVARCHAR (MAX) NULL,
                                                                                                                                                                                             [objectdefinition_contains_business_logic] INT NULL,
                                                                                                                                                                                                                                            [importdate] datetime2 (7) NULL,
                                                                                                                                                                                                                                                                       [mta_source] NVARCHAR (MAX) NULL,
                                                                                                                                                                                                                                                                                                   [mta_loaddate] NVARCHAR (MAX) NULL,
                                                                                                                                                                                                                                                                                                                                 [bk_datasource] NVARCHAR (MAX) NULL);
