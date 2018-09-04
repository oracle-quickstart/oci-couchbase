resource "oci_core_instance" "couchbase_server" {
  display_name        = "couchbase_server"
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  shape               = "${var.couchbase_server[shape]}"
  subnet_id           = "${oci_core_subnet.subnet.id}"
  source_details {
    source_id = "${var.images[var.region]}"
  	source_type = "image"
  }
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file("./scripts/server.sh"))}"
  }
  count = "${var.couchbase_server[node_count]}"
}

resource "oci_core_instance" "couchbase_syncgateway" {
  display_name        = "couchbase_syncgateway"
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  shape               = "${var.couchbase_server[shape]}"
  subnet_id           = "${oci_core_subnet.subnet.id}"
  source_details {
    source_id = "${var.images[var.region]}"
  	source_type = "image"
  }
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file("./scripts/server.sh"))}"
  }
  count = "${var.couchbase_server[node_count]}"
}
