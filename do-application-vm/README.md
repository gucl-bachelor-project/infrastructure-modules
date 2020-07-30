# Server (DigitalOcean Droplet)

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| digitalocean | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| authorized\_ssh\_keys | List of authorized SSH keys (registered in DigitalOcean) for remote SSH access | <pre>list(object({<br>    id          = string<br>    name        = string<br>    public_key  = string<br>    fingerprint = string<br>  }))</pre> | `[]` | no |
| boot\_image\_id | ID of OS image in DigitalOcean to boot Droplet/VM from | `string` | n/a | yes |
| compose\_files\_bucket\_path | Relative path in project's DigitalOcean Spaces bucket where Docker Compose files for application is located | `string` | n/a | yes |
| do\_region | Name of DigitalOcean region to place Droplet in | `string` | n/a | yes |
| do\_spaces\_access\_key | Access key to project's DigitalOcean Spaces bucket | `string` | n/a | yes |
| do\_spaces\_region | Name of DigitalOcean region where project's DigitalOcean Spaces bucket is located | `string` | n/a | yes |
| do\_spaces\_secret\_key | Secret key to project's DigitalOcean Spaces bucket | `string` | n/a | yes |
| do\_vm\_size | DigitalOcean-specified Droplet/VM size (example: s-1vcpu-1gb) | `string` | n/a | yes |
| ecr\_base\_url | Base URL of ECR registry to pull Docker images from for application | `string` | n/a | yes |
| extra\_cloud\_init\_config | Cloud-init script for application specific configuration of VM to be run when it boots | `string` | n/a | yes |
| project\_bucket\_name | Name of project's DigitalOcean Spaces bucket | `string` | n/a | yes |
| pvt\_key | Path to private key on machine executing Terraform. The public key must be registered on DigitalOcean. See: https://github.com/gucl-bachelor-project/infrastructure-global/blob/master/ssh-keys.tf | `string` | n/a | yes |
| tags | List of tags to apply to Droplet | `list(string)` | `[]` | no |
| vm\_name | Name of Droplet/VM | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the deployed Droplet |
| ipv4\_address | The IPv4 address of the deployed Droplet |
| private\_ipv4\_address | The private IPv4 address of the deployed Droplet |
| urn | The uniform resource name of the deployed Droplet |

