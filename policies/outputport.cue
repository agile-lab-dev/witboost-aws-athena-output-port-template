import "strings"

let splits = strings.Split(id, ":")
let domain = splits[3]
let majorVersion = splits[5]

#ComponentVersion: string & =~"^([0-9]+\\.[0-9]+\\..+)$"
#Id:               string & =~"^[a-zA-Z0-9:._\\-]+$"
#ComponentId:      #Id & =~"^urn:dmb:cmp:\(domain):[a-zA-Z0-9_\\-]+:\(majorVersion):[a-zA-Z0-9_\\-]+$"
#AWSRegion: string & =~"(?i)^(eu-west-1|eu-west-2|eu-west-3|eu-central-1|eu-north-1|eu-south-1|eu-south-2|eu-central-2)$"

#OM_DataType: string & =~"(?i)^(TINYINT|SMALLINT|INT|BIGINT|DOUBLE|DECIMAL|TIMESTAMP|DATE|STRING|CHAR|VARCHAR|BOOLEAN|ARRAY)$"
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

#TableSpecific: {
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
	sourceTable!: #TableSpecific
	view!: #TableSpecific
}

