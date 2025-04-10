# Athena Output Port Template

This documentation describes the details and parameters required to create an Athena Output Port within the Witboost platform.

### Prerequisites

A `Data Product` must already exist in order to attach the new components to it.

Additionally, an `AWS S3 Storage component` must be present and referenced as a dependency of the output port. This storage is required to store the results of Athena queries.
Declaring the storage as a dependency ensures that components are provisioned in the correct order — with the storage being available before the output port is created.

### Component Basic Information

This section includes the basic information that any Component of Witboost must have:

- **Name**: Required name used for display purposes on your Data Product.
- **Description**: A short description to help others understand what this Output Port is for.
- **Domain**: The domain of the Data Product this Output Port belongs to. Be sure to choose it correctly as it is a fundamental part of the Output Port and cannot be changed afterwards.
- **Data Product**: The Data Product this Output Port belongs to; be sure to choose the right one.
- **Identifier**: Unique ID for this new entity inside the domain. It will be automatically filled for you.
- **Development group**: Development group of this Data Product. It will be automatically filled for you.
- **Storage Area**: The AWS S3 Storage component dependency used as the query output location.
- **Depends on**: If you want your Output Port to depend on other components from the Data Product, you can choose this option (Optional).

*Example:*

| Field name            | Example value                                                                                          |
|-----------------------|--------------------------------------------------------------------------------------------------------|
| **Name**              | Athena Output Port                                                                                     |
| **Description**       | Output Port that exposes information of this Data Product to users and other data products.            |
| **Domain**            | domain:finance                                                                                         |
| **Data Product**      | system:finance.tradingdp.0                                                                             |
| **Identifier**        | Will look something like this: *finance.trading.0.athena-output-port*                                  |
| **Development Group** | Might look something like this: *group:datameshplatform* Depends on the Data Product development group |
| **Storage Area**      | urn:dmb:cmp:finance:tradingdp:0:s3-storage-area                                                        |
| **Depends on**      | \[urn:dmb:cmp:finance:tradingdp:0:s3-storage-area, urn:dmb:cmp:finance:tradingdp:0:glue-job-1\]        |

### Data Contract Schema

This section defines the schema of the data that will be exposed through the Athena view.

- **Table Format**: Specifies the table format to use. Currently, only `ICEBERG` is supported.
- **Column Definitions**: Defines the schema for the Athena view, including column names, descriptions, and data types. If the source table does not exist, this schema will also be used to create it.

*Example:*

| **Column Name** | **Description**      | **Data Type** | 
|-----------------|----------------------|---------------|
| id              | Unique identifier    | INT           | 
| name            | Name of the entity   | STRING        | 
| created_at      | Creation timestamp   | TIMESTAMP     |
| status          | Status of the record | VARCHAR       |

### Supported Data Types

The table below lists the data types and their support status.

| **Data Type** | **ICEBERG Support** |
|---------------|---------------------|
| BOOLEAN       | ✅                   |
| TINYINT       | ❌                   |
| SMALLINT      | ❌                   |
| INT           | ✅                   |
| BIGINT        | ✅                   |
| DOUBLE        | ✅                   |
| FLOAT         | ✅                   |
| DECIMAL       | ✅                   |
| CHAR          | ❌                   |
| VARCHAR       | ❌                   |
| STRING        | ✅                   |
| BINARY        | ✅                   |
| DATE          | ✅                   |
| TIMESTAMP     | ✅                   |
| TIMESTAMPTZ   | ✅                   |
| ARRAY         | ✅                   |
| MAP           | ✅                   |

### Data Quality constraints
This section allows you to add Sifflet monitors linked to the output port.
Remember to also add a Sifflet workload to the Data Product, and to include this Output Port as a dependency in order to create the defined monitors on Sifflet.

*Example:*

| **Name**      | **Description**                   | **Severity** | **Monitor Type**    | **Null values** | **Field** | **Threshold** |
|---------------|-----------------------------------|--------------|---------------------|-----------------|-----------|---------------|
| Id Not Null   | Not null constraint for id column | Critical     | Nulls               | NullAndEmpty    | id        | 15%           |
| Unique Name   | Unique name column                | Low          | Unique              | -               | name      | -             |
| No changes    | Schema change monitor             | Moderate     | Schema change       | -               | -         | -             |
| No duplicates | Duplicate rows                    | High         | Row level duplicate | -               | -         | 5%            |



### Output Port Deployment Information

This section provides details about the deployment of the Output Port.

- **Source Table Name**: Name of the source table that will be used to create the Athena view.

*Example:*

| **Field Name**           | **Value**       |
|--------------------------|-----------------|
| **Source Table Name**    | source_table    |

### Deployment Process

After this, the system will show you the summary of the template, and you can go back and edit or go ahead and create the Component.

After clicking on "Create" the registering of the Component will start. If no errors occur, it will go through the 3 phases (Fetching, Publishing, and Registering) and will provide you with links to the newly created Repository and the component in the Catalog.

**Be careful not to delete the `catalog-info.yml` and ensure that the project structure remains as given.**

