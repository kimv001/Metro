CREATE TABLE [stg].[fixed_countrylist] (
    [country_code]             VARCHAR (2)   NOT NULL,
    [country_name]             VARCHAR (150) NOT NULL,
    [region_name]              VARCHAR (100) NULL,
    [subregion_name]           VARCHAR (100) NULL,
    [intermediate_region_name] VARCHAR (100) NULL,
    [iso_alpha3]               CHAR (3)      NULL,
    [m49_code]                 VARCHAR (10)  NULL,
    [is_ldc]                   BIT           NULL,
    [is_lldc]                  BIT           NULL,
    [is_sids]                  BIT           NULL,
    [currency_code]            CHAR (3)      NULL,
    [is_in_eu]                 BIT           NULL,
    [is_in_eea]                BIT           NULL,
    [is_in_eu_roaming]         BIT           NULL,
    [gdpr_applicable]          BIT           NULL,
    PRIMARY KEY CLUSTERED ([country_code] ASC)
);

