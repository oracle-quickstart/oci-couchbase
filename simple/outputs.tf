output "CouchbaseServerURL" {
  value = "http://${oci_core_instance.couchbase_server[0].public_ip}:8091"
}

output "CouchbaseSyncGatewayURL" {
  value = "http://${element(
    coalescelist(
      oci_core_instance.couchbase_syncgateway.*.public_ip,
      ["not_deployed"],
    ),
    0,
  )}:4984"
}

