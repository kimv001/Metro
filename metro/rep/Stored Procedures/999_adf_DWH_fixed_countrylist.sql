CREATE PROCEDURE rep.[999_adf_DWH_fixed_countrylist] AS
BEGIN


-- Drop existing [DWH_geography] table if it exists
IF OBJECT_ID('stg.fixed_countrylist', 'U') IS NOT NULL
--print 'kim'
Drop Table stg.fixed_countrylist
		;
CREATE TABLE stg.fixed_countrylist (
country_code               VARCHAR(2)   NOT NULL PRIMARY KEY,  -- ISO Alpha-2 (e.g. 'NL')
    country_name               VARCHAR(150) NOT NULL,              -- Full country name (e.g. 'Netherlands')
    region_name                VARCHAR(100) NULL,                  -- UN Region (e.g. 'Europe')
    subregion_name             VARCHAR(100) NULL,                  -- UN Subregion (e.g. 'Western Europe')
    intermediate_region_name   VARCHAR(100) NULL,                  -- Optional intermediate region (e.g. 'Caribbean')
    
    iso_alpha3                 CHAR(3)      NULL,                  -- ISO Alpha-3 (e.g. 'NLD')
    m49_code                   VARCHAR(10)  NULL,                  -- UN M49 numeric code (e.g. '528')
    
    is_ldc                     BIT          NULL,                  -- Least Developed Country (1 or 0)
    is_lldc                    BIT          NULL,                  -- Landlocked Developing Country (1 or 0)
    is_sids                    BIT          NULL,                  -- Small Island Developing State (1 or 0)
    
    currency_code              CHAR(3)      NULL,                  -- ISO Currency Code (e.g. 'EUR')

    is_in_eu                   BIT          NULL,                  -- EU member
    is_in_eea                  BIT          NULL,                  -- EEA member
    is_in_eu_roaming           BIT          NULL,                  -- In EU/EEA roaming zone
    gdpr_applicable            BIT          NULL                   -- GDPR applies
);

    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'DZ', 'Algeria', 'Africa', 'Northern Africa', '',
        'DZA', '012', 0, 0, 0, 'DZD',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'EG', 'Egypt', 'Africa', 'Northern Africa', '',
        'EGY', '818', 0, 0, 0, 'EGP',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'LY', 'Libya', 'Africa', 'Northern Africa', '',
        'LBY', '434', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MA', 'Morocco', 'Africa', 'Northern Africa', '',
        'MAR', '504', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SD', 'Sudan', 'Africa', 'Northern Africa', '',
        'SDN', '729', 1, 0, 0, 'SDG',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'TN', 'Tunisia', 'Africa', 'Northern Africa', '',
        'TUN', '788', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'EH', 'Western Sahara', 'Africa', 'Northern Africa', '',
        'ESH', '732', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'IO', 'British Indian Ocean Territory', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'IOT', '086', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BI', 'Burundi', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'BDI', '108', 1, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'KM', 'Comoros', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'COM', '174', 1, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'DJ', 'Djibouti', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'DJI', '262', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'ER', 'Eritrea', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'ERI', '232', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'ET', 'Ethiopia', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'ETH', '231', 1, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'TF', 'French Southern Territories', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'ATF', '260', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'KE', 'Kenya', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'KEN', '404', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MG', 'Madagascar', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'MDG', '450', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MW', 'Malawi', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'MWI', '454', 1, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MU', 'Mauritius', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'MUS', '480', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'YT', 'Mayotte', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'MYT', '175', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MZ', 'Mozambique', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'MOZ', '508', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'RE', 'Réunion', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'REU', '638', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'RW', 'Rwanda', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'RWA', '646', 1, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SC', 'Seychelles', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'SYC', '690', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SO', 'Somalia', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'SOM', '706', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SS', 'South Sudan', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'SSD', '728', 1, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'UG', 'Uganda', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'UGA', '800', 1, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'TZ', 'United Republic of Tanzania', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'TZA', '834', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'ZM', 'Zambia', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'ZMB', '894', 1, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'ZW', 'Zimbabwe', 'Africa', 'Sub-Saharan Africa', 'Eastern Africa',
        'ZWE', '716', 0, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'AO', 'Angola', 'Africa', 'Sub-Saharan Africa', 'Middle Africa',
        'AGO', '024', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CM', 'Cameroon', 'Africa', 'Sub-Saharan Africa', 'Middle Africa',
        'CMR', '120', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CF', 'Central African Republic', 'Africa', 'Sub-Saharan Africa', 'Middle Africa',
        'CAF', '140', 1, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'TD', 'Chad', 'Africa', 'Sub-Saharan Africa', 'Middle Africa',
        'TCD', '148', 1, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CG', 'Congo', 'Africa', 'Sub-Saharan Africa', 'Middle Africa',
        'COG', '178', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CD', 'Democratic Republic of the Congo', 'Africa', 'Sub-Saharan Africa', 'Middle Africa',
        'COD', '180', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GQ', 'Equatorial Guinea', 'Africa', 'Sub-Saharan Africa', 'Middle Africa',
        'GNQ', '226', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GA', 'Gabon', 'Africa', 'Sub-Saharan Africa', 'Middle Africa',
        'GAB', '266', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'ST', 'Sao Tome and Principe', 'Africa', 'Sub-Saharan Africa', 'Middle Africa',
        'STP', '678', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BW', 'Botswana', 'Africa', 'Sub-Saharan Africa', 'Southern Africa',
        'BWA', '072', 0, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SZ', 'Eswatini', 'Africa', 'Sub-Saharan Africa', 'Southern Africa',
        'SWZ', '748', 0, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'LS', 'Lesotho', 'Africa', 'Sub-Saharan Africa', 'Southern Africa',
        'LSO', '426', 1, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'NA', 'Namibia', 'Africa', 'Sub-Saharan Africa', 'Southern Africa',
        'NAM', '516', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'ZA', 'South Africa', 'Africa', 'Sub-Saharan Africa', 'Southern Africa',
        'ZAF', '710', 0, 0, 0, 'ZAR',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BJ', 'Benin', 'Africa', 'Sub-Saharan Africa', 'Western Africa',
        'BEN', '204', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BF', 'Burkina Faso', 'Africa', 'Sub-Saharan Africa', 'Western Africa',
        'BFA', '854', 1, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CV', 'Cabo Verde', 'Africa', 'Sub-Saharan Africa', 'Western Africa',
        'CPV', '132', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CI', 'Côte d’Ivoire', 'Africa', 'Sub-Saharan Africa', 'Western Africa',
        'CIV', '384', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GM', 'Gambia', 'Africa', 'Sub-Saharan Africa', 'Western Africa',
        'GMB', '270', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GH', 'Ghana', 'Africa', 'Sub-Saharan Africa', 'Western Africa',
        'GHA', '288', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GN', 'Guinea', 'Africa', 'Sub-Saharan Africa', 'Western Africa',
        'GIN', '324', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GW', 'Guinea-Bissau', 'Africa', 'Sub-Saharan Africa', 'Western Africa',
        'GNB', '624', 1, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'LR', 'Liberia', 'Africa', 'Sub-Saharan Africa', 'Western Africa',
        'LBR', '430', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'ML', 'Mali', 'Africa', 'Sub-Saharan Africa', 'Western Africa',
        'MLI', '466', 1, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MR', 'Mauritania', 'Africa', 'Sub-Saharan Africa', 'Western Africa',
        'MRT', '478', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'NE', 'Niger', 'Africa', 'Sub-Saharan Africa', 'Western Africa',
        'NER', '562', 1, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'NG', 'Nigeria', 'Africa', 'Sub-Saharan Africa', 'Western Africa',
        'NGA', '566', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SH', 'Saint Helena', 'Africa', 'Sub-Saharan Africa', 'Western Africa',
        'SHN', '654', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SN', 'Senegal', 'Africa', 'Sub-Saharan Africa', 'Western Africa',
        'SEN', '686', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SL', 'Sierra Leone', 'Africa', 'Sub-Saharan Africa', 'Western Africa',
        'SLE', '694', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'TG', 'Togo', 'Africa', 'Sub-Saharan Africa', 'Western Africa',
        'TGO', '768', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'AI', 'Anguilla', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'AIA', '660', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'AG', 'Antigua and Barbuda', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'ATG', '028', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'AW', 'Aruba', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'ABW', '533', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BS', 'Bahamas', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'BHS', '044', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BB', 'Barbados', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'BRB', '052', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BQ', 'Bonaire, Sint Eustatius and Saba', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'BES', '535', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'VG', 'British Virgin Islands', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'VGB', '092', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'KY', 'Cayman Islands', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'CYM', '136', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CU', 'Cuba', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'CUB', '192', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CW', 'Curaçao', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'CUW', '531', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'DM', 'Dominica', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'DMA', '212', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'DO', 'Dominican Republic', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'DOM', '214', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GD', 'Grenada', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'GRD', '308', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GP', 'Guadeloupe', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'GLP', '312', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'HT', 'Haiti', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'HTI', '332', 1, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'JM', 'Jamaica', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'JAM', '388', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MQ', 'Martinique', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'MTQ', '474', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MS', 'Montserrat', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'MSR', '500', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'PR', 'Puerto Rico', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'PRI', '630', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BL', 'Saint Barthélemy', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'BLM', '652', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'KN', 'Saint Kitts and Nevis', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'KNA', '659', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'LC', 'Saint Lucia', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'LCA', '662', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MF', 'Saint Martin (French Part)', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'MAF', '663', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'VC', 'Saint Vincent and the Grenadines', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'VCT', '670', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SX', 'Sint Maarten (Dutch part)', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'SXM', '534', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'TT', 'Trinidad and Tobago', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'TTO', '780', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'TC', 'Turks and Caicos Islands', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'TCA', '796', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'VI', 'United States Virgin Islands', 'Americas', 'Latin America and the Caribbean', 'Caribbean',
        'VIR', '850', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BZ', 'Belize', 'Americas', 'Latin America and the Caribbean', 'Central America',
        'BLZ', '084', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CR', 'Costa Rica', 'Americas', 'Latin America and the Caribbean', 'Central America',
        'CRI', '188', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SV', 'El Salvador', 'Americas', 'Latin America and the Caribbean', 'Central America',
        'SLV', '222', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GT', 'Guatemala', 'Americas', 'Latin America and the Caribbean', 'Central America',
        'GTM', '320', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'HN', 'Honduras', 'Americas', 'Latin America and the Caribbean', 'Central America',
        'HND', '340', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MX', 'Mexico', 'Americas', 'Latin America and the Caribbean', 'Central America',
        'MEX', '484', 0, 0, 0, 'MXN',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'NI', 'Nicaragua', 'Americas', 'Latin America and the Caribbean', 'Central America',
        'NIC', '558', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'PA', 'Panama', 'Americas', 'Latin America and the Caribbean', 'Central America',
        'PAN', '591', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'AR', 'Argentina', 'Americas', 'Latin America and the Caribbean', 'South America',
        'ARG', '032', 0, 0, 0, 'ARS',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BO', 'Bolivia (Plurinational State of)', 'Americas', 'Latin America and the Caribbean', 'South America',
        'BOL', '068', 0, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BV', 'Bouvet Island', 'Americas', 'Latin America and the Caribbean', 'South America',
        'BVT', '074', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BR', 'Brazil', 'Americas', 'Latin America and the Caribbean', 'South America',
        'BRA', '076', 0, 0, 0, 'BRL',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CL', 'Chile', 'Americas', 'Latin America and the Caribbean', 'South America',
        'CHL', '152', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CO', 'Colombia', 'Americas', 'Latin America and the Caribbean', 'South America',
        'COL', '170', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'EC', 'Ecuador', 'Americas', 'Latin America and the Caribbean', 'South America',
        'ECU', '218', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'FK', 'Falkland Islands (Malvinas)', 'Americas', 'Latin America and the Caribbean', 'South America',
        'FLK', '238', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GF', 'French Guiana', 'Americas', 'Latin America and the Caribbean', 'South America',
        'GUF', '254', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GY', 'Guyana', 'Americas', 'Latin America and the Caribbean', 'South America',
        'GUY', '328', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'PY', 'Paraguay', 'Americas', 'Latin America and the Caribbean', 'South America',
        'PRY', '600', 0, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'PE', 'Peru', 'Americas', 'Latin America and the Caribbean', 'South America',
        'PER', '604', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GS', 'South Georgia and the South Sandwich Islands', 'Americas', 'Latin America and the Caribbean', 'South America',
        'SGS', '239', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SR', 'Suriname', 'Americas', 'Latin America and the Caribbean', 'South America',
        'SUR', '740', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'UY', 'Uruguay', 'Americas', 'Latin America and the Caribbean', 'South America',
        'URY', '858', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'VE', 'Venezuela (Bolivarian Republic of)', 'Americas', 'Latin America and the Caribbean', 'South America',
        'VEN', '862', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BM', 'Bermuda', 'Americas', 'Northern America', '',
        'BMU', '060', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CA', 'Canada', 'Americas', 'Northern America', '',
        'CAN', '124', 0, 0, 0, 'CAD',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GL', 'Greenland', 'Americas', 'Northern America', '',
        'GRL', '304', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'PM', 'Saint Pierre and Miquelon', 'Americas', 'Northern America', '',
        'SPM', '666', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'US', 'United States of America', 'Americas', 'Northern America', '',
        'USA', '840', 0, 0, 0, 'USD',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'AQ', 'Antarctica', '', '', '',
        'ATA', '010', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'KZ', 'Kazakhstan', 'Asia', 'Central Asia', '',
        'KAZ', '398', 0, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'KG', 'Kyrgyzstan', 'Asia', 'Central Asia', '',
        'KGZ', '417', 0, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'TJ', 'Tajikistan', 'Asia', 'Central Asia', '',
        'TJK', '762', 0, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'TM', 'Turkmenistan', 'Asia', 'Central Asia', '',
        'TKM', '795', 0, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'UZ', 'Uzbekistan', 'Asia', 'Central Asia', '',
        'UZB', '860', 0, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CN', 'China', 'Asia', 'Eastern Asia', '',
        'CHN', '156', 0, 0, 0, 'CNY',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'HK', 'China, Hong Kong Special Administrative Region', 'Asia', 'Eastern Asia', '',
        'HKG', '344', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MO', 'China, Macao Special Administrative Region', 'Asia', 'Eastern Asia', '',
        'MAC', '446', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'KP', 'Democratic People''s Republic of Korea', 'Asia', 'Eastern Asia', '',
        'PRK', '408', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'JP', 'Japan', 'Asia', 'Eastern Asia', '',
        'JPN', '392', 0, 0, 0, 'JPY',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MN', 'Mongolia', 'Asia', 'Eastern Asia', '',
        'MNG', '496', 0, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'KR', 'Republic of Korea', 'Asia', 'Eastern Asia', '',
        'KOR', '410', 0, 0, 0, 'KRW',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BN', 'Brunei Darussalam', 'Asia', 'South-eastern Asia', '',
        'BRN', '096', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'KH', 'Cambodia', 'Asia', 'South-eastern Asia', '',
        'KHM', '116', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'ID', 'Indonesia', 'Asia', 'South-eastern Asia', '',
        'IDN', '360', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'LA', 'Lao People''s Democratic Republic', 'Asia', 'South-eastern Asia', '',
        'LAO', '418', 1, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MY', 'Malaysia', 'Asia', 'South-eastern Asia', '',
        'MYS', '458', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MM', 'Myanmar', 'Asia', 'South-eastern Asia', '',
        'MMR', '104', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'PH', 'Philippines', 'Asia', 'South-eastern Asia', '',
        'PHL', '608', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SG', 'Singapore', 'Asia', 'South-eastern Asia', '',
        'SGP', '702', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'TH', 'Thailand', 'Asia', 'South-eastern Asia', '',
        'THA', '764', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'TL', 'Timor-Leste', 'Asia', 'South-eastern Asia', '',
        'TLS', '626', 1, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'VN', 'Viet Nam', 'Asia', 'South-eastern Asia', '',
        'VNM', '704', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'AF', 'Afghanistan', 'Asia', 'Southern Asia', '',
        'AFG', '004', 1, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BD', 'Bangladesh', 'Asia', 'Southern Asia', '',
        'BGD', '050', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BT', 'Bhutan', 'Asia', 'Southern Asia', '',
        'BTN', '064', 0, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'IN', 'India', 'Asia', 'Southern Asia', '',
        'IND', '356', 0, 0, 0, 'INR',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'IR', 'Iran (Islamic Republic of)', 'Asia', 'Southern Asia', '',
        'IRN', '364', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MV', 'Maldives', 'Asia', 'Southern Asia', '',
        'MDV', '462', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'NP', 'Nepal', 'Asia', 'Southern Asia', '',
        'NPL', '524', 1, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'PK', 'Pakistan', 'Asia', 'Southern Asia', '',
        'PAK', '586', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'LK', 'Sri Lanka', 'Asia', 'Southern Asia', '',
        'LKA', '144', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'AM', 'Armenia', 'Asia', 'Western Asia', '',
        'ARM', '051', 0, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'AZ', 'Azerbaijan', 'Asia', 'Western Asia', '',
        'AZE', '031', 0, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BH', 'Bahrain', 'Asia', 'Western Asia', '',
        'BHR', '048', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CY', 'Cyprus', 'Asia', 'Western Asia', '',
        'CYP', '196', 0, 0, 0, 'XXX',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GE', 'Georgia', 'Asia', 'Western Asia', '',
        'GEO', '268', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'IQ', 'Iraq', 'Asia', 'Western Asia', '',
        'IRQ', '368', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'IL', 'Israel', 'Asia', 'Western Asia', '',
        'ISR', '376', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'JO', 'Jordan', 'Asia', 'Western Asia', '',
        'JOR', '400', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'KW', 'Kuwait', 'Asia', 'Western Asia', '',
        'KWT', '414', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'LB', 'Lebanon', 'Asia', 'Western Asia', '',
        'LBN', '422', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'OM', 'Oman', 'Asia', 'Western Asia', '',
        'OMN', '512', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'QA', 'Qatar', 'Asia', 'Western Asia', '',
        'QAT', '634', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SA', 'Saudi Arabia', 'Asia', 'Western Asia', '',
        'SAU', '682', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'PS', 'State of Palestine', 'Asia', 'Western Asia', '',
        'PSE', '275', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SY', 'Syrian Arab Republic', 'Asia', 'Western Asia', '',
        'SYR', '760', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'TR', 'Türkiye', 'Asia', 'Western Asia', '',
        'TUR', '792', 0, 0, 0, 'TRY',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'AE', 'United Arab Emirates', 'Asia', 'Western Asia', '',
        'ARE', '784', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'YE', 'Yemen', 'Asia', 'Western Asia', '',
        'YEM', '887', 1, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BY', 'Belarus', 'Europe', 'Eastern Europe', '',
        'BLR', '112', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BG', 'Bulgaria', 'Europe', 'Eastern Europe', '',
        'BGR', '100', 0, 0, 0, 'BGN',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CZ', 'Czechia', 'Europe', 'Eastern Europe', '',
        'CZE', '203', 0, 0, 0, 'CZK',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'HU', 'Hungary', 'Europe', 'Eastern Europe', '',
        'HUN', '348', 0, 0, 0, 'HUF',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'PL', 'Poland', 'Europe', 'Eastern Europe', '',
        'POL', '616', 0, 0, 0, 'PLN',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MD', 'Republic of Moldova', 'Europe', 'Eastern Europe', '',
        'MDA', '498', 0, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'RO', 'Romania', 'Europe', 'Eastern Europe', '',
        'ROU', '642', 0, 0, 0, 'RON',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'RU', 'Russian Federation', 'Europe', 'Eastern Europe', '',
        'RUS', '643', 0, 0, 0, 'RUB',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SK', 'Slovakia', 'Europe', 'Eastern Europe', '',
        'SVK', '703', 0, 0, 0, 'XXX',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'UA', 'Ukraine', 'Europe', 'Eastern Europe', '',
        'UKR', '804', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'AX', 'Åland Islands', 'Europe', 'Northern Europe', '',
        'ALA', '248', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'DK', 'Denmark', 'Europe', 'Northern Europe', '',
        'DNK', '208', 0, 0, 0, 'DKK',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'EE', 'Estonia', 'Europe', 'Northern Europe', '',
        'EST', '233', 0, 0, 0, 'XXX',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'FO', 'Faroe Islands', 'Europe', 'Northern Europe', '',
        'FRO', '234', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'FI', 'Finland', 'Europe', 'Northern Europe', '',
        'FIN', '246', 0, 0, 0, 'XXX',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GG', 'Guernsey', 'Europe', 'Northern Europe', '',
        'GGY', '831', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'IS', 'Iceland', 'Europe', 'Northern Europe', '',
        'ISL', '352', 0, 0, 0, 'XXX',
        0, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'IE', 'Ireland', 'Europe', 'Northern Europe', '',
        'IRL', '372', 0, 0, 0, 'XXX',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'IM', 'Isle of Man', 'Europe', 'Northern Europe', '',
        'IMN', '833', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'JE', 'Jersey', 'Europe', 'Northern Europe', '',
        'JEY', '832', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'LV', 'Latvia', 'Europe', 'Northern Europe', '',
        'LVA', '428', 0, 0, 0, 'XXX',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'LT', 'Lithuania', 'Europe', 'Northern Europe', '',
        'LTU', '440', 0, 0, 0, 'XXX',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'NO', 'Norway', 'Europe', 'Northern Europe', '',
        'NOR', '578', 0, 0, 0, 'NOK',
        0, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SJ', 'Svalbard and Jan Mayen Islands', 'Europe', 'Northern Europe', '',
        'SJM', '744', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SE', 'Sweden', 'Europe', 'Northern Europe', '',
        'SWE', '752', 0, 0, 0, 'SEK',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GB', 'United Kingdom of Great Britain and Northern Ireland', 'Europe', 'Northern Europe', '',
        'GBR', '826', 0, 0, 0, 'GBP',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'AL', 'Albania', 'Europe', 'Southern Europe', '',
        'ALB', '008', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'AD', 'Andorra', 'Europe', 'Southern Europe', '',
        'AND', '020', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BA', 'Bosnia and Herzegovina', 'Europe', 'Southern Europe', '',
        'BIH', '070', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'HR', 'Croatia', 'Europe', 'Southern Europe', '',
        'HRV', '191', 0, 0, 0, 'XXX',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GI', 'Gibraltar', 'Europe', 'Southern Europe', '',
        'GIB', '292', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GR', 'Greece', 'Europe', 'Southern Europe', '',
        'GRC', '300', 0, 0, 0, 'XXX',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'VA', 'Holy See', 'Europe', 'Southern Europe', '',
        'VAT', '336', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'IT', 'Italy', 'Europe', 'Southern Europe', '',
        'ITA', '380', 0, 0, 0, 'XXX',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MT', 'Malta', 'Europe', 'Southern Europe', '',
        'MLT', '470', 0, 0, 0, 'XXX',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'ME', 'Montenegro', 'Europe', 'Southern Europe', '',
        'MNE', '499', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MK', 'North Macedonia', 'Europe', 'Southern Europe', '',
        'MKD', '807', 0, 1, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'PT', 'Portugal', 'Europe', 'Southern Europe', '',
        'PRT', '620', 0, 0, 0, 'XXX',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SM', 'San Marino', 'Europe', 'Southern Europe', '',
        'SMR', '674', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'RS', 'Serbia', 'Europe', 'Southern Europe', '',
        'SRB', '688', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SI', 'Slovenia', 'Europe', 'Southern Europe', '',
        'SVN', '705', 0, 0, 0, 'XXX',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'ES', 'Spain', 'Europe', 'Southern Europe', '',
        'ESP', '724', 0, 0, 0, 'XXX',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'AT', 'Austria', 'Europe', 'Western Europe', '',
        'AUT', '040', 0, 0, 0, 'XXX',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'BE', 'Belgium', 'Europe', 'Western Europe', '',
        'BEL', '056', 0, 0, 0, 'XXX',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'FR', 'France', 'Europe', 'Western Europe', '',
        'FRA', '250', 0, 0, 0, 'EUR',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'DE', 'Germany', 'Europe', 'Western Europe', '',
        'DEU', '276', 0, 0, 0, 'EUR',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'LI', 'Liechtenstein', 'Europe', 'Western Europe', '',
        'LIE', '438', 0, 0, 0, 'XXX',
        0, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'LU', 'Luxembourg', 'Europe', 'Western Europe', '',
        'LUX', '442', 0, 0, 0, 'XXX',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MC', 'Monaco', 'Europe', 'Western Europe', '',
        'MCO', '492', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'NL', 'Netherlands (Kingdom of the)', 'Europe', 'Western Europe', '',
        'NLD', '528', 0, 0, 0, 'EUR',
        1, 1, 1, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CH', 'Switzerland', 'Europe', 'Western Europe', '',
        'CHE', '756', 0, 0, 0, 'CHF',
        0, 0, 0, 1
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'AU', 'Australia', 'Oceania', 'Australia and New Zealand', '',
        'AUS', '036', 0, 0, 0, 'AUD',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CX', 'Christmas Island', 'Oceania', 'Australia and New Zealand', '',
        'CXR', '162', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CC', 'Cocos (Keeling) Islands', 'Oceania', 'Australia and New Zealand', '',
        'CCK', '166', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'HM', 'Heard Island and McDonald Islands', 'Oceania', 'Australia and New Zealand', '',
        'HMD', '334', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'NZ', 'New Zealand', 'Oceania', 'Australia and New Zealand', '',
        'NZL', '554', 0, 0, 0, 'NZD',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'NF', 'Norfolk Island', 'Oceania', 'Australia and New Zealand', '',
        'NFK', '574', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'FJ', 'Fiji', 'Oceania', 'Melanesia', '',
        'FJI', '242', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'NC', 'New Caledonia', 'Oceania', 'Melanesia', '',
        'NCL', '540', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'PG', 'Papua New Guinea', 'Oceania', 'Melanesia', '',
        'PNG', '598', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'SB', 'Solomon Islands', 'Oceania', 'Melanesia', '',
        'SLB', '090', 1, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'VU', 'Vanuatu', 'Oceania', 'Melanesia', '',
        'VUT', '548', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'GU', 'Guam', 'Oceania', 'Micronesia', '',
        'GUM', '316', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'KI', 'Kiribati', 'Oceania', 'Micronesia', '',
        'KIR', '296', 1, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MH', 'Marshall Islands', 'Oceania', 'Micronesia', '',
        'MHL', '584', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'FM', 'Micronesia (Federated States of)', 'Oceania', 'Micronesia', '',
        'FSM', '583', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'NR', 'Nauru', 'Oceania', 'Micronesia', '',
        'NRU', '520', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'MP', 'Northern Mariana Islands', 'Oceania', 'Micronesia', '',
        'MNP', '580', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'PW', 'Palau', 'Oceania', 'Micronesia', '',
        'PLW', '585', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'UM', 'United States Minor Outlying Islands', 'Oceania', 'Micronesia', '',
        'UMI', '581', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'AS', 'American Samoa', 'Oceania', 'Polynesia', '',
        'ASM', '016', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'CK', 'Cook Islands', 'Oceania', 'Polynesia', '',
        'COK', '184', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'PF', 'French Polynesia', 'Oceania', 'Polynesia', '',
        'PYF', '258', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'NU', 'Niue', 'Oceania', 'Polynesia', '',
        'NIU', '570', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'PN', 'Pitcairn', 'Oceania', 'Polynesia', '',
        'PCN', '612', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'WS', 'Samoa', 'Oceania', 'Polynesia', '',
        'WSM', '882', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'TK', 'Tokelau', 'Oceania', 'Polynesia', '',
        'TKL', '772', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'TO', 'Tonga', 'Oceania', 'Polynesia', '',
        'TON', '776', 0, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'TV', 'Tuvalu', 'Oceania', 'Polynesia', '',
        'TUV', '798', 1, 0, 1, 'XXX',
        0, 0, 0, 0
    );
    INSERT INTO stg.fixed_countrylist (
        country_code, country_name, region_name, subregion_name, intermediate_region_name,
        iso_alpha3, m49_code, is_ldc, is_lldc, is_sids, currency_code,
        is_in_eu, is_in_eea, is_in_eu_roaming, gdpr_applicable
    ) VALUES (
        'WF', 'Wallis and Futuna Islands', 'Oceania', 'Polynesia', '',
        'WLF', '876', 0, 0, 0, 'XXX',
        0, 0, 0, 0
    );

-- select  * from stg.fixed_countrylist where 1=1 and country_code = 'NA'
END