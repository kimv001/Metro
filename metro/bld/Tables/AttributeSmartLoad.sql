
CREATE TABLE [bld].[attributesmartload] ([attributesmartloadid] INT IDENTITY (1,
                                                                              1) NOT NULL,
                                                                                 [bk] VARCHAR (255) NULL,
                                                                                                    [code] VARCHAR (255) NULL,
                                                                                                                         [srccreatedate] VARCHAR (255) NULL,
                                                                                                                                                       [tgtcreatedate] VARCHAR (255) NULL,
                                                                                                                                                                                     [isupdated] VARCHAR (255) NULL,
                                                                                                                                                                                                               [rectype] VARCHAR (255) NULL,
                                                                                                                                                                                                                                       [mta_createdate] datetime2 (7) DEFAULT (getdate()) NULL,
                                                                                                                                                                                                                                                                                          [mta_rectype] SMALLINT DEFAULT ((1)) NULL,
                                                                                                                                                                                                                                                                                                                               [mta_bk] CHAR (255) NULL,
                                                                                                                                                                                                                                                                                                                                                   [mta_bkh] CHAR (128) NULL,
                                                                                                                                                                                                                                                                                                                                                                        [mta_rh] CHAR (128) NULL,
                                                                                                                                                                                                                                                                                                                                                                                            [mta_source] VARCHAR (255) NULL);GO
CREATE UNIQUE nonclustered INDEX [uix_bld_attributesmartload]
    ON [bld].[attributesmartload]([mta_bkh] DESC, [mta_rh] DESC, [mta_createdate] DESC);GO
CREATE clustered INDEX [cix_bld_attributesmartload]
    ON [bld].[attributesmartload]([bk] ASC, [mta_bkh] ASC, [code] ASC, [mta_rh] ASC, [mta_createdate] DESC);
