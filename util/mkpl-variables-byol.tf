# ---------------------------------------------------------------------------------------------------------------------
# Marketplace variables
# ---------------------------------------------------------------------------------------------------------------------

variable "mp_listing_id" {
  default = "ocid1.appcataloglisting.oc1..aaaaaaaa34rp2h6epdvcutthmgpnegduad4iz7lyrxua7jnlv3n5wzqim6mq"
}

variable "mp_listing_resource_id" {
  default = "ocid1.image.oc1..aaaaaaaatonlxvh7grpqo6d7jrtuu4b4qpfxbmjv2kmg3z5wgrwf747iunrq"
}

variable "mp_listing_resource_version" {
  default = "1.0"
}

variable "mp_listing_id_syncgateway" {
  default = "ocid1.appcataloglisting.oc1..aaaaaaaazphghxwsnimdtzawsuzyrcuct6lcmkc5homqmkqjfjl7spkatqdq"
}

variable "mp_listing_resource_id_syncgateway" {
  default = "ocid1.image.oc1..aaaaaaaa435lsxwxfsws7r6jvysfhhh5wuj6la3uvb3ehskhqtsh5tkfi4oa"
}

variable "mp_listing_resource_version_syncgateway" {
  default = "1.0"
}

variable "use_marketplace_image" {
  default = true
}

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
  default = "6.0.2"
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
  default = "2.6.0"
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
  type = map(string)

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

