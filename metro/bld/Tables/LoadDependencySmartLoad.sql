CREATE TABLE [bld].[LoadDependencySmartLoad] (
    [LoadDependencySmartLoadId] INT           IDENTITY (1, 1) NOT NULL,
    [BK]                        VARCHAR (255) NULL,
    [CODE]                      VARCHAR (255) NULL,
    [SRCCREATEDATE]             VARCHAR (255) NULL,
    [TGTCREATEDATE]             VARCHAR (255) NULL,
    [TGTMTASOURCE]              VARCHAR (255) NULL,
    [ISUPDATED]                 VARCHAR (255) NULL,
    [RECTYPE]                   VARCHAR (255) NULL,
    [rn]                        VARCHAR (255) NULL,
    [mta_Createdate]            DATETIME2 (7) DEFAULT (getdate()) NULL,
    [mta_RecType]               SMALLINT      DEFAULT ((1)) NULL,
    [mta_BK]                    CHAR (255)    NULL,
    [mta_BKH]                   CHAR (128)    NULL,
    [mta_RH]                    CHAR (128)    NULL,
    [mta_Source]                VARCHAR (255) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Uix_bld_LoadDependencySmartLoad]
    ON [bld].[LoadDependencySmartLoad]([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC);


GO
CREATE CLUSTERED INDEX [Cix_bld_LoadDependencySmartLoad]
    ON [bld].[LoadDependencySmartLoad]([BK] ASC, [mta_BKH] ASC, [CODE] ASC, [mta_RH] ASC, [mta_Createdate] DESC);

