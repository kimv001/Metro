
CREATE TABLE [adf].[flows]
  ([flowid] AS (convert([nvarchar](900), concat_ws('|', [projectid], [flowname]))) persisted NOT NULL,
                                                                                             [flowname] NVARCHAR (280) NOT NULL,
                                                                                                                       [flowdescription] NVARCHAR (MAX) NULL,
                                                                                                                                                        [projectid] NVARCHAR (900) NOT NULL,
                                                                                                                                                                                   [flowgroup] NVARCHAR (MAX) NULL,
                                                                                                                                                                                                              [floworder] INT NULL,
                                                                                                                                                                                                                              [flowdependencies] NVARCHAR (MAX) NULL,
                                                                                                                                                                                                                                                                CONSTRAINT [pk_flowid] PRIMARY KEY clustered ([flowid] ASC),
                                                                                                                                                                                                                                                                                                   CONSTRAINT [fk_flows_projectid]
   FOREIGN KEY ([projectid]) REFERENCES [adf].[projects] ([projectid]) ON DELETE CASCADE ON UPDATE CASCADE);