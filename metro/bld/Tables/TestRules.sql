CREATE TABLE [bld].[TestRules] (
    [TestRulesId]                 INT           IDENTITY (1, 1) NOT NULL,
    [Code]                        VARCHAR (255) NULL,
    [BK]                          VARCHAR (255) NULL,
    [BK_Dataset]                  VARCHAR (255) NULL,
    [BK_RefType_RepositoryStatus] VARCHAR (255) NULL,
    [TestDefintion]               VARCHAR (255) NULL,
    [ADFPipeline]                 VARCHAR (255) NULL,
    [GetAttributes]               VARCHAR (255) NULL,
    [TresholdValue]               VARCHAR (MAX) NULL,
    [SpecificAttribute]           VARCHAR (255) NULL,
    [AttributeName]               VARCHAR (255) NULL,
    [ExpectedValue]               VARCHAR (MAX) NULL,
    [mta_Createdate]              DATETIME2 (7) DEFAULT (getdate()) NULL,
    [mta_RecType]                 SMALLINT      DEFAULT ((1)) NULL,
    [mta_BK]                      CHAR (255)    NULL,
    [mta_BKH]                     CHAR (128)    NULL,
    [mta_RH]                      CHAR (128)    NULL,
    [mta_Source]                  VARCHAR (255) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Uix_bld_TestRules]
    ON [bld].[TestRules]([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC);


GO
CREATE CLUSTERED INDEX [Cix_bld_TestRules]
    ON [bld].[TestRules]([BK] ASC, [mta_BKH] ASC, [Code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);

