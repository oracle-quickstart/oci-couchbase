resource "oci_core_instance" "CouchbaseServer" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "CouchbaseServer"
  image               = "${var.InstanceImageOCID[var.region]}"
  shape               = "${var.shape}"
  subnet_id           = "${oci_core_subnet.subnet.id}"

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file(var.MongoDBBootStrap))}"
  }
}
