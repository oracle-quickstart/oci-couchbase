# ---------------------------------------------------------------------------------------------------------------------
# Environmental variables
# You probably want to define these as environmental variables.
# Instructions on that are here: https://github.com/cloud-partners/oci-prerequisites
# ---------------------------------------------------------------------------------------------------------------------

# Required by the OCI Provider
variable "tenancy_ocid" {
}

variable "compartment_ocid" {
}

variable "region" {
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional variables
# The defaults here will give you a cluster.  You can also modify these.
# ---------------------------------------------------------------------------------------------------------------------

variable "ssh_public_key" {
  description = "Key used to SSH to OCI VMs."
}

variable "server_shape" {
  default = "VM.Standard2.4"
}

variable "server_count" {
  default = 6
}

variable "server_version" {
  # valid versions = 6.5.1, 6.5.0, 6.0.4, 6.0.3, 6.0.2
  default = "6.5.1"
}

variable "disk_size" {
  default     = 500
  description = "Size of block volume in GB for data, min 50."
}

variable "disk_count" {
  default     = 1
  description = "Number of disks to create for each server. Multiple disks will create a RAID0 array."
}

variable "adminUsername" {
  default = "couchbase"
}

variable "adminPassword" {
}

variable "syncgateway_shape" {
  default = "VM.Standard2.2"
}

variable "syncgateway_count" {
  default = 4
}

variable "syncgateway_version" {
  # valid versions: 2.7.3, 2.7.2, 2.7.1, 2.7.0, 2.6.1, 2.6.0
  default = "2.7.3"
}

locals {
  fault_domains_per_ad = 3
}
