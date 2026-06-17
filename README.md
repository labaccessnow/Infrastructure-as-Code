# Infrastructure as Code

Declarative, version-controlled infrastructure — reproducible environments instead of
snowflakes, rebuildable from scratch.

## Stack
- **Provisioning** — Terraform / Pulumi for cloud and virtualization.
- **Private cloud** — Proxmox + SDN as a programmable substrate (VMs, VLANs, zones).
- **GitOps / CI-CD** — GitHub Actions pipelines: a commit triggers validation and a
  push-to-deploy; infrastructure changes go through the same review as application code.
- **State & secrets** — idempotent applies, remote/locked state in shared environments,
  and SOPS-encrypted config kept in git.

If it runs here, it is defined in a repository — and can be torn down and rebuilt deterministically.
