CREATE TABLE [bld].[LoadDependency] (
    [LoadDependencyId]  INT           IDENTITY (1, 1) NOT NULL,
    [BK]                VARCHAR (255) NULL,
    [Code]              VARCHAR (255) NULL,
    [BK_Target]         VARCHAR (255) NULL,
    [TGT_Layer]         VARCHAR (255) NULL,
    [TGT_Schema]        VARCHAR (255) NULL,
    [TGT_Group]         VARCHAR (255) NULL,
    [TGT_ShortName]     VARCHAR (255) NULL,
    [TGT_Code]          VARCHAR (255) NULL,
    [TGT_DatasetName]   VARCHAR (255) NULL,
    [BK_Source]         VARCHAR (255) NULL,
    [SRC_Layer]         VARCHAR (255) NULL,
    [SRC_Schema]        VARCHAR (255) NULL,
    [SRC_Group]         VARCHAR (255) NULL,
    [SRC_ShortName]     VARCHAR (255) NULL,
    [SRC_Code]          VARCHAR (255) NULL,
    [SRC_DatasetName]   VARCHAR (255) NULL,
    [DependencyType]    VARCHAR (255) NULL,
    [Generation_Number] VARCHAR (255) NULL,
    [mta_Createdate]    DATETIME2 (7) DEFAULT (getdate()) NULL,
    [mta_RecType]       SMALLINT      DEFAULT ((1)) NULL,
    [mta_BK]            CHAR (255)    NULL,
    [mta_BKH]           CHAR (128)    NULL,
    [mta_RH]            CHAR (128)    NULL,
    [mta_Source]        VARCHAR (255) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Uix_bld_LoadDependency]
    ON [bld].[LoadDependency]([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC);


GO
CREATE CLUSTERED INDEX [Cix_bld_LoadDependency]
    ON [bld].[LoadDependency]([BK] ASC, [mta_BKH] ASC, [Code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);

