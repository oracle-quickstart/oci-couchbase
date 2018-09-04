output "CouchbaseServerURL" { value = "${data.oci_core_vnic.vnic.public_ip_address}:8091" }
output "CouchbaseSyncGatewayURL" { value = ":4985/_admin/" }
