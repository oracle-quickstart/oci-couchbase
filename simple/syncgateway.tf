locals {
  # local.ad defined in server.tf

  # Logic to choose platform or mkpl image based on
  # var.marketplace_image being empty or not
  syncgateway_image = var.mp_listing_resource_id
}

resource "oci_core_instance" "couchbase_syncgateway" {
  count               = var.syncgateway_count
  display_name        = "couchbase_syncgateway${count.index}"
  compartment_id      = var.compartment_ocid
  availability_domain = element(data.template_file.ad_names.*.rendered, count.index)
  fault_domain        = "FAULT-DOMAIN-${count.index % 3 + 1}"
  shape               = var.syncgateway_shape
  subnet_id           = oci_core_subnet.subnet.id

  source_details {
    source_id   = local.syncgateway_image
    source_type = "image"
  }

  create_vnic_details {
    subnet_id      = oci_core_subnet.subnet.id
    hostname_label = "couchbase-syncgateway${count.index}"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(
      join(
        "\n",
        [
          "#!/usr/bin/env bash",
          "version=${var.syncgateway_version}",
          file("../scripts/syncgateway.sh"),
        ],
      ),
    )
  }
}

