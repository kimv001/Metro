
CREATE TABLE [adf].[projects] ([projectid] AS (convert([nvarchar](900), [projectname])) persisted NOT NULL,
                                                                                                  [projectname] NVARCHAR (280) NOT NULL,
                                                                                                                               [projectdescription] NVARCHAR (MAX) NULL,
                                                                                                                                                                   CONSTRAINT [pk_projectid] PRIMARY KEY clustered ([projectid] ASC));