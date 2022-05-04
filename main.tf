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
  source              = "./modules/lxc"
  ostemplate          = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  target_node         = "box"
  memory              = 4096
  diskSizeInGB        = 16
  password            = var.vm_password
  ssh_public_key_path = var.ssh_public_key_path
  lxcs                = ["gitlab"]
}

module "master" {
  source       = "./modules/qemu"
  target_node  = "box"
  clone        = "ci-ubuntu-focal"
  cores        = 2
  memory       = 2048
  diskSizeInGB = 32
  qemus        = ["master"]
}

module "node" {
  source       = "./modules/qemu"
  target_node  = "box"
  clone        = "ci-ubuntu-focal"
  cores        = 4
  memory       = 4096
  diskSizeInGB = 32
  qemus        = ["node-01", "node-02", "node-03"]
}
