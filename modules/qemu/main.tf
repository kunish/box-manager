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

resource "proxmox_vm_qemu" "qemu" {
  for_each    = toset(var.qemus)
  name        = each.key
  target_node = var.target_node
  clone       = var.clone
  cores       = var.cores
  memory      = var.memory
  onboot      = true

  disk {
    type    = "scsi"
    storage = "local-lvm"
    size    = "${var.diskSizeInGB}G"
  }

  network {
    model   = "virtio"
    bridge  = "vmbr0"
    macaddr = lower(data.terraform_remote_state.router.outputs.leases[each.key].macaddress)
  }

  ipconfig0 = "ip=dhcp,ip6=dhcp"
}
