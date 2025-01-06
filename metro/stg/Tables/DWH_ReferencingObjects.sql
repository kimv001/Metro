
CREATE TABLE [stg].[dwh_referencingobjects] ([referencingobjecttype] CHAR (2) NULL,
                                                                              [referencingobject] NVARCHAR (517) NULL,
                                                                                                                 [referencedobject] NVARCHAR (517) NULL,
                                                                                                                                                   [referencedobjecttype] CHAR (2) NULL,
                                                                                                                                                                                   [importdate] datetime2 (7) NULL,
                                                                                                                                                                                                              [mta_source] NVARCHAR (MAX) NULL,
                                                                                                                                                                                                                                          [mta_loaddate] NVARCHAR (MAX) NULL,
                                                                                                                                                                                                                                                                        [bk_datasource] NVARCHAR (MAX) NULL);
