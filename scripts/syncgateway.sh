echo "Running syncGateway.sh"

echo "Got the parameters:"
echo version \'$version\'

#######################################################"
################# Turn Off the Firewall ###############"
#######################################################"
echo "Turning off the Firewall..."
service firewalld stop
chkconfig firewalld off

#######################################################"
########### Install Couchbase Sync Gateway ############"
#######################################################"
echo "Installing Couchbase Sync Gateway..."
wget https://packages.couchbase.com/releases/couchbase-sync-gateway/${version}/couchbase-sync-gateway-enterprise_${version}_x86_64.rpm
rpm --install couchbase-sync-gateway-enterprise_${version}_x86_64.rpm
