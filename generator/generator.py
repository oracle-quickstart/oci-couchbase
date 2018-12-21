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

    module = generateCluster(serverVersion, syncGatewayVersion, cluster)

    file = open('generated.tf', 'w')
    file.write(module)
    file.close()

def generateCluster(serverVersion, syncGatewayVersion, cluster):
    module = ''
    rallyGroup=cluster[0]['group']
    for group in cluster:
        module = module + generateGroup(serverVersion, syncGatewayVersion, group, rallyGroup)
    return module

def generateGroup(serverVersion, syncGatewayVersion, group, rallyGroup):
    if 'syncGateway' in group['services']:
        return generateSyncGateway(syncGatewayVersion, group, rallyGroup)
    else:
        return generateServer(serverVersion, group, rallyGroup)

def generateSyncGateway(syncGatewayVersion, group, rallyGroup):
    groupName = group['group']
    nodeCount = group['nodeCount']
    nodeType = group['nodeType']

    module = '\n\
resource "oci_core_instance" "' + groupName + '" {\n\
  display_name        = "' + groupName + '"\n\
  compartment_id      = "${var.compartment_ocid}"\n\
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"\n\
  shape               = "' + nodeType +'"\n\
  subnet_id           = "${oci_core_subnet.subnet.id}"\n\
  source_details {\n\
    source_id = "${var.images[var.region]}"\n\
  	source_type = "image"\n\
  }\n\
  metadata {\n\
    ssh_authorized_keys = "${var.ssh_public_key}"\n\
    user_data           = "${base64encode(format("%s\\n%s\\n%s\\n%s\\n%s\\n",\n\
      "#!/bin/bash",\n\
      "version=' + syncGatewayVersion + '",\n\
      file("../scripts/syncgateway.sh")\n\
    ))}"\n\
  }\n\
  count = "' + str(nodeCount) +'"\n\
}\n\
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

    module = '\
resource "oci_core_instance" "' + groupName + '" {\n\
  display_name        = "' + groupName + '"\n\
  compartment_id      = "${var.compartment_ocid}"\n\
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"\n\
  shape               = "' + nodeType +'"\n\
  subnet_id           = "${oci_core_subnet.subnet.id}"\n\
  source_details {\n\
    source_id = "${var.images[var.region]}"\n\
  	source_type = "image"\n\
  }\n\
  metadata {\n\
    ssh_authorized_keys = "${var.ssh_public_key}"\n\
    user_data           = "${base64encode(format("%s\\n%s\\n%s\\n%s\\n%s\\n%s\\n",\n\
      "#!/bin/bash",\n\
      "version=' + serverVersion + '",\n\
      "adminUsername=${var.adminUsername}",\n\
      "adminPassword=${var.adminPassword}",\n\
      "services=' + servicesParameter + '",\n\
      file("../scripts/server.sh")\n\
    ))}"\n\
  }\n\
  count = "' + str(nodeCount) +'"\n\
}\n\
'
    return module

main()
