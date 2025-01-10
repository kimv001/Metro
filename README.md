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
- [Usage](#usage)
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

### Steps

## Usage

### Example Usage
