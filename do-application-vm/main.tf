# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DIGITALOCEAN DROPLET (VM) WITH STANDARD USER AND APPLICATION CONFIG TO RUN DOCKERIZED APPLICATION WITH IMAGES
# LOCATED IN AMAZON ECR AND DOCKER-COMPOSE FILES LOCATED IN S3 BUCKET.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# DEPLOY DROPLET (VM)
# ------------------------------------------------------------------------------
resource "digitalocean_droplet" "droplet" {
  name               = var.vm_name
  tags               = var.tags
  image              = var.boot_image_id
  region             = var.do_region
  size               = var.do_vm_size
  private_networking = true
  user_data          = data.template_cloudinit_config.init_config.rendered
  ssh_keys           = [for ssh_key in var.authorized_ssh_keys : ssh_key.id]
}

# ------------------------------------------------------------------------------
# COMBINED/MERGED CLOUD INIT CONFIG SCRIPT WITH ALL DEFINED SCRIPTS IN
# THIS FILE.
# To be run when the VM boots for the first time.
# ------------------------------------------------------------------------------
data "template_cloudinit_config" "init_config" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "aws-cli-config.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.aws_cli_config.rendered
  }

  part {
    filename     = "vm-access-config.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.vm_access_config.rendered
  }

  part {
    filename     = "vm-user-init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.vm_user_init_config.rendered
  }

  part {
    filename     = "app-vm-bootstrap.cfg"
    content_type = "text/cloud-config"
    content      = var.app_start_script
  }
}

# ------------------------------------------------------------------------------
# CLOUD INIT CONFIG SCRIPT FOR CONFIGURING REMOTE ACCESS TO VM
# ------------------------------------------------------------------------------
data "template_file" "vm_access_config" {
  template = file("${path.module}/init-config-templates/vm-access-config.tpl")
}

# ------------------------------------------------------------------------------
# CLOUD INIT CONFIG SCRIPT TO CONFIGURE CREDENTIALS AND OTHER SETTINGS
# IN AWS CLI PROGRAM.
# ------------------------------------------------------------------------------
data "template_file" "aws_cli_config" {
  template = file("${path.module}/init-config-templates/aws-cli-setup.tpl")

  vars = {
    aws_region            = var.aws_config.region
    aws_access_key_id     = var.aws_config.access_key_id
    aws_secret_access_key = var.aws_config.secret_access_key
  }
}

# ------------------------------------------------------------------------------
# CLOUD INIT CONFIG SCRIPT TO CONFIGURE SSH ACCESS TO VM IF AUTHORIZED
# SSH KEYS ARE SPECIFIED.
# ------------------------------------------------------------------------------
data "template_file" "vm_user_init_config" {
  template = file("${path.module}/init-config-templates/vm-user.tpl")

  vars = {
    authorized_ssh_keys = yamlencode([for ssh_key in var.authorized_ssh_keys : ssh_key.public_key])
  }
}
