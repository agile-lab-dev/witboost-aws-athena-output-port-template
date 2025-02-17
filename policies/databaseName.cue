import "strings"

let majorVersion = strings.Split(version, ".")[0]

let rawDpName = strings.Split(id, ":")[4]
let noSpacesDpName = strings.Replace(rawDpName, " ", "", -1)
let dataProductName = strings.Replace(noSpacesDpName, "-", "", -1)

let rawDomain = strings.Split(id, ":")[3]
let noSpacesDomain = strings.Replace(domain, " ", "", -1)
let domainName = strings.Replace(noSpacesDomain, "-", "", -1)

#Component: {
    kind: string & =~"(?-i)^(outputport|workload|storage|observability)$"
    useCaseTemplateId: string
    infrastructureTemplateId: string
    if kind != _|_ {
        if kind =~ "(?-i)^(outputport)$" && infrastructureTemplateId =~ "urn:dmb:itm:aws-athena-tech-adapter:0" {
            specific: #Athena
        }
    }
    ...
}

#Athena: {
    sourceTable!: {
        database!: string & =~"^\(domainName)_\(environment)_\(dataProductName)_v\(majorVersion)_internal$"
        ...
    }
    view!: {
        database!: string & =~"^\(domainName)_\(environment)_\(dataProductName)_v\(majorVersion)_consumable$"
        ...
    }
    ...
}

#DPVersion:        string & =~"^([0-9]+\\.[0-9]+\\-SNAPSHOT\\-[0-9]+|[0-9]+\\.[0-9]+\\..+)$"
#Id:               string & =~"^[a-zA-Z0-9:._-]+$"
#DataProductId:    #Id & =~"^urn:dmb:dp:\(rawDomain):\(rawDpName):\(majorVersion)$"

id:                  #DataProductId
name:                string
domain:              string
version:             #DPVersion
environment:         string
components: [...#Component]
...