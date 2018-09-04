resource "oci_core_instance" "couchbase_syncgateway" {
  display_name        = "couchbase_syncgateway"
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  shape               = "${var.couchbase_server["shape"]}"
  subnet_id           = "${oci_core_subnet.subnet.id}"
  source_details {
    source_id = "${var.images[var.region]}"
  	source_type = "image"
  }
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file("./scripts/server.sh"))}"
  }
  count = "${var.couchbase_server["node_count"]}"
}

data "oci_core_vnic_attachments" "couchbase_syncgateway_vnic_attachments" {
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  instance_id         = "${oci_core_instance.couchbase_syncgateway.*.id[0]}"
}

data "oci_core_vnic" "couchbase_syncgateway_vnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.couchbase_syncgateway_vnic_attachments.vnic_attachments[0],"vnic_id")}"
}

output "CouchbaseSyncGatewayURL" { value = "${data.oci_core_vnic.couchbase_syncgateway_vnic.public_ip_address}:4985/_admin/" }
