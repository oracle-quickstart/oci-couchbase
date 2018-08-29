data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = "${var.tenancy_ocid}"
}

resource "oci_core_virtual_network" "virtual_network" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = "${var.tenancy_ocid}"
  display_name   = "virtual_network"
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = "${var.tenancy_ocid}"
  display_name   = "internet_gateway"
  vcn_id         = "${oci_core_virtual_network.virtual_network.id}"
}

resource "oci_core_route_table" "route_table" {
  compartment_id = "${var.tenancy_ocid}"
  vcn_id         = "${oci_core_virtual_network.virtual_network.id}"
  display_name   = "route_table"

  route_rules {
    cidr_block        = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.internet_gateway.id}"
  }
}

resource "oci_core_security_list" "security_list" {
  compartment_id = "${var.tenancy_ocid}"
  display_name   = "security_list"
  vcn_id         = "${oci_core_virtual_network.virtual_network.id}"

  egress_security_rules = [{
    protocol    = "6"
    destination = "0.0.0.0/0"
  }]

  ingress_security_rules = [{
    protocol = "6"
    source   = "0.0.0.0/0"
  }]
}

resource "oci_core_subnet" "subnet" {
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0], "name")}"
  cidr_block          = "10.0.0.0/16"
  display_name        = "subnet"
  vcn_id              = "${oci_core_virtual_network.virtual_network.id}"
  route_table_id      = "${oci_core_route_table.route_table.id}"
  security_list_ids   = ["${oci_core_security_list.security_list.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.virtual_network.default_dhcp_options_id}"
}
