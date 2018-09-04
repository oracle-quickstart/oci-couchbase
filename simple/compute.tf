resource "oci_core_instance" "couchbase_server" {
  display_name        = "cb"
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  shape               = "${var.shape}"
  subnet_id           = "${oci_core_subnet.subnet.id}"
  source_details {
    source_id = "${var.Images[var.region]}"
  	source_type = "image"
  }
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file("./scripts/server.sh"))}"
  }
  count = "${var.node_count}"
}

data "oci_core_vnic_attachments" "vnic_attachments" {
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  instance_id         = "${oci_core_instance.couchbase_server.*.id[0]}"
}

data "oci_core_vnic" "vnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.vnic_attachments.vnic_attachments[0],"vnic_id")}"
}
