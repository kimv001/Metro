
CREATE TABLE [aud].[flowruns] ([projectid] NVARCHAR (900) NOT NULL,
                                                          [flowid] NVARCHAR (900) NOT NULL,
                                                                                  [flowname] NVARCHAR (280) NOT NULL,
                                                                                                            [flowrunguid] NVARCHAR (36) NOT NULL,
                                                                                                                                        [runstart] datetime2 (7) NULL,
                                                                                                                                                                 [runend] datetime2 (7) NULL,
                                                                                                                                                                                        [runduration] INT NULL,
                                                                                                                                                                                                          [runstatus] NVARCHAR (10) NULL,
                                                                                                                                                                                                                                    [logdatetime] datetime2 (7) NULL);
