# ---------------------------------------------------------------------------------------------------------------------
# Environmental variables
# You probably want to define these as environmental variables.
# Instructions on that are here: https://github.com/cloud-partners/oci-prerequisites
# ---------------------------------------------------------------------------------------------------------------------

# Required by the OCI Provider
variable "tenancy_ocid" {}

variable "compartment_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

# Key used to SSH to OCI VMs
variable "ssh_public_key" {}

# ---------------------------------------------------------------------------------------------------------------------
# Optional variables
# The defaults here will give you a cluster.  You can also modify these.
# ---------------------------------------------------------------------------------------------------------------------

variable "server_shape" {
 default = "VM.Standard2.4"
}

variable "server_count" {
 default = 6
}

variable "server_version" {
 default = "6.0.2"
}

variable "disk_size" {
  default = 500
  description = "Size of block volume in GB for data, min 50."
}

variable "disk_count" {
  default = 1
  description = "Number of disks to create for each worker. Multiple disks will create a RAID0 array."
}

variable "adminUsername" {
 default = "couchbase"
}

variable "adminPassword" {
 default = "foo123!"
}

variable "syncgateway_shape" {
 default = "VM.Standard2.2"
}

variable "syncgateway_count" {
 default = 4
}

variable "syncgateway_version" {
 default = "2.5.0"
}

locals {
  fault_domains_per_ad = 3
}

# ---------------------------------------------------------------------------------------------------------------------
# Constants
# You probably don't need to change these.
# ---------------------------------------------------------------------------------------------------------------------

# Not used for normal terraform apply, added for ORM deployments.
variable "ad_name" {
  default = ""
}

# Not used for normal terraform apply, added for marketplace deployments.

variable "mp_listing_resource_id" {
  default = ""
}

// https://docs.cloud.oracle.com/iaas/images/image/66379f54-edd0-4294-895f-47291a3eb4ed/
// Oracle-Linux-7.6-2019.05.14-0
variable "platform-images" {
  type = "map"

  default = {
    ap-seoul-1     = "ocid1.image.oc1.ap-seoul-1.aaaaaaaalhbuvdg453ddyhvnbk4jsrw546zslcfyl7vl4oxfgplss3ovlm4q"
    ap-tokyo-1     = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaamc2244t7h3gwrrci5z4ni2jsulwcg76gugupkb6epzrypawcz4hq"
    ca-toronto-1   = "ocid1.image.oc1.ca-toronto-1.aaaaaaaakjkxzw33dcocgu2oylpllue34tjtyngwru7pcpqn4qh2nwon7n7a"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaandqh4s7a3oe3on6osdbwysgddwqwyghbx4t4ryvtcwk5xikkpvhq"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaa2xe7cufdwkksdazshtmqaddgd72kdhiyoqurtoukjklktf4nxkbq"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaa4bfsnhv2cd766tiw5oraw2as7g27upxzvu7ynqwipnqfcfwqskla"
    us-phoenix-1   = "ocid1.image.oc1.phx.aaaaaaaavtjpvg4njutkeu7rf7c5lay6wdbjhd4cxis774h7isqd6gktqzoa"
  }
}
