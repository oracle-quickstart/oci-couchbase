# Required by the OCI Provider
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {
  default = "us-ashburn-1"
}

# Couchbase Cluster
