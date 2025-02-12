# Athena Output Port Template

This documentation describes the details and parameters required to create an Athena Output Port within the Witboost platform.

### Prerequisites

A Data Product should already exist in order to attach the new components to it.

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

### Data Contract Schema

This section defines the columns of the table. Primitive data types supported.

- **Column Definitions**: Defines the schema of the Athena view, specifying column names, descriptions, data types, and constraints.

*Example:*

| **Column Name** | **Description**      | **Data Type** | **Constraint** |
|-----------------|----------------------|---------------|----------------|
| id              | Unique identifier    | INT           | PRIMARY_KEY    |
| name            | Name of the entity   | STRING        | NOT_NULL       |
| created_at      | Creation timestamp   | TIMESTAMP     |                |
| status          | Status of the record | VARCHAR       |                |

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

