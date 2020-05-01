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
