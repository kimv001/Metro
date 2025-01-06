
CREATE TABLE [adf].[jobdependencies] ([dependingjobid] NVARCHAR (900) NOT NULL,
                                                                      [prerequisitejobid] NVARCHAR (900) NOT NULL,
                                                                                                         [jobdependencytype] NVARCHAR (MAX) NULL,
                                                                                                                                            [jobdependecydescription] NVARCHAR (MAX) NULL);
