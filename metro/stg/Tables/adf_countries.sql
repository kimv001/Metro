CREATE TABLE [stg].[adf_countries] (
    [country_code]        VARCHAR (2)    NULL,
    [country_name]        VARCHAR (100)  NULL,
    [country_name_nl]     VARCHAR (100)  NULL,
    [continent_name]      VARCHAR (50)   NULL,
    [region_name]         VARCHAR (50)   NULL,
    [subregion_name]      VARCHAR (50)   NULL,
    [dialing_code]        VARCHAR (10)   NULL,
    [dialing_code_root]   VARCHAR (10)   NULL,
    [dialing_code_suffix] VARCHAR (10)   NULL,
    [currency_code]       VARCHAR (5)    NULL,
    [timezone_name]       VARCHAR (40)   NULL,
    [regional_blocs]      NVARCHAR (MAX) NULL
);

