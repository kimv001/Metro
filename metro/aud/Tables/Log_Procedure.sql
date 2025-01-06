
CREATE TABLE [aud].[log_procedure] ([log_procedureid] INT IDENTITY (1,
                                                                    1) NOT NULL,
                                                                       [log_time] datetime2 (7) NOT NULL,
                                                                                                [log_action] VARCHAR (50) NOT NULL,
                                                                                                                          [log_note] VARCHAR (MAX) NOT NULL,
                                                                                                                                                   [log_procedure] VARCHAR (255) NULL,
                                                                                                                                                                                 [log_sql] VARCHAR (MAX) NULL,
                                                                                                                                                                                                         [log_rowcount] BIGINT NULL,
                                                                                                                                                                                                                               [log_user] VARCHAR (255) NULL,
                                                                                                                                                                                                                                                        [log_timestart] datetime2 (7) NULL,
                                                                                                                                                                                                                                                                                      [log_timeend] datetime2 (7) NULL,
                                                                                                                                                                                                                                                                                                                  CONSTRAINT [pk_logprocedure] PRIMARY KEY clustered ([log_procedureid] ASC));
