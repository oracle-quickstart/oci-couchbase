data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.compartment_ocid
}

data "template_file" "ad_names" {
  count = length(
    data.oci_identity_availability_domains.availability_domains.availability_domains,
  )
  template = data.oci_identity_availability_domains.availability_domains.availability_domains[count.index]["name"]
}

