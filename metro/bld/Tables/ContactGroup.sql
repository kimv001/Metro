
CREATE TABLE [bld].[contactgroup] ([contactgroupid] INT IDENTITY (1,
                                                                  1) NOT NULL,
                                                                     [bk] VARCHAR (255) NULL,
                                                                                        [code] VARCHAR (255) NULL,
                                                                                                             [name] VARCHAR (255) NULL,
                                                                                                                                  [description] VARCHAR (255) NULL,
                                                                                                                                                              [active] VARCHAR (255) NULL,
                                                                                                                                                                                     [mta_createdate] datetime2 (7) DEFAULT (getdate()) NULL,
                                                                                                                                                                                                                                        [mta_rectype] SMALLINT DEFAULT ((1)) NULL,
                                                                                                                                                                                                                                                                             [mta_bk] CHAR (255) NULL,
                                                                                                                                                                                                                                                                                                 [mta_bkh] CHAR (128) NULL,
                                                                                                                                                                                                                                                                                                                      [mta_rh] CHAR (128) NULL,
                                                                                                                                                                                                                                                                                                                                          [mta_source] VARCHAR (255) NULL);GO
CREATE UNIQUE nonclustered INDEX [uix_bld_contactgroup]
    ON [bld].[contactgroup]([mta_bkh] DESC, [mta_rh] DESC, [mta_createdate] DESC);GO
CREATE clustered INDEX [cix_bld_contactgroup]
    ON [bld].[contactgroup]([bk] ASC, [mta_bkh] ASC, [code] ASC, [mta_rh] ASC, [mta_createdate] DESC);
