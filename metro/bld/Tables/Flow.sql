CREATE TABLE [bld].[Flow] (
    [FlowId]                      INT           IDENTITY (1, 1) NOT NULL,
    [BK]                          VARCHAR (255) NULL,
    [Code]                        VARCHAR (255) NULL,
    [BK_Flow]                     VARCHAR (255) NULL,
    [Flow_Name]                   VARCHAR (255) NULL,
    [Flow_Description]            VARCHAR (255) NULL,
    [Flow_Layer_Step_Name]        VARCHAR (255) NULL,
    [Flow_Layer_Step_Description] VARCHAR (255) NULL,
    [Flow_Layer_Step_Order]       VARCHAR (255) NULL,
    [BK_Layer]                    VARCHAR (255) NULL,
    [BK_Schema]                   VARCHAR (255) NULL,
    [ReadFromView]                VARCHAR (255) NULL,
    [BK_Template_Load]            VARCHAR (255) NULL,
    [BK_Template_Create]          VARCHAR (255) NULL,
    [mta_Createdate]              DATETIME2 (7) DEFAULT (getdate()) NULL,
    [mta_RecType]                 SMALLINT      DEFAULT ((1)) NULL,
    [mta_BK]                      CHAR (255)    NULL,
    [mta_BKH]                     CHAR (128)    NULL,
    [mta_RH]                      CHAR (128)    NULL,
    [mta_Source]                  VARCHAR (255) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Uix_bld_Flow]
    ON [bld].[Flow]([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC);


GO
CREATE CLUSTERED INDEX [Cix_bld_Flow]
    ON [bld].[Flow]([BK] ASC, [mta_BKH] ASC, [Code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);

