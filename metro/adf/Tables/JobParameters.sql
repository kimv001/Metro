
CREATE TABLE [adf].[jobparameters]
  ([jobparameterid] AS (convert([nvarchar](900), concat_ws('|', [jobid], [jobparametername]))) persisted NOT NULL,
                                                                                                         [jobparametername] NVARCHAR (280) NOT NULL,
                                                                                                                                           [jobparametervalue] NVARCHAR (MAX) NOT NULL,
                                                                                                                                                                              [jobparameterdescription] NVARCHAR (MAX) NULL,
                                                                                                                                                                                                                       [jobid] NVARCHAR (900) NOT NULL,
                                                                                                                                                                                                                                              CONSTRAINT [pk_jobparameters] PRIMARY KEY clustered ([jobparameterid] ASC),
                                                                                                                                                                                                                                                                                        CONSTRAINT [fk_jobparameters_jobid]
   FOREIGN KEY ([jobid]) REFERENCES [adf].[jobs] ([jobid]) ON DELETE CASCADE ON UPDATE CASCADE);