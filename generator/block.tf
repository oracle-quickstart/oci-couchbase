resource "oci_core_volume" "group1Block" {
  count               = "${oci_core_instance.group1.count}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "group1Block${count.index}"
}

resource "oci_core_volume_attachment" "group1" {
  attachment_type = "iscsi"
  instance_id     = "${oci_core_instance.group1.*.id[count.index]}"
  volume_id       = "${oci_core_volume.group1Block.*.id[count.index]}"
  connection {
    type        = "ssh"
    host        = "${oci_core_instance.group1.*.public_ip[count.index]}"
    user        = "opc"
    private_key = "${file("~/.ssh/id_rsa")}"
  }
  # register and connect the iSCSI block volume
  provisioner "remote-exec" {
    inline = [
      "sudo iscsiadm -m node -o new -T ${self.iqn} -p ${self.ipv4}:${self.port}",
      "sudo iscsiadm -m node -o update -T ${self.iqn} -n node.startup -v automatic",
      "sudo iscsiadm -m node -T ${self.iqn} -p ${self.ipv4}:${self.port} -l",
    ]
  }
  # initialize partition and file system
  provisioner "remote-exec" {
    inline = [
      "set -x",
      "export DEVICE_ID=ip-${self.ipv4}:${self.port}-iscsi-${self.iqn}-lun-1",
      "export HAS_PARTITION=$(sudo partprobe -d -s /dev/disk/by-path/$${DEVICE_ID} | wc -l)",
      "if [ $HAS_PARTITION -eq 0 ] ; then",
      "  (echo g; echo n; echo ''; echo ''; echo ''; echo w) | sudo fdisk /dev/disk/by-path/$${DEVICE_ID}",
      "  while [[ ! -e /dev/disk/by-path/$${DEVICE_ID}-part1 ]] ; do sleep 1; done",
      "  sudo mkfs.xfs /dev/disk/by-path/$${DEVICE_ID}-part1",
      "fi",
    ]
  }
  # mount the partition
  provisioner "remote-exec" {
    inline = [
      "set -x",
      "export DEVICE_ID=ip-${self.ipv4}:${self.port}-iscsi-${self.iqn}-lun-1",
      "sudo mkdir -p /mnt/vol1",
      "export UUID=$(sudo /usr/sbin/blkid -s UUID -o value /dev/disk/by-path/$${DEVICE_ID}-part1)",
      "echo 'UUID='$${UUID}' /mnt/vol1 xfs defaults,_netdev,nofail 0 2' | sudo tee -a /etc/fstab",
      "sudo mount -a",
    ]
  }
  # unmount and disconnect on destroy
  provisioner "remote-exec" {
    when       = "destroy"
    on_failure = "continue"
    inline = [
      "set -x",
      "export DEVICE_ID=ip-${self.ipv4}:${self.port}-iscsi-${self.iqn}-lun-1",
      "export UUID=$(sudo /usr/sbin/blkid -s UUID -o value /dev/disk/by-path/$${DEVICE_ID}-part1)",
      "sudo umount /mnt/vol1",
      "if [[ $UUID ]] ; then",
      "  sudo sed -i.bak '\\@^UUID='$${UUID}'@d' /etc/fstab",
      "fi",
      "sudo iscsiadm -m node -T ${self.iqn} -p ${self.ipv4}:${self.port} -u",
      "sudo iscsiadm -m node -o delete -T ${self.iqn} -p ${self.ipv4}:${self.port}",
    ]
  }
}