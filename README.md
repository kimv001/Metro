# Metro Data Warehouse Documentation

## Overview

Metro is a Data Warehouse Generator. Define your sources and transformations, and let Metro handle the rest! It is designed to manage metadata for creating and maintaining a data warehouse. It focuses on defining datasets, templates, schedules, and deployment scripts to automate the generation of data warehouse objects and processes.

## Features

- Metadata-driven data warehouse generation
- Support for various data sources (Files, APIs, Tables)
- Transformation views and export definitions
- Data quality and testing rules
- Integration with Azure Data Factory (ADF)

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [How Metro Works](#how-metro-works)
- [Transformation Views](#transformation-views)
- [Stored Procedures](#stored-procedures)
- [Example Usage](#example-usage)
- [License](#license)
- [Contact](#contact)

## Introduction

Metro supports the development and processing of a metadata-driven data warehouse. It automates the creation and management of data warehouses by defining sources and transformations through an Excel sheet.

Currently, Metro is populated via an Excel sheet, which includes the following:

- **AliasViews**: Dataset to create alias views on dimensions.
- **Bucket**: Buckets can be part of the short name of datasets in the publication layer.
- **DatasetSrc**: All source datasets (Files, APIs, Tables).
- **DatasetSrcAttribute**: Attributes of source datasets.
- **DatasetSrcFileFormat**: Characteristics of each source file type (headers, encoding type, compression, etc.).
- **DatasetSrcFileProperties**: Information about the source file location, name, file mask, and date in the filename.
- **DatasetTrn**: Transformation views considered as sources in Metro, defining the name, flow, and attributes.
- **DatasetTrnAttribute**: Attributes of transformation views.
- **DatasetSto_inprogress**: Export definitions.
- **TestDefinition**: Test rules.
- **DataSource**: Technical definition of the source system.
- **DataSourceProperties**: Various properties of a datasource defined per environment.
- **DataTypeMapping**: Mapping different datasources to Metro-defined data types.
- **DefaultDatasetView**: Define default views such as staging views for tables in the schema [stg].
- **Flow**: Define "default" data flows (e.g., "SRC_File" → "Staging Table" → "Persistent Staging Table").
- **FlowLayer**: Definition of the actual flow (load pattern).
- **Group**: Grouping sets of datasets, mandatory for defining source and transformation datasets.
- **Layer**: Define the purpose of a datasource schema (source, DWH, target system).
- **LinkedService**: Required for connecting to source or target systems with ADF.
- **LinkedServiceProperties**: Store the name of the ADF linked service.
- **Marker**: Snippets used to store repetitive code pieces in templates, requiring rebuild if adjusted due to database dependencies.
- **MtaAttribute**: Default meta attributes for datasets (e.g., "mta_loadDate", "mta_source") defined per schema and object type.
- **RefType**: Dropdown selections used across various tabs, such as ObjectType, DataType, RepositoryStatus.
- **Schedule**: Define schedules (e.g., every Monday at 08:00).
- **Schedules**: Define what to load with which schedule.
- **SchedulesDependencies**: Specify dependencies between schedules.
- **Schema**: Define the schema for datasets, acting as a layer between the dataset and datasource.
- **Segment**: Organizational grouping of publication tables.
- **Setting**: General Metro repository settings for later use in the Metro database.
- **Template**: Define create and load statements generically, generating all project code from these templates to improve code quality.
- **Contact**: List of contact persons for issues.
- **ContactGroup**: Groups assigned to datasets (logistics, supplier, etc.).
- **ContactPerson**: Persons included in contact groups.
- **XlsTabsToLoad**: Define tabs and target tables in Metro, with options to drop and reload tables.
- **Metro2DM**: Datasets pushed from Metro to the DWH, used as reference sets for ADF.
- **InformationSchema**: Extract metadata from DWH or defined sources (currently only DWH metadata).

## Installation

### Prerequisites

## How Metro Works

The Excel tabs mentioned above are loaded one-to-one into tables in the schema [stg].

The stored procedure [010_rep_Recreate_RepViews](metro/rep/Stored Procedures/010_rep_Recreate_RepViews.sql) generates staging views on these tables. In these views, rows are filtered based on the field `Active` and whether the field `BK` is not null.

Transformation views are defined on these staging views in the [bld] schema. These views contain the logic to prepare the metadata so that scripts can be generated later.

Due to the naming convention of the transformation views, the stored procedure [023_bld_Recreate_LoadProcs](metro/bld/Stored Procedures/023_bld_Recreate_LoadProcs.sql) creates procedures to generate so-called build tables. It is possible that more than one transformation view populates a single build table. An example of this is: [tr_100_Dataset_010_DatasetSrc](metro/bld/Views/tr_100_Dataset_010_DatasetSrc.sql) (where the defined source datasets are first "built") and the transformation view [tr_100_Dataset_011_DatasetSrcFlowDatasets](metro/bld/Views/tr_100_Dataset_011_DatasetSrcFlowDatasets.sql) determines which additional datasets need to be created based on the associated flow. For example, each source file gets a staging table and a persistent staging table.

The build tables (and views) are generated based on the defined transformation views. The procedure [020_bld_create](metro/rep/Stored Procedures/020_bld_create.sql) creates the tables, views, and stored procedures.

The processing and building of the scripts are initiated by the procedure [050_bld_load](metro/rep/Stored Procedures/050_bld_load.sql). This procedure processes all build procedures. All objects are then ready to create the scripts. The final step in this load procedure is the procedure [069_bld_CreateDeployScripts](metro/rep/Stored Procedures/069_bld_CreateDeployScripts.sql). This last step ensures that all linked and defined templates are populated.

All ADF tables and views are used to copy the metadata to the Data Warehouse target environment.

## Transformation Views

### tr_010_RefType_010_Default
- **Description:** Provides default reference type definitions used across the data warehouse.
- **Source Data:** 
  - [rep].[vw_RefType]

### tr_020_ContactGroup_010_Default
- **Description:** Provides default contact group definitions.
- **Source Data:** 
  - [rep].[vw_ContactGroup]

### tr_025_Contact_010_Default
- **Description:** Provides default contact definitions.
- **Source Data:** 
  - [rep].[vw_Contact]

### tr_050_Schema_010_Default
- **Description:** Provides default schema definitions.
- **Source Data:** 
  - [rep].[vw_Schema]

### tr_060_Layer_010_Default
- **Description:** Provides default layer definitions.
- **Source Data:** 
  - [rep].[vw_Layer]

### tr_075_Flow_010_Default
- **Description:** Provides default flow definitions.
- **Source Data:** 
  - [rep].[vw_Flow]

### tr_100_Dataset_010_DatasetSrc
- **Description:** Provides default dataset source definitions.
- **Source Data:** 
  - [rep].[vw_DatasetSrc]

### tr_100_Dataset_011_DatasetSrcFlowDatasets
- **Description:** Determines additional datasets to be created based on the associated flow.
- **Source Data:** 
  - [rep].[vw_DatasetSrc]
  - [rep].[vw_Flow]

### tr_100_Dataset_020_DatasetTrn
- **Description:** Provides default transformation dataset definitions.
- **Source Data:** 
  - [rep].[vw_DatasetTrn]

### tr_100_Dataset_021_DatasetTrnFlowDatasets
- **Description:** Determines additional transformation datasets to be created based on the associated flow.
- **Source Data:** 
  - [rep].[vw_DatasetTrn]
  - [rep].[vw_Flow]

### tr_100_Dataset_030_AddDefaultViews
- **Description:** Adds default views for datasets.
- **Source Data:** 
  - [rep].[vw_Dataset]

### tr_100_Dataset_035_CustomStagingViews
- **Description:** Adds custom staging views for datasets.
- **Source Data:** 
  - [rep].[vw_Dataset]

### tr_100_Dataset_040_AliasViews
- **Description:** Adds alias views for datasets.
- **Source Data:** 
  - [rep].[vw_Dataset]

### tr_110_FileProperties_010_DatasetSrc
- **Description:** Provides default file property definitions for source datasets.
- **Source Data:** 
  - [rep].[vw_FileProperties]

### tr_150_DataTypesBySchema_010_allschemas
- **Description:** Provides data type definitions by schema.
- **Source Data:** 
  - [rep].[vw_DataTypesBySchema]

### tr_200_Attribute_010_DatasetSrcAttributes
- **Description:** Provides default attribute definitions for source datasets.
- **Source Data:** 
  - [rep].[vw_Attribute]

### tr_200_Attribute_020_DatasetTrnAttributes
- **Description:** Provides default attribute definitions for transformation datasets.
- **Source Data:** 
  - [rep].[vw_Attribute]

### tr_210_AttributeSmartLoad_010_Default
- **Description:** Provides default attribute definitions for smart load.
- **Source Data:** 
  - [rep].[vw_AttributeSmartLoad]

### tr_230_Attribute_030_AddMtaAttributes
- **Description:** Adds default meta attributes for datasets.
- **Source Data:** 
  - [rep].[vw_Attribute]

### tr_300_TestRules_010_Datasets
- **Description:** Provides test rules for datasets.
- **Source Data:** 
  - [rep].[vw_TestRules]

### tr_350_Exports_010_default
- **Description:** Provides default export definitions.
- **Source Data:** 
  - [rep].[vw_Exports]

### tr_400_DatasetDependency_010_SrcToTgt
- **Description:** Provides dataset dependencies from source to target.
- **Source Data:** 
  - [rep].[vw_DatasetDependency]

### tr_400_DatasetDependency_030_TransformationViewsDWH
- **Description:** Provides transformation view dependencies for the data warehouse.
- **Source Data:** 
  - [rep].[vw_DatasetDependency]

### tr_420_LoadDependency_010_SrcToTgt
- **Description:** Provides load dependencies from source to target.
- **Source Data:** 
  - [rep].[vw_LoadDependency]

### tr_450_LoadDependency_010_TgtFromSrc
- **Description:** Provides load dependencies from target to source.
- **Source Data:** 
  - [rep].[vw_LoadDependency]

### tr_500_MarkersSmartLoad_010_Default
- **Description:** Provides default marker definitions for smart load.
- **Source Data:** 
  - [rep].[vw_MarkersSmartLoad]

### tr_510_Markers_010_SystemMarkers
- **Description:** Provides system marker definitions.
- **Source Data:** 
  - [rep].[vw_Markers]

### tr_510_Markers_020_DatasetTarget
- **Description:** Creates dataset markers for target datasets. These markers are used to dynamically replace values in templates based on the dataset configurations.
- **Source Data:** 
  - [bld].[vw_Dataset]
  - [bld].[vw_FileProperties]
  - [bld].[vw_Attribute]

### tr_510_Markers_025_DatasetSRCFileProperties
- **Description:** Creates dataset markers for source file properties. These markers are used to dynamically replace values in templates based on the file properties of the source datasets.
- **Source Data:** 
  - [bld].[vw_Dataset]
  - [bld].[vw_FileProperties]
  - [bld].[vw_Attribute]

### tr_510_Markers_030_DatasetColumnlistsByDataset
- **Description:** Creates dataset markers unique by dataset. Mostly when all columns or all MTA columns are selected.
- **Source Data:** 
  - [bld].[vw_Dataset]
  - [bld].[vw_Attribute]

### tr_510_Markers_040_DatasetColumnlistsByCode
- **Description:** Creates dataset markers unique by code. These markers are used to dynamically replace values in templates based on the column lists of the datasets.
- **Source Data:** 
  - [bld].[vw_Dataset]
  - [bld].[vw_Attribute]
  - [bld].[vw_MarkersSmartLoad]

### tr_550_Schedule_010_default
- **Description:** Builds up the default schedule definitions. It provides detailed information about schedules, including their types, frequencies, and intervals.
- **Source Data:** 
  - [rep].[vw_Schedule]
  - [rep].[vw_RefType]

### tr_560_Schedules_010_default
- **Description:** Builds up the default schedule definitions for all datasets and specific transactional datasets. It provides detailed information about schedules, including their groups, dependencies, and target datasets to load.
- **Source Data:** 
  - [rep].[vw_Schedules]

### tr_600_Template_010_Default
- **Description:** Builds up the default template definitions. It provides detailed information about templates, including their types, object types, and script languages. This data is crucial for generating neat and structured code.
- **Source Data:** 
  - [rep].[vw_Template]
  - [rep].[vw_RefType]

### tr_650_DatasetTemplates_010_default
- **Description:** Builds up the default dataset template definitions. It provides detailed information about which templates need to be filled in for which data warehouse objects.
- **Source Data:** 
  - [bld].[vw_Dataset]
  - [bld].[vw_Template]
  - [bld].[vw_Schema]
  - [rep].[vw_FlowLayer]

### tr_655_DWHRefTemplates_010_default
- **Description:** Builds up the default template definitions for Data Warehouse Reference (DWH Ref) objects. It provides detailed information about which templates need to be filled in for which data warehouse reference objects.
- **Source Data:** 
  - [bld].[vw_Template]
  - [bld].[vw_RefType]

### tr_700_BuildCheck_010_dataset
- **Description:** Performs various checks on datasets to ensure they meet the required criteria before template generation.
- **Source Data:** 
  - [bld].[vw_Dataset]
  - [bld].[vw_FileProperties]
  - [bld].[vw_Attribute]

### tr_800_DeployScriptsSmartLoad_010_Sources
- **Description:** Detects changes in the `bld` tables ([bld].[Markers], [bld].[DatasetTemplates], or [bld].[Template]) on which the `bld.DeployScripts` are dependent. When a change is detected, the code of the full set will be returned.
- **Source Data:** 
  - [bld].[vw_Markers]
  - [bld].[vw_DatasetTemplates]
  - [bld].[vw_Template]

### tr_900_DeployScripts_010_MetroProcedure
- **Description:** Defines the structure for the `bld.DeployScripts` table. It specifies the columns and their data types but does not contain any actual data.
- **Source Data:** 
  - This view does not pull data from any source views. It is intended to define the structure for the `bld.DeployScripts` table.

## Stored Procedures

The stored procedures in the `rep` schema handle various tasks related to template generation and deployment. They ensure that the templates are correctly filled and deployed based on the defined schedules and dataset configurations. Here are some key stored procedures:

1. **010_rep_Recreate_RepViews**
   - **Description:** Generates staging views on the tables in the schema [stg]. Rows are filtered based on the field `Active` and whether the field `BK` is not null.

2. **020_bld_create**
   - **Description:** Creates the tables, views, and stored procedures based on the defined transformation views.

3. **023_bld_Recreate_LoadProcs**
   - **Description:** Creates procedures to generate build tables based on the transformation views.

4. **050_bld_load**
   - **Description:** Processes all build procedures and prepares objects for script creation.

5. **069_bld_CreateDeployScripts**
   - **Description:** Ensures that all linked and defined templates are populated and ready for deployment.

## Example Usage

When the steps above are done you can generate code. This example script will generate all scripts needed for staging tables:

```sql
exec [rep].[100_Publish_DeployScriptsToScreen]
    @TGT_ObjectName    = ''
    , @LayerName        = ''
    , @SchemaName       = 'stg'
    , @GroupName        = 'adventureworks'
    , @ShortName        = ''
    , @DeployDatasets   = 1
    , @DeployMappings   = 1
    , @ObjectType       = 'table'
    , @IgnoreErrors     = 0

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For any questions or issues, please contact the project maintainers at [kim@businesskey.nl](mailto:kim@businesskey.nl).