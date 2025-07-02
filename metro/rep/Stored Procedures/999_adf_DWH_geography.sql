CREATE PROCEDURE [rep].[999_adf_DWH_geography]
AS
BEGIN

    ------------------------------------------------------------------------------------------
    -- Drop the existing DWH_geography table if it exists
    ------------------------------------------------------------------------------------------
    IF OBJECT_ID('adf.DWH_geography', 'U') IS NOT NULL
        DROP TABLE [adf].[DWH_geography];

    ------------------------------------------------------------------------------------------
    -- Create a new DWH_geography table with hierarchical geography data
    ------------------------------------------------------------------------------------------
    CREATE TABLE [adf].[DWH_geography] (
        geography_key       VARCHAR(100) PRIMARY KEY,
        geography_type      VARCHAR(20) NOT NULL,

        continent_name      VARCHAR(50) NULL,
        continent_name_nl   VARCHAR(50) NULL,
		continent_code		VARCHAR(2) NULL,
        region_name         VARCHAR(50) NULL,
        subregion_name      VARCHAR(50) NULL,
        country_code        VARCHAR(2)  NULL,
		country_code_iso_alpha3 VARCHAR(3)  NULL,
        country_code_M49    VARCHAR(3)  NULL,
		--country_code_ISO3   VARCHAR(2)  NULL,
        country_name        VARCHAR(100) NULL,
        country_name_nl     VARCHAR(100) NULL,
        department          VARCHAR(20) NULL,
		province_code       VARCHAR(10)	NULL,    -- e.g. "NH"
		province_name       VARCHAR(100) NULL,   -- e.g. "Noord-Holland"
		municipality_code   VARCHAR(10) NULL,    -- e.g. "0363"
        municipality_name   VARCHAR(100) NULL,
		pc4					VARCHAR(4)	NULL,    -- PC4 like "1011"
        postal_code         VARCHAR(20) NULL,
		pc10                VARCHAR(20) NULL,

        city_pop            VARCHAR(20) NULL,
        area_pop            VARCHAR(20) NULL,

        mcc                 VARCHAR(20) NULL,
        dialing_code        VARCHAR(20) NULL,
        timezone_name       VARCHAR(40) NULL,
        currency_code       VARCHAR(5)  NULL,

        is_in_eu            BIT NULL,
        is_in_eea           BIT NULL,
        is_in_eu_roaming    BIT NULL,
        gdpr_applicable     BIT NULL,

        is_ldc              BIT NULL,  -- Least Developed Country
        is_lldc             BIT NULL,  -- Landlocked Developing Country
        is_sids             BIT NULL,  -- Small Island Developing State

		geo_point           VARCHAR(100),   -- e.g. "52.375 -4.9"
		geo_shape           VARCHAR(max),   -- polygon info, kan veel data bevatten

        parent_key          VARCHAR(100) NULL,
		publicationyear     INT NULL,             -- publication/reference year
		src					VARCHAR(255) NULL
    );

    ------------------------------------------------------------------------------------------
    -- Insert GLOBAL root level
    ------------------------------------------------------------------------------------------
    INSERT INTO [adf].[DWH_geography] (
        geography_key, geography_type, parent_key, publicationyear, src
    )
    VALUES ('GLOBAL|GLOBAL', 'GLOBAL', 'GLOBAL|GLOBAL', datepart(yyyy, getdate()), 'Fixed --> Metro');


    ------------------------------------------------------------------------------------------
    -- Insert continents as children of the GLOBAL
    ------------------------------------------------------------------------------------------
    INSERT INTO [adf].[DWH_geography] (
        geography_key, geography_type, continent_code, continent_name, continent_name_nl, parent_key,publicationyear, src
    )
    VALUES
        ('CONTINENT|AFRICA'			, 'CONTINENT', 'AF', 'Africa'			, 'Afrika'				, 'GLOBAL|GLOBAL', datepart(yyyy, getdate()), 'Fixed --> Metro'),
        ('CONTINENT|ANTARCTICA'		, 'CONTINENT', 'AN', 'Antarctica'		, 'Antarctica'			, 'GLOBAL|GLOBAL', datepart(yyyy, getdate()), 'Fixed --> Metro'),
        ('CONTINENT|ASIA'			, 'CONTINENT', 'AS', 'Asia'				, 'Azië'				, 'GLOBAL|GLOBAL', datepart(yyyy, getdate()), 'Fixed --> Metro'),
        ('CONTINENT|EUROPE'			, 'CONTINENT', 'EU', 'Europe'			, 'Europa'				, 'GLOBAL|GLOBAL', datepart(yyyy, getdate()), 'Fixed --> Metro'),
        ('CONTINENT|NORTH_AMERICA'	, 'CONTINENT', 'NA', 'North America'	, 'Noord-Amerika'		, 'GLOBAL|GLOBAL', datepart(yyyy, getdate()), 'Fixed --> Metro'),
        ('CONTINENT|OCEANIA'		, 'CONTINENT', 'OC', 'Oceania'			, 'Oceanië'				, 'GLOBAL|GLOBAL', datepart(yyyy, getdate()), 'Fixed --> Metro'),
        ('CONTINENT|SOUTH_AMERICA'	, 'CONTINENT', 'SA', 'South America'	, 'Zuid-Amerika'		, 'GLOBAL|GLOBAL', datepart(yyyy, getdate()), 'Fixed --> Metro'),
		('CONTINENT|GLOBAL'			, 'CONTINENT', '-' , 'Global'			, 'Wereldwijd'			, 'GLOBAL|GLOBAL', datepart(yyyy, getdate()), 'Fixed --> Metro')
	--	('CONTINENT|-'				, 'CONTINENT', '-' , 'Not Applicable'	, 'Niet van toepassing'	, 'GLOBAL|GLOBAL', datepart(yyyy, getdate()), 'Fixed --> Metro');

    ------------------------------------------------------------------------------------------
    -- Combine fixed and ADF country data into a complete set
    ------------------------------------------------------------------------------------------
    ;WITH all_countries AS (
        SELECT
            country_code            = COALESCE(a.country_code, f.country_code),
            country_code_iso_alpha3 = case 
										when f.country_code  = 'TW' then 'TWN' 
										when f.country_code = 'XK' then 'XKX'
										else COALESCE(f.iso_alpha3, '-1') end,
            country_code_M49        = case 
										when f.country_code  = 'TW' then '158' 
										when f.country_code = 'XK' then '383'
										else  COALESCE(f.m49_code, '-1') end , 
            continent_name          = COALESCE(a.continent_name, a.region_name),
            region_name             = COALESCE(a.region_name, f.region_name),
            subregion_name          = CASE 
                                        WHEN ISNULL(f.intermediate_region_name, '') = '' THEN 
                                            COALESCE(NULLIF(f.subregion_name, ''), a.region_name, f.region_name)
                                        ELSE f.intermediate_region_name 
                                      END,
            country_name            = COALESCE(f.country_name, a.country_name),
            country_name_nl         = COALESCE(a.country_name_nl, ''),
            f.is_ldc,            
            f.is_lldc,            
            f.is_sids,            
            f.is_in_eu,                 
            f.is_in_eea,                 
            f.is_in_eu_roaming,          
            f.gdpr_applicable,           
            dialing_code            = CASE 
                                        WHEN a.dialing_code_suffix IS NOT NULL THEN a.dialing_code_root + a.dialing_code_suffix
                                        ELSE a.dialing_code_root 
                                      END,
            a.timezone_name,
            currency_code_adf       = a.currency_code,
            currency_code_fixed     = f.currency_code
        FROM stg.fixed_countrylist f
        FULL OUTER JOIN stg.adf_countries a 
            ON a.country_code = f.country_code
    ),
    
    ------------------------------------------------------------------------------------------
    -- Get most recent valid currency per country (excluding withdrawn ones)
    ------------------------------------------------------------------------------------------
    countrycurrency AS (
        SELECT 
            *,
            RN = ROW_NUMBER() OVER (PARTITION BY entity ORDER BY ISNULL(withdrawaldate, '9999-12-31') DESC)
        FROM stg.fixed_countrycurrencylist
    ),

    ------------------------------------------------------------------------------------------
    -- Cleaned list of countries with resolved currency codes
    ------------------------------------------------------------------------------------------
    cleaned_countries AS (
        SELECT 
            ac.country_code,
            ac.country_code_iso_alpha3,
            ac.country_code_M49,
            ac.continent_name,
            ac.region_name,
            ac.subregion_name,
            ac.country_name,
            ac.country_name_nl,
            ac.is_ldc,
            ac.is_lldc,
            ac.is_sids,
            ac.is_in_eu,
            ac.is_in_eea,
            ac.is_in_eu_roaming,
            ac.gdpr_applicable,
            ac.dialing_code,
            ac.timezone_name,
            currency_code = COALESCE(cc.AlphabeticCode, ac.currency_code_fixed, ac.currency_code_adf)
        FROM all_countries ac
        LEFT JOIN countrycurrency cc 
            ON ac.country_name = cc.entity 
            AND cc.WithdrawalDate IS NULL 
            AND cc.RN = 1
    )

    ------------------------------------------------------------------------------------------
    -- Insert countries into the DWH geography table
    ------------------------------------------------------------------------------------------
    INSERT INTO [adf].[DWH_geography] (
        geography_key, geography_type,
        continent_name, continent_name_nl,continent_code,
	    region_name, subregion_name,
	    country_code, country_name, country_name_nl, country_code_iso_alpha3, country_code_M49,
        dialing_code, timezone_name, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable, is_ldc, is_lldc, is_sids, 
        parent_key, src
    )
    SELECT
        'COUNTRY|' + src.country_code AS geography_key,
        'COUNTRY' AS geography_type,
        src.continent_name,
        con.continent_name_nl,
		con.continent_code,
		src.region_name,
		src.subregion_name,
        src.country_code,
        src.country_name,
        src.country_name_nl,
		src.country_code_iso_alpha3, src.country_code_M49,
        src.dialing_code,
        src.timezone_name,
        src.currency_code,
        src.is_in_eu,  --  Indicates whether the country is a member of the European Union (EU)
        src.is_in_eea, -- Indicates whether the country is part of the European Economic Area (EEA)
        src.is_in_eu_roaming, -- Indicates whether the country is part of the EU/EEA roaming zone, where EU roaming
        src.gdpr_applicable, -- Indicates whether the General Data Protection Regulation (GDPR) is applicable in the country.
        src.is_ldc, -- Indicates if the country is classified as a Least Developed Country (LDC) by the United
        src.is_lldc, -- Indicates whether the country is a Landlocked Developing Country (LLDC).
        src.is_sids, -- Indicates whether the country is a Small Island Developing State (SIDS).
        con.geography_key AS parent_key,
		'https://restcountries.com/v3.1/Fixed --> Metro' as src
    FROM cleaned_countries src
    LEFT JOIN [adf].[DWH_geography] con 
        ON src.continent_name = con.continent_name 
        AND con.geography_type = 'CONTINENT';

	;
	-- Dutch 

	INSERT INTO [adf].[DWH_geography] (
        geography_key, geography_type,
        continent_name, continent_name_nl,continent_code,
	    region_name, subregion_name,
	    country_code, country_name, country_name_nl, country_code_iso_alpha3, country_code_M49,
		province_code, province_name, municipality_code, municipality_name, pc4,
        dialing_code, timezone_name, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable, is_ldc, is_lldc, is_sids, 
		geo_point,  geo_shape,
        parent_key, publicationyear, src
    )
    SELECT
        'PC4|' + src.pc4	AS geography_key,
        'PC4' AS geography_type,
        c.continent_name,
        c.continent_name_nl,
		c.continent_code,
		c.region_name,
		c.subregion_name,
        c.country_code,
        c.country_name,
        c.country_name_nl,
		c.country_code_iso_alpha3, c.country_code_M49,
		province_code	= isnull(src.province_code,'-'),
		province_name	= isnull(src.province_name,'-'),
		municipality_code	= isnull(src.municipality_code,'-'),
		municipality_name	= isnull(src.municipality_name,'-'),
		src.pc4,
        c.dialing_code,
        c.timezone_name,
        c.currency_code,
        c.is_in_eu,  --  Indicates whether the country is a member of the European Union (EU)
        c.is_in_eea, -- Indicates whether the country is part of the European Economic Area (EEA)
        c.is_in_eu_roaming, -- Indicates whether the country is part of the EU/EEA roaming zone, where EU roaming
        c.gdpr_applicable, -- Indicates whether the General Data Protection Regulation (GDPR) is applicable in the country.
        c.is_ldc, -- Indicates if the country is classified as a Least Developed Country (LDC) by the United
        c.is_lldc, -- Indicates whether the country is a Landlocked Developing Country (LLDC).
        c.is_sids, -- Indicates whether the country is a Small Island Developing State (SIDS).
		src.geo_point,
		src.geo_shape,
        c.geography_key AS parent_key,
		src.publicationyear,
		src = 'https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/georef-netherlands-postcode-pc4/exports/csv?lang=en&timezone=Europe%2FBerlin&use_labels=true&delimiter=%3B / Fixed --> Metro'
		-- select *
    FROM stg.[adf_NL_Postcode4_OpenData] src
	left join [adf].[DWH_geography] c on 'COUNTRY' = geography_type and c.country_code = 'NL'

    ------------------------------------------------------------------------------------------
    -- (Optional) View creation for convenient querying
    ------------------------------------------------------------------------------------------
    /*
    CREATE VIEW adf.vw_DWH_geography AS 
    SELECT * FROM [adf].[DWH_geography];
    */

END;