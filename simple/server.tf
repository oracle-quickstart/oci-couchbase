locals {
  # If ad_number is non-negative use it for AD lookup, else use ad_name.
  # Allows for use of ad_number in TF deploys, and ad_name in ORM.
  # Use of max() prevents out of index lookup call.

  # TESTING
  #ad = "${var.ad_number >= 0 ? lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[max(0,var.ad_number)],"name") : var.ad_name}"

  # Logic to choose platform or mkpl image based on
  # var.marketplace_image being empty or not
  platform_image = var.platform-images[var.region]
  server_image   = var.mp_listing_resource_id == "" ? local.platform_image : var.mp_listing_resource_id
}

resource "oci_core_instance" "couchbase_server" {
  count               = var.server_count
  display_name        = "couchbase_server${count.index}"
  compartment_id      = var.compartment_ocid
  availability_domain = element(data.template_file.ad_names.*.rendered, count.index)
  fault_domain        = "FAULT-DOMAIN-${count.index / length(data.template_file.ad_names.*.rendered) % local.fault_domains_per_ad + 1}"
  shape               = var.server_shape
  subnet_id           = oci_core_subnet.subnet.id

  source_details {
    source_id   = local.server_image
    source_type = "image"
  }

  create_vnic_details {
    subnet_id      = oci_core_subnet.subnet.id
    hostname_label = "couchbase-server${count.index}"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(
      join(
        "\n",
        [
          "#!/usr/bin/env bash",
          "version=${var.server_version}",
          "adminUsername=${var.adminUsername}",
          "adminPassword=${var.adminPassword}",
          "diskCount=${var.disk_count}",
          file("../scripts/disks.sh"),
          file("../scripts/server.sh"),
        ],
      ),
    )
  }
}

