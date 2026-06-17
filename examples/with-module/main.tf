# Where the module pays off: two VMs, no copy-paste. Each is a handful of lines, and the
# db box just overrides the size. Add a third by adding another block, not another file.
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66"
    }
  }
}

variable "pve_endpoint" {
  type = string
}

provider "proxmox" {
  endpoint = var.pve_endpoint # token via PROXMOX_VE_API_TOKEN env var
}

module "web" {
  source      = "../../modules/proxmox_vm"
  name        = "web-01"
  node_name   = "pve1"
  template_id = 9000
  ip_cidr     = "0.0.0.0/24"
  gateway     = "0.0.0.0"
}

module "db" {
  source      = "../../modules/proxmox_vm"
  name        = "db-01"
  node_name   = "pve1"
  template_id = 9000
  cores       = 4
  memory      = 8192
  ip_cidr     = "0.0.0.0/24"
  gateway     = "0.0.0.0"
}

output "web_ip" {
  value = module.web.ipv4
}

output "db_ip" {
  value = module.db.ipv4
}
