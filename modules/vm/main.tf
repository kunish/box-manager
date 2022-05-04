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

resource "proxmox_lxc" "vm" {
  for_each     = toset(var.vms)
  target_node  = "box"
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
}
