# Infrastructure as Code

Reproducible environments instead of snowflakes. If it runs here, it's defined in a repo and can
be torn down and rebuilt deterministically — including the private-cloud substrate it runs on.

## What it looks like in practice

Provisioning Proxmox with the `bpg/proxmox` provider (works with both Terraform and OpenTofu),
remote locked state, cloned from a cloud-init template:

```hcl
terraform {
  required_providers {
    proxmox = { source = "bpg/proxmox" }    # Terraform OR OpenTofu — same config
  }
  backend "s3" {                            # remote, LOCKED state (never local in a team)
    bucket = "tfstate"
    key    = "lab/proxmox.tfstate"
    # + DynamoDB lock table (AWS) or object-lock — see lessons below
  }
}

resource "proxmox_virtual_environment_vm" "web" {
  name      = "web-01"
  node_name = "pve1"
  clone   { vm_id = 9000 }                  # a cloud-init golden template
  agent   { enabled = true }
  cpu     { cores = 2 }
  memory  { dedicated = 4096 }
  initialization {                          # cloud-init: IP, SSH keys, etc.
    ip_config { ipv4 { address = "0.0.0.0/24", gateway = "0.0.0.0" } }
  }
}
```

## Best practices I follow
- **Remote, locked, encrypted state.** Never local state in anything shared.
- **Plan in CI.** Every change runs `plan` + static analysis (and cost estimate where it fits),
  reviewed like application code, before apply.
- **Policy-as-code for guardrails** (OPA / Sentinel-style) instead of "ask the senior engineer."
- **Drift detection on a schedule** — reconcile reality against the repo; the repo is the truth.
- **Stay portable.** Modules and provider abstractions so I'm not hostage to one vendor's terms.

## Lessons learned
- **Two people running `apply` against unlocked state will corrupt it.** Learned that once;
  never again — remote backend with locking is the first thing I set up, not the last.
- **Licensing is now part of tool selection.** HashiCorp's 2023 **BSL** relicense of Terraform
  was a real mid-stream decision, not trivia — I track **OpenTofu** and keep configs portable so
  a license change can't strand a stack. (IBM's acquisition of HashiCorp closing Feb 27, 2025
  only sharpened that.)
- **A vendor's prebuilt cloud image won't always boot on your hypervisor.** A Cisco 9800-CL
  `qcow2` would not boot on Proxmox — wrong firmware/disk-bus/console assumptions baked in. The
  ISO installer, which builds *to* the VM it finds, just worked. Build to your environment;
  don't assume someone else's image matches it.

## The license timeline (dated)
- **Aug 10, 2023:** Terraform relicensed MPL → **BSL**.
- **Aug–Sep 2023:** community forks it → **OpenTofu**, under the Linux Foundation.
- **Jan 2024:** OpenTofu **1.6 GA**; later **1.7** adds native state encryption.
- **Apr 24, 2024:** IBM announces a **$6.4B** acquisition of HashiCorp.
- **Feb 27, 2025:** the deal **closes**; OpenTofu joins the **CNCF** the same year.
