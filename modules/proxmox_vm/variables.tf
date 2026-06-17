# Inputs to the reusable VM module. Everything that varies between a web box and a DB box
# is an argument — the module body stays the same.
variable "name" {
  type = string
}

variable "node_name" {
  type = string
}

variable "template_id" {
  type        = number
  description = "VMID of the cloud-init golden template to clone"
}

variable "cores" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 4096
}

variable "ip_cidr" {
  type        = string
  description = "Static address in CIDR form, e.g. 0.0.0.0/24"
}

variable "gateway" {
  type = string
}
