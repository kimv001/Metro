CREATE TABLE [bld].[BuildCheck] (
    [BuildCheckId]   INT           IDENTITY (1, 1) NOT NULL,
    [BK]             VARCHAR (255) NULL,
    [Code]           VARCHAR (255) NULL,
    [CheckMessage]   VARCHAR (255) NULL,
    [LayerName]      VARCHAR (255) NULL,
    [SchemaName]     VARCHAR (255) NULL,
    [GroupName]      VARCHAR (255) NULL,
    [ShortName]      VARCHAR (255) NULL,
    [mta_Createdate] DATETIME2 (7) DEFAULT (getdate()) NULL,
    [mta_RecType]    SMALLINT      DEFAULT ((1)) NULL,
    [mta_BK]         CHAR (255)    NULL,
    [mta_BKH]        CHAR (128)    NULL,
    [mta_RH]         CHAR (128)    NULL,
    [mta_Source]     VARCHAR (255) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Uix_bld_BuildCheck]
    ON [bld].[BuildCheck]([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC);


GO
CREATE CLUSTERED INDEX [Cix_bld_BuildCheck]
    ON [bld].[BuildCheck]([BK] ASC, [mta_BKH] ASC, [Code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);

