variable "vm_name" {
  type        = string
  description = "Name of Droplet/VM"
}

variable "boot_image_id" {
  type        = string
  description = "ID of OS image in DigitalOcean to boot Droplet/VM from"
}

variable "tags" {
  type        = list(string)
  default     = []
  description = "List of tags to apply to Droplet"
}

variable "do_region" {
  type        = string
  description = "Name of DigitalOcean region to place Droplet in"
}

variable "do_vm_size" {
  type        = string
  description = "DigitalOcean-specified Droplet/VM size (example: s-1vcpu-1gb)"
}

variable "do_spaces_region" {
  type        = string
  description = "Name of DigitalOcean region where project's DigitalOcean Spaces bucket is located"
}

variable "do_spaces_access_key" {
  type        = string
  description = "Access key to project's DigitalOcean Spaces bucket"
}

variable "do_spaces_secret_key" {
  type        = string
  description = "Secret key to project's DigitalOcean Spaces bucket"
}

variable "authorized_ssh_keys" {
  default = []
  # Reflect type as specified here: https://www.terraform.io/docs/providers/do/r/ssh_key.html
  type = list(object({
    id          = string
    name        = string
    public_key  = string
    fingerprint = string
  }))
  description = "List of authorized SSH keys (registered in DigitalOcean) for remote SSH access"
}

variable "extra_cloud_init_config" {
  type        = string
  description = "Cloud-init script for application specific configuration of VM to be run when it boots"
}

variable "ecr_base_url" {
  type        = string
  description = "Base URL of ECR registry to pull Docker images from for application"
}

variable "project_bucket_name" {
  type        = string
  description = "Name of project's DigitalOcean Spaces bucket"
}

variable "compose_files_bucket_path" {
  type        = string
  description = "Relative path in project's DigitalOcean Spaces bucket where Docker Compose files for application is located"
}

variable "pvt_key" {
  type        = string
  description = "Path to private key on machine executing Terraform. The public key must be registered on DigitalOcean. See: https://github.com/gucl-bachelor-project/infrastructure-global/blob/master/ssh-keys.tf"
}
