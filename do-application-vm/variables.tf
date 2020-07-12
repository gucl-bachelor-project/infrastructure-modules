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

variable "aws_config" {
  type = object({
    region            = string
    access_key_id     = string
    secret_access_key = string
  })
  description = "AWS configuration to be installed for AWS CLI program"
}

variable "app_start_script" {
  type        = string
  description = "Cloud-init script to be run when the VM boots to start the application"
}
