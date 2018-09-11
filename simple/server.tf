resource "oci_core_instance" "couchbase_server" {
  display_name        = "couchbase_server"
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
    user_data           = "${base64encode(format("%s\n%s%s\n%s%s\n%s%s\n",
      file("../scripts/server.sh"),
      "version=", ${var.couchbase_server["version"]},
      "adminUsername=", ${var.couchbase_server["adminUsername"]},
      "adminPassword=", ${var.couchbase_server["adminPassword"]},
    ))}"
  }
  count = "${var.couchbase_server["node_count"]}"
}

data "oci_core_vnic_attachments" "couchbase_server_vnic_attachments" {
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  instance_id         = "${oci_core_instance.couchbase_server.*.id[0]}"
}

data "oci_core_vnic" "couchbase_server_vnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.couchbase_server_vnic_attachments.vnic_attachments[0],"vnic_id")}"
}

output "CouchbaseServerURL" { value = "http://${data.oci_core_vnic.couchbase_server_vnic.public_ip_address}:8091" }
