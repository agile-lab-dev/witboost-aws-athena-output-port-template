# ${{ values.name }}

- [Overview](#overview)
- [Customise template](#customise-template)
- [Usage](#usage)

## Overview

Use this template to create an Output Port that defines an Athena View based on a specified source table.

### What's an Output Port?
An Output Port refers to the interface that a Data Product on a Data Mesh uses to provide data to other components or systems within the organization. The methods of data sharing can range from APIs to file exports and database links.

## Customise template
To customise this template, modify the `spec.mesh.specific` section inside [catalog-info.yaml](./catalog-info.yaml).
**It is not recommended** to edit the fields above `spec.mesh section`, as inconsistencies may be generated.
The best solution is to create a new component using the wizard.
In case of doubt, please contact the platform team.

### Customisable fields:
You can customise the following fields within the `spec.mesh.specific` section of the [catalog-info.yaml](./catalog-info.yaml) file:
- **storageAreaId**: The ID of the AWS S3 Storage component dependency used as the query output location.
- **sourceTable**: Configuration of the source table from which the Athena view will be created.
    - **catalog**: Name of the AWS Glue catalog where the table resides.
    - **database**: Database of the source table.
    - **name**: Name of the source table.
    - **tableFormat**: The format of the table. Currently, only `ICEBERG` is supported.
- **view**:
  - **catalog**: Name of the catalog where the view will be created.
  - **database**: Database of the view.
  - **name**: Name of the view.

## Usage

To get information about this component and how to use it, refer to this [document](./docs/index.md).
