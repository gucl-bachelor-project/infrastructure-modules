# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DIGITALOCEAN DROPLET (VM) WITH STANDARD USER ACCOUNT AND APPLICATION CONFIG TO RUN DOCKERIZED APPLICATION WITH IMAGES
# LOCATED IN AMAZON ECR AND DOCKER-COMPOSE FILES LOCATED IN DIGITALOCEAN SPACES BUCKET.
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

  # Establish SSH connection
  connection {
    host        = self.ipv4_address
    user        = "ubuntu"
    type        = "ssh"
    private_key = file(var.pvt_key)
  }

  # Create s3cmd config
  provisioner "file" {
    content     = data.template_file.s3cmd_config.rendered
    destination = "/home/ubuntu/.s3cfg"
  }

  # Start application
  provisioner "remote-exec" {
    inline = ["start-application"]
  }
}

# ------------------------------------------------------------------------------
# s3cmd config file
# ------------------------------------------------------------------------------
data "template_file" "s3cmd_config" {
  template = file("${path.module}/program-config-templates/s3cmd-config.tpl")

  vars = {
    region_slug = var.do_spaces_region
    access_key  = var.do_spaces_access_key
    secret_key  = var.do_spaces_secret_key
  }
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
    filename     = "vm-access-config.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.vm_access_config.rendered
  }

  part {
    filename     = "vm-user-account-init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.vm_user_init_config.rendered
  }

  part {
    filename     = "common-env-vars.tpl"
    content_type = "text/cloud-config"
    content      = data.template_file.common_env_vars_config.rendered
  }

  part {
    filename     = "extra-app-config.cfg"
    content_type = "text/cloud-config"
    content      = var.extra_cloud_init_config
  }
}

# ------------------------------------------------------------------------------
# CLOUD INIT CONFIG SCRIPT FOR CONFIGURING REMOTE ACCESS TO VM
# ------------------------------------------------------------------------------
data "template_file" "vm_access_config" {
  template = file("${path.module}/init-config-templates/vm-access-config.tpl")
}

# ------------------------------------------------------------------------------
# CLOUD INIT CONFIG SCRIPT TO SET COMMON ENVIRONMENT VARIABLES
# ------------------------------------------------------------------------------
data "template_file" "common_env_vars_config" {
  template = file("${path.module}/init-config-templates/common-env-vars.tpl")

  vars = {
    ecr_base_url              = var.ecr_base_url
    compose_files_bucket_path = var.compose_files_bucket_path
    bucket_name               = var.project_bucket_name
  }
}

# ------------------------------------------------------------------------------
# CLOUD INIT CONFIG SCRIPT TO CONFIGURE SSH ACCESS TO VM IF AUTHORIZED
# SSH KEYS ARE SPECIFIED.
# ------------------------------------------------------------------------------
data "template_file" "vm_user_init_config" {
  template = file("${path.module}/init-config-templates/vm-user-account.tpl")

  vars = {
    authorized_ssh_keys = yamlencode([for ssh_key in var.authorized_ssh_keys : ssh_key.public_key])
  }
}
