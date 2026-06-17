# Provision a Proxmox VM with bpg/proxmox (Terraform OR OpenTofu). Clones a cloud-init
# template; remote, locked state.
terraform {
  required_providers {
    proxmox = { source = "bpg/proxmox", version = "~> 0.66" }
  }
  backend "s3" {
    bucket = "tfstate"
    key    = "lab/proxmox.tfstate"
    # + DynamoDB lock table (AWS) / object-lock — never local state in a team
  }
}

provider "proxmox" {
  endpoint = var.pve_endpoint   # api token via PROXMOX_VE_API_TOKEN env var, not hardcoded
}

resource "proxmox_virtual_environment_vm" "web" {
  name      = "web-01"
  node_name = "pve1"
  clone  { vm_id = 9000 }       # cloud-init golden template
  agent  { enabled = true }
  cpu    { cores = 2 }
  memory { dedicated = 4096 }
  initialization {
    ip_config { ipv4 { address = "0.0.0.0/24", gateway = "0.0.0.0" } }
  }
}
