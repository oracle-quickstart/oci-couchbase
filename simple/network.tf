data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = "${var.tenancy_ocid}"
}

resource "oci_core_virtual_network" "virtual_network" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = "${var.tenancy_ocid}"
  display_name   = "virtual_network"
  dns_label      = "couchbase"
}

resource "oci_core_subnet" "subnet" {
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0], "name")}"
  cidr_block          = "10.0.0.0/16"
  display_name        = "subnet"
  dns_label           = "couchbase"
  vcn_id              = "${oci_core_virtual_network.virtual_network.id}"
  dhcp_options_id     = "${oci_core_virtual_network.virtual_network.default_dhcp_options_id}"
}
