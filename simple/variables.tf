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

variable "couchbase_server" {
  type = "map"

  default = {
    shape         = "VM.Standard2.4"
    node_count    = 6
    version       = "6.0.2"
    adminUsername = "couchbase"
    adminPassword = "foo123!"
  }
}

variable "couchbase_syncgateway" {
  type = "map"

  default = {
    shape      = "VM.Standard2.2"
    node_count = 4
    version    = "2.5.0"
  }
}

locals {
  fault_domains_per_ad = 3
}

# ---------------------------------------------------------------------------------------------------------------------
# Constants
# You probably don't need to change these.
# ---------------------------------------------------------------------------------------------------------------------

// https://docs.cloud.oracle.com/iaas/images/image/66379f54-edd0-4294-895f-47291a3eb4ed/
// Oracle-Linux-7.6-2019.05.14-0
variable "images" {
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
