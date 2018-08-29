variable "region" {
  default = "us-ashburn-1"
}

# Required by the OCI Provider
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}

# Keys used to SSH to OCI VMs
variable "ssh_public_key" {}
variable "ssh_private_key" {}

variable "couchbase_cluster" {
  type = "map"
  default = {
    vm_shape = "VM.Standard1.2"
    server_version="5.5.0"
    server_node_count = 3
    syncgateway_version="2.0.0"
    syncgateway_node_count = 0
  }
}
