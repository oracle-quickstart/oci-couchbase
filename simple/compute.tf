resource "oci_core_instance" "couchbase_server" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  compartment_id      = "${var.tenancy_ocid}"
  display_name        = "couchbase_server"
  image               = "${var.InstanceImageOCID[var.region]}"
  shape               = "${var.shape}"
  subnet_id           = "${oci_core_subnet.subnet.id}"

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file("./scripts/server.sh"))}"
  }
}
