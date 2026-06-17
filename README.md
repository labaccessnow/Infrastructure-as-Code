# Infrastructure as Code

Declarative, version-controlled infrastructure — reproducible environments instead of
hand-built ones.

## Stack
- Terraform / Pulumi for cloud and virtualization provisioning
- Proxmox + SDN as a programmable private-cloud substrate
- GitHub Actions CI/CD with push-to-deploy
- Configuration and secrets kept in git, SOPS-encrypted

If it runs, it is defined in a repository and rebuildable from scratch.
