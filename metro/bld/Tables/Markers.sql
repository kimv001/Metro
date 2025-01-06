CREATE TABLE [bld].[Markers] (
    [MarkersId]         INT           IDENTITY (1, 1) NOT NULL,
    [BK]                VARCHAR (255) NULL,
    [BK_Dataset]        VARCHAR (255) NULL,
    [Code]              VARCHAR (255) NULL,
    [MarkerType]        VARCHAR (255) NULL,
    [MarkerDescription] VARCHAR (255) NULL,
    [Marker]            VARCHAR (255) NULL,
    [MarkerValue]       VARCHAR (MAX) NULL,
    [Pre]               VARCHAR (255) NULL,
    [Post]              VARCHAR (255) NULL,
    [MarkerVersion]     VARCHAR (255) NULL,
    [mta_Createdate]    DATETIME2 (7) DEFAULT (getdate()) NULL,
    [mta_RecType]       SMALLINT      DEFAULT ((1)) NULL,
    [mta_BK]            CHAR (255)    NULL,
    [mta_BKH]           CHAR (128)    NULL,
    [mta_RH]            CHAR (128)    NULL,
    [mta_Source]        VARCHAR (255) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Uix_bld_Markers]
    ON [bld].[Markers]([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC);


GO
CREATE CLUSTERED INDEX [Cix_bld_Markers]
    ON [bld].[Markers]([BK] ASC, [mta_BKH] ASC, [Code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);

