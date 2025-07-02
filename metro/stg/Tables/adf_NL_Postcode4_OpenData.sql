CREATE TABLE [stg].[adf_NL_Postcode4_OpenData] (
    [geo_point]         NVARCHAR (100) NULL,
    [geo_shape]         NVARCHAR (MAX) NULL,
    [pc4]               NVARCHAR (10)  NULL,
    [publicationyear]   INT            NULL,
    [municipality_code] NVARCHAR (10)  NULL,
    [province_code]     NVARCHAR (10)  NULL,
    [province_name]     NVARCHAR (100) NULL,
    [municipality_name] NVARCHAR (100) NULL
);

