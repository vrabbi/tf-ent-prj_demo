terraform {
  backend "remote" {
    organization = "terasky-demo"
    hostname = "tf-ent.terasky.local"
    workspaces {
      name = "prj_demo"
    }
  }
}

provider "vra" {
  url           = var.url
  refresh_token = var.refresh_token
  insecure      = var.insecure
}

data "vra_project" "this" {
  name = var.project_name
}

data "vra_catalog_item" "this" {
  name            = var.catalog_item_name
  expand_versions = true
}

resource "vra_deployment" "this" {
  name        = var.deployment_name
  description = "terraform test deployment"

  catalog_item_id      = data.vra_catalog_item.this.id
  catalog_item_version = var.catalog_item_version
  project_id           = data.vra_project.this.id

  inputs = {
    flavor    = var.flavor
    count     = var.vm_count
    username  = var.new_user
  }
  timeouts {
    create = "60m"
    delete = "20m"
  }
}
