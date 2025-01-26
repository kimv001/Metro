# Metro
Metro is a Data Warehouse Generator. Define your sources and transformations, and let Metro handle the rest!

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
- [How Metro Works](#How Metro Works)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Introduction
Metro supports the development and processing of a metadata-driven data warehouse. It automates the creation and management of data warehouses by defining sources and transformations through an Excel sheet.

Metro supports the development and processing of a metadata-driven data warehouse.

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

## Example usage
When the steps above are done you can generate code. 
This example script will generate all scripts needed for staging tables:
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
```

## License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.

## Contact

For any questions or issues, please contact the project maintainers at [kim@businesskey.nl](mailto:kim@businesskey.nl).
