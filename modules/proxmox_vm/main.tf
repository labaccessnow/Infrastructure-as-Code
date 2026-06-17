# The reusable body. One definition, cloned from a golden template, parameterized by the
# variables. Callers never touch this file — they pass arguments.
terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  name      = var.name
  node_name = var.node_name

  clone {
    vm_id = var.template_id
  }
  agent {
    enabled = true
  }
  cpu {
    cores = var.cores
  }
  memory {
    dedicated = var.memory
  }
  initialization {
    ip_config {
      ipv4 {
        address = var.ip_cidr
        gateway = var.gateway
      }
    }
  }
}
