import sys
import yaml
import json

def main():
    filename=sys.argv[1]
    print('Using parameter file: ' + filename)
    with open(filename, 'r') as stream:
        parameters = yaml.load(stream)
    print('Parameters: ' + str(parameters))

    serverVersion = parameters['serverVersion']
    syncGatewayVersion = parameters['syncGatewayVersion']
    cluster = parameters['cluster']

    module = ''
    module = module + generateVariables()

    file = open('generated.tf', 'w')
    file.write(module)
    file.close()

def generateVariables():
    return '\
variable "compartment_ocid" {}\
\
# Required by the OCI Provider\
variable "tenancy_ocid" {}\
variable "user_ocid" {}\
variable "fingerprint" {}\
variable "private_key_path" {}\
variable "region" {}\
\
# Key used to SSH to OCI VMs\
variable "ssh_public_key" {}\
\
variable adminUsername { default = "couchbase" }\
variable adminPassword { default = "foo123!" }\
\
// https://docs.cloud.oracle.com/iaas/images/image/cf34ce27-e82d-4c1a-93e6-e55103f90164/\
// Oracle-Linux-7.5-2018.08.14-0\
variable "images" {\
  type = "map"\
  default = {\
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaakzrywmh7kwt7ugj5xqi5r4a7xoxsrxtc7nlsdyhmhqyp7ntobjwq"\
    us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaa2tq67tvbeavcmioghquci6p3pvqwbneq3vfy7fe7m7geiga4cnxa"\
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaasez4lk2lucxcm52nslj5nhkvbvjtfies4yopwoy4b3vysg5iwjra"\
    uk-london-1  = "ocid1.image.oc1.uk-london-1.aaaaaaaalsdgd47nl5tgb55sihdpqmqu2sbvvccjs6tmbkr4nx2pq5gkn63a"\
  }\
}\
'

def generateCluster(serverVersion, syncGatewayVersion, cluster):
    module = ''
    rallyGroup=cluster[0]['group']
    for group in cluster:
        module = modeule + generateGroup(serverVersion, syncGatewayVersion, group, rallyGroup)
    return resources

def generateGroup(serverVersion, syncGatewayVersion, group, rallyGroup):
    if 'syncGateway' in group['services']:
        return generateSyncGateway(syncGatewayVersion, group, rallyGroup)
    else:
        return generateServer(serverVersion, group, rallyGroup)

def generateSyncGateway(syncGatewayVersion, group, rallyGroup):
    groupName = group['group']
    nodeCount = group['nodeCount']
    nodeType = group['nodeType']

    module = '
resource "oci_core_instance" "' + groupName + '" {\
  display_name        = "' + groupName + '"\
  compartment_id      = "${var.compartment_ocid}"\
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"\
  shape               = "${var.couchbase_server["' + nodeType +'"]}"\
  subnet_id           = "${oci_core_subnet.subnet.id}"\
  source_details {\
    source_id = "${var.images[var.region]}"\
  	source_type = "image"\
  }\
  metadata {\
    ssh_authorized_keys = "${var.ssh_public_key}"\
    user_data           = "${base64encode(format("%s\n%s\n%s\n%s\n%s\n",\
      "#!/usr/bin/env bash",\
      "version=' + syncGatewayVersion + '",\
      file("../scripts/syncgateway.sh")\
    ))}"\
  }\
  count = "${var.couchbase_server["' + nodeCount +'"]}"\
}\
'
    return module

def generateServer(serverVersion, group, rallyAutoScalingGroup):
    groupName = group['group']
    nodeCount = group['nodeCount']
    nodeType = group['nodeType']
    dataDiskSize = group['dataDiskSize']
    services = group['services']

    servicesParameter=''
    for service in services:
        servicesParameter += service + ','
    servicesParameter=servicesParameter[:-1]

    module = '
resource "oci_core_instance" "' + groupName + '" {\
  display_name        = "' + groupName + '"\
  compartment_id      = "${var.compartment_ocid}"\
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"\
  shape               = "${var.couchbase_server["' + nodeType +'"]}"\
  subnet_id           = "${oci_core_subnet.subnet.id}"\
  source_details {\
    source_id = "${var.images[var.region]}"\
  	source_type = "image"\
  }\
  metadata {\
    ssh_authorized_keys = "${var.ssh_public_key}"\
    user_data           = "${base64encode(format("%s\n%s\n%s\n%s\n%s\n",\
      "#!/usr/bin/env bash",\
      "version=' + serverVersion + '",\
      "adminUsername=${var.adminUsername}",\
      "adminPassword=${var.adminPassword}",\
      file("../scripts/server.sh")\
    ))}"\
  }\
  count = "${var.couchbase_server["' + nodeCount +'"]}"\
}\
'
    return module

main()
