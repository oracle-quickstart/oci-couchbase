data "oci_core_vnic_attachments" "couchbase_server_vnic_attachments" {
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  instance_id         = "${oci_core_instance.couchbase_server.*.id[0]}"
}

data "oci_core_vnic" "couchbase_server_vnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.couchbase_server_vnic_attachments.vnic_attachments[0],"vnic_id")}"
}

output "CouchbaseServerURL" { value = "${data.oci_core_vnic.couchbase_server_vnic.public_ip_address}:8091" }
output "CouchbaseSyncGatewayURL" { value = ":4985/_admin/" }
