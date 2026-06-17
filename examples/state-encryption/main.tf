# OpenTofu 1.7+ native state encryption — encrypt state AND plan files at rest, key derived
# from a passphrase (use an AWS/GCP KMS key provider in production). This is an OpenTofu
# feature, not Terraform — one of the concrete reasons I keep configs on the fork.
#
#   export TF_VAR_state_passphrase=...   # 16+ chars, from a secrets manager in real use
#   tofu init && tofu apply              # state on disk is now AES-GCM encrypted
terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }

  encryption {
    key_provider "pbkdf2" "key" {
      passphrase = var.state_passphrase
    }
    method "aes_gcm" "encrypt" {
      keys = key_provider.pbkdf2.key
    }
    state {
      method   = method.aes_gcm.encrypt
      enforced = true # refuse to ever write plaintext state
    }
    plan {
      method   = method.aes_gcm.encrypt
      enforced = true
    }
  }
}

variable "state_passphrase" {
  type      = string
  sensitive = true
}
