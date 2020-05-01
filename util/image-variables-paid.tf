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

variable "mp_listing_id_syncgateway" {
  default = "ocid1.appcataloglisting.oc1..aaaaaaaa54n5bmzxn2canjulb4gcdc4rvwtc7qkmlxke3cmbxeuudplwhmbq"
}

variable "mp_listing_resource_id_syncgateway" {
  default = "ocid1.image.oc1..aaaaaaaamcjj3ggx6jzrp5ujtzjeagoabldmqiiexunyk7xlrj5hpwemhj7a"
}

variable "mp_listing_resource_version_syncgateway" {
  default = "1.0"
}

variable "use_marketplace_image" {
  default = true
}
