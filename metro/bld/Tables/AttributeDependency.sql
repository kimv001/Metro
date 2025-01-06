
CREATE TABLE [bld].[attributedependency] ([attributedependencyid] INT IDENTITY (1,
                                                                                1) NOT NULL,
                                                                                   [bk] VARCHAR (500) NULL,
                                                                                                      [bk_source] VARCHAR (255) NULL,
                                                                                                                                [bk_parent] VARCHAR (255) NULL,
                                                                                                                                                          [depencyorder] VARCHAR (255) NULL,
                                                                                                                                                                                       [code] VARCHAR (255) NULL,
                                                                                                                                                                                                            [mta_createdate] datetime2 (7) DEFAULT (getdate()) NULL,
                                                                                                                                                                                                                                                               [mta_rectype] SMALLINT DEFAULT ((1)) NULL,
                                                                                                                                                                                                                                                                                                    [mta_bk] CHAR (128) NULL,
                                                                                                                                                                                                                                                                                                                        [mta_bkh] CHAR (128) NULL,
                                                                                                                                                                                                                                                                                                                                             [mta_rh] CHAR (128) NULL,
                                                                                                                                                                                                                                                                                                                                                                 [mta_source] VARCHAR (255) NULL);GO
CREATE UNIQUE nonclustered INDEX [uix_bld_attributedependency]
    ON [bld].[attributedependency]([mta_bkh] DESC, [mta_rh] DESC, [mta_createdate] DESC);GO
CREATE clustered INDEX [cix_bld_attributedependency]
    ON [bld].[attributedependency]([bk] ASC, [mta_bkh] ASC, [code] ASC, [mta_rh] ASC);
