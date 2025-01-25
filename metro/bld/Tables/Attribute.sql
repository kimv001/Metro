CREATE TABLE [bld].[Attribute] (
    [AttributeId]                 INT           IDENTITY (1, 1) NOT NULL,
    [BK]                          VARCHAR (255) NULL,
    [Code]                        VARCHAR (255) NULL,
    [Name]                        VARCHAR (255) NULL,
    [BK_Dataset]                  VARCHAR (255) NULL,
    [Dataset]                     VARCHAR (255) NULL,
    [AttributeName]               VARCHAR (255) NULL,
    [Description]                 VARCHAR (255) NULL,
    [Expression]                  VARCHAR (MAX) NULL,
    [DistributionHashKey]         VARCHAR (255) NULL,
    [NotInRH]                     VARCHAR (255) NULL,
    [BusinessKey]                 VARCHAR (255) NULL,
    [isMta]                       VARCHAR (255) NULL,
    [SrcName]                     VARCHAR (255) NULL,
    [BK_RefType_DataType]         VARCHAR (255) NULL,
    [DataType]                    VARCHAR (255) NULL,
    [FixedSchemaDataType]         VARCHAR (255) NULL,
    [OrgMappedDataType]           VARCHAR (255) NULL,
    [Isnullable]                  VARCHAR (255) NULL,
    [OrdinalPosition]             VARCHAR (255) NULL,
    [MaximumLength]               VARCHAR (255) NULL,
    [Precision]                   VARCHAR (255) NULL,
    [Scale]                       VARCHAR (255) NULL,
    [Collation]                   VARCHAR (255) NULL,
    [Active]                      VARCHAR (255) NULL,
    [FlowOrder]                   VARCHAR (255) NULL,
    [BK_RefType_ObjectType]       VARCHAR (255) NULL,
    [BK_RefType_RepositoryStatus] VARCHAR (255) NULL,
    [SCDDate]                     VARCHAR (255) NULL,
    [DefaultValue]                VARCHAR (MAX) NULL,
    [DDL_Type1]                   VARCHAR (255) NULL,
    [DDL_Type2]                   VARCHAR (255) NULL,
    [DDL_Type3]                   VARCHAR (255) NULL,
    [DDL_Type4]                   VARCHAR (255) NULL,
    [mta_Createdate]              DATETIME2 (7) DEFAULT (getdate()) NULL,
    [mta_RecType]                 SMALLINT      DEFAULT ((1)) NULL,
    [mta_BK]                      CHAR (255)    NULL,
    [mta_BKH]                     CHAR (128)    NULL,
    [mta_RH]                      CHAR (128)    NULL,
    [mta_Source]                  VARCHAR (255) NULL
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [Uix_bld_Attribute]
    ON [bld].[Attribute]([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC);


GO
CREATE CLUSTERED INDEX [Cix_bld_Attribute]
    ON [bld].[Attribute]([BK] ASC, [mta_BKH] ASC, [Code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);

