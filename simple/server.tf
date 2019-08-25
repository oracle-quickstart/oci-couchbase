resource "oci_core_instance" "couchbase_server" {
  count               = "${var.server_count}"
  display_name        = "couchbase_server${count.index}"
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${element(data.template_file.ad_names.*.rendered, count.index)}"
  fault_domain        = "FAULT-DOMAIN-${((count.index / length(data.template_file.ad_names.*.rendered)) % local.fault_domains_per_ad) +1}"
  shape               = "${var.server_shape}"
  subnet_id           = "${oci_core_subnet.subnet.id}"

  source_details {
    source_id   = "${var.images[var.region]}"
    source_type = "image"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"

    user_data = "${base64encode(format("%s\n%s\n%s\n%s\n%s\n",
      "#!/usr/bin/env bash",
      "version=${var.server_version}",
      "adminUsername=${var.adminUsername}",
      "adminPassword=${var.adminPassword}",
      file("../scripts/server.sh")
    ))}"
  }
}

data "oci_core_vnic_attachments" "couchbase_server_vnic_attachments" {
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  instance_id         = "${oci_core_instance.couchbase_server.*.id[0]}"
}

data "oci_core_vnic" "couchbase_server_vnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.couchbase_server_vnic_attachments.vnic_attachments[0],"vnic_id")}"
}
