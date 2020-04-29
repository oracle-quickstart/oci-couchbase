resource "oci_core_volume" "serverVolume" {
  count               = var.server_count * var.disk_count
  availability_domain = element(data.template_file.ad_names.*.rendered, count.index)
  compartment_id      = var.compartment_ocid
  display_name        = "server-${count.index % var.server_count}-volume${floor(count.index / var.server_count)}"
  size_in_gbs         = var.disk_size
}

resource "oci_core_volume_attachment" "serverAttachment" {
  count           = var.server_count * var.disk_count
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.couchbase_server[count.index % var.server_count].id
  volume_id       = oci_core_volume.serverVolume[count.index].id
}

