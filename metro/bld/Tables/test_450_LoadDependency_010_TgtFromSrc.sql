CREATE TABLE [bld].[test_450_LoadDependency_010_TgtFromSrc] (
    [BK]                VARCHAR (511) NULL,
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
    [lvl]               INT           NULL,
    [dependencytype]    VARCHAR (10)  NOT NULL,
    [mta_rectype]       INT           NULL,
    [Generation_Number] BIGINT        NULL
);

