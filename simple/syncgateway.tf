locals {
  # local.ad defined in server.tf

  # Logic to choose platform or mkpl image based on
  # var.marketplace_image being empty or not
  # local.platform_image defined in server.tf
  syncgateway_image = "${var.mp_listing_resource_id == "" ? local.platform_image : var.mp_listing_resource_id}"
}

resource "oci_core_instance" "couchbase_syncgateway" {
  count               = "${var.syncgateway_count}"
  display_name        = "couchbase_syncgateway${count.index}"
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${element(data.template_file.ad_names.*.rendered, count.index)}"
  fault_domain        = "FAULT-DOMAIN-${((count.index / length(data.template_file.ad_names.*.rendered)) % local.fault_domains_per_ad) +1}"
  shape               = "${var.syncgateway_shape}"
  subnet_id           = "${oci_core_subnet.subnet.id}"

  source_details {
    source_id   = "${local.syncgateway_image}"
    source_type = "image"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"

    user_data = "${base64encode(format("%s\n%s\n%s\n",
      "#!/usr/bin/env bash",
      "version=${var.syncgateway_version}",
      file("../scripts/syncgateway.sh")
    ))}"
  }
}

data "oci_core_vnic_attachments" "couchbase_syncgateway_vnic_attachments" {
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  instance_id         = "${oci_core_instance.couchbase_syncgateway.*.id[0]}"
}

data "oci_core_vnic" "couchbase_syncgateway_vnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.couchbase_syncgateway_vnic_attachments.vnic_attachments[0],"vnic_id")}"
}
