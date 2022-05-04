terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }

  backend "remote" {
    organization = "kunish"
    workspaces {
      name = "box"
    }
  }
}

provider "proxmox" {
  pm_api_url  = var.pm_api_url
  pm_user     = var.pm_user
  pm_password = var.pm_password
}

module "gitlab" {
  source              = "./modules/vm"
  ostemplate          = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  memory              = 4096
  diskSizeInGB        = 16
  password            = var.vm_password
  ssh_public_key_path = var.ssh_public_key_path
  vms                 = ["gitlab"]
}

module "vm_k8s_master" {
  source              = "./modules/vm"
  ostemplate          = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  memory              = 2048
  diskSizeInGB        = 16
  password            = var.vm_password
  ssh_public_key_path = var.ssh_public_key_path
  vms                 = ["master"]
}

module "vm_k8s_node" {
  source              = "./modules/vm"
  ostemplate          = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  memory              = 4096
  diskSizeInGB        = 32
  password            = var.vm_password
  ssh_public_key_path = var.ssh_public_key_path
  vms                 = ["node-01", "node-02", "node-03"]
}
