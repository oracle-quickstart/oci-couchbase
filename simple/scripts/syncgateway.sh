#!/bin/sh

echo "Running syncGateway.sh"

version=2.0.0

echo "Got the parameters:"
echo version \'$version\'

#######################################################"
################# Turn Off the Firewall ###############"
#######################################################"
echo "Turning off the Firewall..."
service firewalld stop

#######################################################"
########### Install Couchbase Sync Gateway ############"
#######################################################"
echo "Installing Couchbase Sync Gateway..."
wget https://packages.couchbase.com/releases/couchbase-sync-gateway/${version}/couchbase-sync-gateway-enterprise_${version}_x86_64.rpm
rpm --install couchbase-sync-gateway-enterprise_${version}_x86_64.rpm

#######################################################"
########## Configure Couchbase Sync Gateway ###########"
#######################################################"

file="/opt/sync_gateway/etc/sync_gateway.json"
echo '
{
  "interface": "0.0.0.0:4984",
  "adminInterface": "0.0.0.0:4985",
  "log": ["*"]
}
' > ${file}
chmod 755 ${file}
chown sync_gateway ${file}
chgrp sync_gateway ${file}

# Need to restart to load the changes
service sync_gateway stop
service sync_gateway start
