CREATE TABLE [bld].[Layer] (
    [LayerId]             INT           IDENTITY (1, 1) NOT NULL,
    [bk]                  VARCHAR (255) NULL,
    [code]                VARCHAR (255) NULL,
    [Layer_Name]          VARCHAR (255) NULL,
    [Layer_Desciption]    VARCHAR (255) NULL,
    [isDWHhelper]         VARCHAR (255) NULL,
    [isRep]               VARCHAR (255) NULL,
    [isAudit]             VARCHAR (255) NULL,
    [isSRC]               VARCHAR (255) NULL,
    [isDWH]               VARCHAR (255) NULL,
    [isTGT]               VARCHAR (255) NULL,
    [Layer_Process_Order] VARCHAR (255) NULL,
    [mta_Createdate]      DATETIME2 (7) DEFAULT (getdate()) NULL,
    [mta_RecType]         SMALLINT      DEFAULT ((1)) NULL,
    [mta_BK]              CHAR (255)    NULL,
    [mta_BKH]             CHAR (128)    NULL,
    [mta_RH]              CHAR (128)    NULL,
    [mta_Source]          VARCHAR (255) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Uix_bld_Layer]
    ON [bld].[Layer]([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC);


GO
CREATE CLUSTERED INDEX [Cix_bld_Layer]
    ON [bld].[Layer]([bk] ASC, [mta_BKH] ASC, [code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);

