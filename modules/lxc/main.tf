terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

data "terraform_remote_state" "router" {
  backend = "remote"

  config = {
    organization = "kunish"
    workspaces = {
      name = "router"
    }
  }
}

resource "proxmox_lxc" "lxc" {
  for_each     = toset(var.lxcs)
  target_node  = var.target_node
  hostname     = each.key
  ostemplate   = var.ostemplate
  password     = var.password
  unprivileged = true
  start        = true
  onboot       = true

  memory = var.memory

  rootfs {
    storage = "local-lvm"
    size    = "${var.diskSizeInGB}G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
    hwaddr = lower(data.terraform_remote_state.router.outputs.leases[each.key].macaddress)
  }

  ssh_public_keys = file(var.ssh_public_key_path)
}
