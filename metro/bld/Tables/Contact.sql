CREATE TABLE [bld].[Contact] (
    [ContactId]                INT           IDENTITY (1, 1) NOT NULL,
    [bk]                       VARCHAR (255) NULL,
    [code]                     VARCHAR (255) NULL,
    [bk_contactgroup]          VARCHAR (255) NULL,
    [contactgroup]             VARCHAR (255) NULL,
    [contactrole]              VARCHAR (255) NULL,
    [main_contact]             VARCHAR (255) NULL,
    [alert_contact]            VARCHAR (255) NULL,
    [contactperson_name]       VARCHAR (255) NULL,
    [contactperson_department] VARCHAR (255) NULL,
    [contacperson_phonenumber] VARCHAR (255) NULL,
    [contactperson_mailadress] VARCHAR (255) NULL,
    [contactperson_active]     VARCHAR (255) NULL,
    [rn_contact]               VARCHAR (255) NULL,
    [mta_Createdate]           DATETIME2 (7) DEFAULT (getdate()) NULL,
    [mta_RecType]              SMALLINT      DEFAULT ((1)) NULL,
    [mta_BK]                   CHAR (255)    NULL,
    [mta_BKH]                  CHAR (128)    NULL,
    [mta_RH]                   CHAR (128)    NULL,
    [mta_Source]               VARCHAR (255) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Uix_bld_Contact]
    ON [bld].[Contact]([mta_BKH] DESC, [mta_RH] DESC, [mta_Createdate] DESC);


GO
CREATE CLUSTERED INDEX [Cix_bld_Contact]
    ON [bld].[Contact]([bk] ASC, [mta_BKH] ASC, [code] ASC, [mta_RH] ASC, [mta_Createdate] DESC);

