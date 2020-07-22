# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MYSQL DB CLUSTER WITH X NODES ON DIGITALOCEAN
# - Includes databases and DB user for application access
# - Provides access to cluster via Droplet tags
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# MAP OF CUSTOM DB SIZES TO VALID DB SIZE IN DIGITALOCEAN
# ------------------------------------------------------------------------------
locals {
  db_sizes = {
    nano   = "db-s-1vcpu-1gb"
    small  = "db-s-1vcpu-2gb"
    medium = "db-s-2vcpu-4gb"
  }
}

# ------------------------------------------------------------------------------
# CREATE MYSQL DB CLUSTER
# ------------------------------------------------------------------------------
resource "digitalocean_database_cluster" "mysql_cluster" {
  name       = var.cluster_name
  engine     = "mysql"
  version    = "8"
  size       = local.db_sizes[var.db_size]
  region     = var.cluster_region
  node_count = var.node_count

  maintenance_window {
    day  = var.cluster_maintenance_window.day
    hour = var.cluster_maintenance_window.hour
  }
}

# ------------------------------------------------------------------------------
# CREATE APPLICATION USER FOR DB CLUSTER
# ------------------------------------------------------------------------------
resource "digitalocean_database_user" "app_db_user" {
  cluster_id = digitalocean_database_cluster.mysql_cluster.id
  name       = "app-user"
}

# ------------------------------------------------------------------------------
# CREATE DATABASES IN DB CLUSTER
# ------------------------------------------------------------------------------
resource "digitalocean_database_db" "databases" {
  for_each = toset(var.dbs)

  cluster_id = digitalocean_database_cluster.mysql_cluster.id
  name       = each.key
}

# ------------------------------------------------------------------------------
# CREATE FIREWALL FOR DB CLUSTER
# Only allow DigitalOcean Droplets with specific tags to access DB cluster
# ------------------------------------------------------------------------------
resource "digitalocean_database_firewall" "cluster_firewall" {
  cluster_id = digitalocean_database_cluster.mysql_cluster.id

  dynamic "rule" {
    for_each = toset(var.allowed_access_droplet_tags)

    content {
      type  = "tag"
      value = rule.key
    }
  }
}
