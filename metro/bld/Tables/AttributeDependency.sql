CREATE TABLE [bld].[AttributeDependency] (
    [AttributeDependencyId] INT           IDENTITY (1, 1) NOT NULL,
    [BK]                    VARCHAR (500) NULL,
    [BK_Source]             VARCHAR (255) NULL,
    [BK_Parent]             VARCHAR (255) NULL,
    [DepencyOrder]          VARCHAR (255) NULL,
    [Code]                  VARCHAR (255) NULL,
    [mta_Createdate]        DATETIME2 (7) DEFAULT (getdate()) NULL,
    [mta_RecType]           SMALLINT      DEFAULT ((1)) NULL,
    [mta_BK]                CHAR (128)    NULL,
    [mta_BKH]               CHAR (128)    NULL,
    [mta_RH]                CHAR (128)    NULL,
    [mta_Source]            VARCHAR (255) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Uix_bld_AttributeDependency]
    ON [bld].[AttributeDependency]([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC);


GO
CREATE CLUSTERED INDEX [Cix_bld_AttributeDependency]
    ON [bld].[AttributeDependency]([BK] ASC, [mta_BKH] ASC, [Code] ASC, [mta_RH] ASC);

