#!/bin/sh

echo "Running server.sh"

adminUsername="couchbase"
adminPassword="couchbase"
version="5.5.0"

echo "Got the parameters:"
echo adminUsername \'$adminUsername\'
echo adminPassword \'$adminPassword\'
echo version \'$version\'

#######################################################"
################# Turn Off the Firewall ###############"
#######################################################"
echo "Turning off the Firewall..."
service firewalld stop

#######################################################"
############## Install Couchbase Server ###############"
#######################################################"
echo "Installing Couchbase Server..."

wget https://packages.couchbase.com/releases/${version}/couchbase-server-enterprise-${version}-centos6.x86_64.rpm
rpm --install couchbase-server-enterprise-${version}-centos6.x86_64.rpm

#######################################################"
############ Turn Off Transparent Hugepages ###########"
#######################################################"
echo "Turning off transparent hugepages..."

echo "#!/bin/bash
### BEGIN INIT INFO
# Provides:          disable-thp
# Required-Start:    $local_fs
# Required-Stop:
# X-Start-Before:    couchbase-server
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Disable THP
# Description:       disables Transparent Huge Pages (THP) on boot
### END INIT INFO
echo 'never' > /sys/kernel/mm/transparent_hugepage/enabled
echo 'never' > /sys/kernel/mm/transparent_hugepage/defrag
" > /etc/init.d/disable-thp
chmod 755 /etc/init.d/disable-thp
service disable-thp start
chkconfig disable-thp on

#######################################################
################# Set Swappiness to 0 #################
#######################################################
echo "Setting swappiness to 0..."

sysctl vm.swappiness=0
echo "
# Required for Couchbase
vm.swappiness = 0
" >> /etc/sysctl.conf

#######################################################
############## Configure Couchbase Server #############
#######################################################
echo "Configuring Couchbase Server..."

rallyPublicDNS="couchbase-server.couchbase.couchbase.oraclevcn.com"
nodeDNS=`hostname`".couchbase.couchbase.oraclevcn.com"

echo "Using the settings:"
echo rallyDNS \'$rallyPublicDNS\'
echo nodeDNS \'$nodePublicDNS\'

cd /opt/couchbase/bin/

echo "Running couchbase-cli node-init"
output=""
while [[ ! $output =~ "SUCCESS" ]]
do
  output=`./couchbase-cli node-init \
    --cluster=$nodeDNS \
    --node-init-hostname=$nodeDNS \
    --user=$adminUsername \
    --pass=$adminPassword`
  echo node-init output \'$output\'
  sleep 10
done

if [[ $rallyDNS == $nodeDNS ]]
then
  totalRAM=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  dataRAM=$((50 * $totalRAM / 100000))
  indexRAM=$((25 * $totalRAM / 100000))

  echo "Running couchbase-cli cluster-init"
  ./couchbase-cli cluster-init \
    --cluster=$nodeDNS \
    --cluster-username=$adminUsername \
    --cluster-password=$adminPassword \
    --cluster-ramsize=$dataRAM \
    --cluster-index-ramsize=$indexRAM \
    --services=${services}
else
  echo "Running couchbase-cli server-add"
  output=""
  while [[ $output != "Server $nodeDNS:8091 added" && ! $output =~ "Node is already part of cluster." ]]
  do
    output=`./couchbase-cli server-add \
      --cluster=$rallyDNS \
      --user=$adminUsername \
      --pass=$adminPassword \
      --server-add=$nodeDNS \
      --server-add-username=$adminUsername \
      --server-add-password=$adminPassword \
      --services=data,index,query,fts,analytics,eventing`
    echo server-add output \'$output\'
    sleep 10
  done

  echo "Running couchbase-cli rebalance"
  output=""
  while [[ ! $output =~ "SUCCESS" ]]
  do
    output=`./couchbase-cli rebalance \
    --cluster=$rallyDNS \
    --user=$adminUsername \
    --pass=$adminPassword`
    echo rebalance output \'$output\'
    sleep 10
  done

fi
