﻿
CREATE TABLE [rep].[contact] ([bk] NVARCHAR (MAX) NULL,
                                                  [code] NVARCHAR (MAX) NULL,
                                                                        [name] NVARCHAR (MAX) NULL,
                                                                                              [description] NVARCHAR (MAX) NULL,
                                                                                                                           [bk_contactgroup] NVARCHAR (MAX) NULL,
                                                                                                                                                            [bk_contactrole] NVARCHAR (MAX) NULL,
                                                                                                                                                                                            [bk_contactperson] NVARCHAR (MAX) NULL,
                                                                                                                                                                                                                              [main_contact] NVARCHAR (MAX) NULL,
                                                                                                                                                                                                                                                            [alert_contact] NVARCHAR (MAX) NULL,
                                                                                                                                                                                                                                                                                           [active] NVARCHAR (MAX) NULL,
                                                                                                                                                                                                                                                                                                                   [mta_source] NVARCHAR (MAX) NULL,
                                                                                                                                                                                                                                                                                                                                               [mta_loaddate] NVARCHAR (MAX) NULL);
