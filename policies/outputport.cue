import "strings"
import "list"

let splits = strings.Split(id, ":")
let domain = splits[3]
let majorVersion = splits[5]

#ComponentVersion: string & =~"^([0-9]+\\.[0-9]+\\..+)$"
#Id:               string & =~"^[a-zA-Z0-9:._\\-]+$"
#ComponentId:      #Id & =~"^urn:dmb:cmp:\(domain):[a-zA-Z0-9_\\-]+:\(majorVersion):[a-zA-Z0-9_\\-]+$"
#AWSRegion: string & =~"(?i)^(eu-west-1|eu-west-2|eu-west-3|eu-central-1|eu-north-1|eu-south-1|eu-south-2|eu-central-2)$"
#TableFormat: string & =~"(?i)^(ICEBERG)$"

#OM_DataType: string & =~"(?i)^(BOOLEAN|TINYINT|SMALLINT|INT|BIGINT|DOUBLE|FLOAT|DECIMAL|CHAR|VARCHAR|STRING|BINARY|DATE|TIMESTAMP|TIMESTAMPTZ|ARRAY|MAP)$"
#URL:         string & =~"^https?://[a-zA-Z0-9@:%._~#=&/?]*$"
#OM_Tag: {
	tagFQN!:       string
	description?: string | null
	source!:       string & =~"(?i)^(Tag|Glossary)$"
	labelType!:    string & =~"(?i)^(Manual|Propagated|Automated|Derived)$"
	state!:        string & =~"(?i)^(Suggested|Confirmed)$"
	href?:        string | null
	...
}

#QualityCheck: {
  type!: "custom"
  engine!: "sifflet"
  implementation!: {
    name!: string
    description?: string | null
    schedule?: string | null
    scheduleTimezone?: string | null
    incident!: {
      severity!: "Critical" | "High" | "Moderate" | "Low"
      createOnFailure!: bool
    }
    parameters!: #QualityParameters
  }
}

#QualityParameters: {
  kind!: "FieldNulls" | "FieldDuplicates" | "SchemaChange" | "RowDuplicates"
  if kind =~ "(?i)^(FieldNulls)$"{
  	  nullValues?: "NullAndEmpty" | "NullEmptyAndWhitespaces"
  }
  if kind =~ "(?i)^(FieldNulls|FieldDuplicates)$"{
  	    field!: string
  }
  if kind =~"(?i)^(FieldNulls|RowDuplicates)$"{
			threshold!: {
				kind!: "Static"
				valueMode!: "Percentage"
				max!: string & =~"^(100|[1-9]?[0-9])%$"
			}
  }
  ...
}

#OM_Column: {
	name!:        string
	dataType!:    #OM_DataType
	constraint?: string & =~"(?i)^(PRIMARY_KEY|NOT_NULL|UNIQUE)$" | null
	if dataType =~ "(?i)^(ARRAY)$" {
		arrayDataType!: #OM_DataType
	}
	if dataType =~ "(?i)^(CHAR|VARCHAR)$" {
		dataLength!: int & >0 & <=16777216
	}
	if dataType =~ "(?i)^(DECIMAL)$" {
		precision?: int & >0 & <=38
		scale?:     int & >=0 & <=(precision - 1)
	}
	dataTypeDisplay?:    string | null
	description?:        string | null
	fullyQualifiedName?: string | null
	tags?: [... #OM_Tag]
	...
}

#DataContract: {
	schema!: [...#OM_Column]
	SLA: {
		intervalOfChange?: string | null
		timeliness?:       string | null
		upTime?:           string | null
		...
	}
	termsAndConditions?: string | null
	endpoint?:           #URL | null
	quality?: [...#QualityCheck]
	...
}

#DataSharingAgreement: {
	purpose?:         string | null
	billing?:         string | null
	security?:        string | null
	intendedUsage?:   string | null
	limitations?:     string | null
	lifeCycle?:       string | null
	confidentiality?: string | null
	...
}

#SourceTableSpecific: {
	catalog!: string
	database!: string
	name!: string
	tableFormat!: #TableFormat
}

#ViewSpecific: {
	catalog!: string
	database!: string
	name!: string
}

id!: #ComponentId
name!:                     string
fullyQualifiedName?:      null | string
description!:              string
kind!:                     "outputport"
version!:                  string & =~"^[0-9]+\\.[0-9]+\\..+$"
infrastructureTemplateId!: string
useCaseTemplateId!:        string
dependsOn: [...#ComponentId]
platform!:             "AWS"
technology!:           "Athena"
outputPortType!:       "View"
dataContract:         #DataContract
dataSharingAgreement: #DataSharingAgreement
tags: [...#OM_Tag]
specific: {
	storageAreaId!: #ComponentId
	sourceTable!: #SourceTableSpecific
	view!: #ViewSpecific
}


checks: {
stringColumns: [for row in dataContract.schema if row.dataType == "STRING" {
		row.name
	}]

nullsAndEmptyMonitors: [for quality in dataContract.quality
if quality.implementation.parameters.kind == "FieldNulls" && quality.implementation.parameters.nullValues != _|_  {
					quality.implementation.parameters.field
}]

stringColumnList: list.FlattenN(stringColumns, -1)
nullsAndEmptyList: list.FlattenN(nullsAndEmptyMonitors, -1)

mismatchNull: [for monitor in nullsAndEmptyMonitors if !list.Contains(stringColumnList, monitor) {monitor}]
checkNullAndEmptyOnlyStringColumns: len(mismatchNull) & <=0

}
