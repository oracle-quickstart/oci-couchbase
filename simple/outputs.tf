output "CouchbaseServerURL" {
  value = "http://${data.oci_core_vnic.couchbase_server_vnic.public_ip_address}:8091"
}
