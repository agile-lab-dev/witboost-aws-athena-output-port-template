{% set dataProductMajorVersion = values.identifier.split(".")[2] %}
{% set dataProductName = values.dataproduct.split(".")[1] | replace(" ", "") | replace("-", "") %}
{% set domainName = values.domain.split(":")[1] | replace(" ", "") | replace("-", "") %}
{% set componentName = values.name | replace(" ", "") | replace("-", "") | lower %}
{% set ComponentDependencies = values.dependsOn | list if values.dependsOn else [] %}

## Component Basic Information

| Field Name              | Value                  |
|:------------------------|:-------------------------------|
| **Name**                | ${{ values.name }}             |
| **Description**         | ${{ values.description }}      |
| **Domain**              | ${{ values.domain }}           |
| **Data Product**        | ${{ values.dataproduct }}      |
| **_Identifier_**        | ${{ values.identifier }}       |
| **_Development Group_** | ${{ values.developmentGroup }} |
| **Storage Area ID**     | ${{ values.storageArea }}        
| **Depends On**          | ${{ values.dependsOn }}        |
| **Technology**          | Athena                         |
| **Tags**                | {% if values.tags | length > 0 %}{% for i in values.tags %} ${{ i }}; {% endfor %}{% else %}[]{% endif %}      |

{% if values.schemaColumns | length > 0 %}
## Data contract schema

| Column | Data type | Description |
|:-------|:----------|:------------|
{%- for column in values.schemaColumns %}
| ${{ column.name }} | ${{ column.dataType }} | ${{ column.description if column.description else "-" }} |
{%- endfor %}

For other details about each column, please refer to this component `catalog-info.yaml`
{%- endif %}


## Athena
### Source Table Details

| **Field Name**   | **Value**                                                                                     |
|------------------|-----------------------------------------------------------------------------------------------|
| **Glue catalog** | ${{ values.catalog  }}                                                                        |
| **Database**     | ${{ domainName }}_ENVIRONMENT_${{ dataProductName }}_v${{ dataProductMajorVersion }}_internal |
| **Name**         | ${{ values.sourceTableName                                    }}                              |

### View Details

| **Field Name**   | **Value**                                                                                       |
|------------------|-------------------------------------------------------------------------------------------------|
| **Glue catalog** | ${{ values.catalog }}                                                                           |
| **Database**     | ${{ domainName }}_ENVIRONMENT_${{ dataProductName }}_v${{ dataProductMajorVersion }}_consumable |
| **Name**         | ${{ componentName }}                                                                            |


## Deployment details 

Deploy this component to automatically create or replace an Athena View.
A dedicated folder for this output port will be created within the S3 bucket and will be used as `Athena output location`.


