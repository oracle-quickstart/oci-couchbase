# ---------------------------------------------------------------------------------------------------------------------
# Marketplace variables
# ---------------------------------------------------------------------------------------------------------------------

variable "mp_listing_id" {
  default = "ocid1.appcataloglisting.oc1..aaaaaaaasb777pyjqr4wzdf7y3ctsqyp6ejnyv3z4cmhragm243iaygvqkra"
}
variable "mp_listing_resource_id" {
  default = "ocid1.image.oc1..aaaaaaaaodym6vep3chhqqgw2rnr4vm4t75u6w5ve7u4fm64gbbqjvdufypq"
}
variable "mp_listing_resource_version" {
 default = "1.0"
}

variable "use_marketplace_image" {
  default = true
}

variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "region" {}

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
 default = "6.0.2"
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

# Unused in a mkpl deployment
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
