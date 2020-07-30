# Application MySQL Database Cluster (DigitalOcean Managed)

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| digitalocean | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_access\_droplet\_tags | List of tags (that can be assigned to DigitalOcean droplets) that provide access to the DB cluster | `list(string)` | n/a | yes |
| cluster\_maintenance\_window | Time of week when DigitalOcean can maintain the cluster with updates, fixes, etc. Defaults to Sunday at midnight. | <pre>object({<br>    day  = string<br>    hour = string<br>  })</pre> | <pre>{<br>  "day": "sunday",<br>  "hour": "00:00:00"<br>}</pre> | no |
| cluster\_name | Name of DB cluster | `string` | n/a | yes |
| cluster\_region | DigitalOcean region to place DB cluster in | `string` | n/a | yes |
| db\_size | Size of DB cluster. Allowed values: `nano` (RAM: 1 GB, CPU: 1 vCPU, Storage: 10 GB), `small` (RAM: 2 GB, CPU: 1 vCPU, Storage: 25 GB), or `medium` (RAM: 4 GB, CPU: 2 vCPU, Storage: 38 GB) | `string` | `"nano"` | no |
| dbs | List of MySQL databases (with its name) to create in cluster | `list(string)` | n/a | yes |
| node\_count | Number of nodes that will be included in the cluster. Defaults to 1. | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| app\_user | Created MySQL DB user for application access |
| db\_cluster | Created MySQL DB cluster |
| dbs | Created MySQL databases within DB cluster |

