#!/usr/bin/env bash

# http://stackoverflow.com/questions/16483119/example-of-how-to-use-getopts-in-bash
# -t: type of node <MASTER|SLAVE>
# -n: # of slaves <1-9>
# -a: main IP address (i.e. 10.20.30.10_) used for master (10.20.30.100) & slaves (10.20.30.10[1-9])
# -m: name for the master (i.e. "master")
# -s: name for the slaves (i.e. "slave")

usage() { echo "Usage: $0 [-t <MASTER|SLAVE>] [-n <1-9>] [-a <ip_address>] [-m <string>] [-s <string>]" 1>&2; exit 1; }

while getopts ":t:n:a:m:s:b:c:" option; do
  case $option in
    t) TYPE=$OPTARG
       if [[ "$TYPE" != "MASTER" && "$TYPE" != "SLAVE" ]]; then
         usage
       fi ;;
    n) N=$OPTARG
       ((N >= 1 && N <= 9)) || usage ;;
    a) IP=$OPTARG
       if ! [[ $IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
         usage
       fi ;;
    m) MASTER=$OPTARG ;;
    s) SLAVE=$OPTARG ;;
    b) NIP=$OPTARG
       if ! [[ $NIP =~ ]]
    c) 
    *) usage ;;
  esac
done

shift $((OPTIND-1))

if [ -z "$TYPE" ] || [ -z "$N" ] || [ -z "$IP" ] || [ -z "$MASTER" ] || [ -z "$SLAVE" ]; then
  usage
fi

#echo "TYPE=$TYPE - N=$N - IP=$IP - MASTER=$MASTER - SLAVE=$SLAVE"

STARTTIME=$(date +%s)
LINE="····································································································"
echo $LINE
echo "START provisioning $(date +'%Y/%m/%d %H:%M:%S')"
echo $LINE

# create /etc/hosts with master & slaves
sudo sh -c "echo 127.0.0.1 localhost > /etc/hosts"
sudo sh -c "echo ${IP}0 $MASTER >> /etc/hosts"
for i in $(seq 1 $N); do
  SLAVE_NAME="${SLAVE}-${i}"
  sudo sh -c "echo ${IP}${i} $SLAVE_NAME >> /etc/hosts"
done

# scripts
#SCRIPTS=$(find /vagrant/scripts/* -type f)

# common scripts for master and slaves
SCRIPTS="00-init.sh 10-java-python-scala.sh 20-spark.sh"

SCRIPTS_PATH=/vagrant/scripts
SSH_KEYS_PATH=/vagrant/ssh_keys
export SPARK_HOME=/opt/spark

if ! [ -d $SSH_KEYS_PATH ]; then
  sudo -u vagrant mkdir $SSH_KEYS_PATH
fi

if [[ "$TYPE" == "MASTER" ]]; then
  # create key and copy to /vagrant/ssh_keys
  #su vagrant -c "ssh-keygen -t rsa -P '' -f /home/vagrant/.ssh/id_rsa"
  sudo -u vagrant sh -c "ssh-keygen -t rsa -P '' -f /home/vagrant/.ssh/id_rsa"
  #su vagrant -c "cp /home/vagrant/.ssh/id_rsa.pub $SSH_KEYS_PATH/authorized_keys"
  sudo -u vagrant sh -c "cp /home/vagrant/.ssh/id_rsa.pub $SSH_KEYS_PATH/authorized_keys"

  SCRIPTS="$SCRIPTS 
  30-R.sh
  40-jupyter.sh
  41-test_helper.sh
  42-rise.sh
  43-spark-kernel.sh
  44-irkernel.sh
  45-jupyter-extensions.sh
  50-rstudio-server.sh
  51-shiny-server.sh
  99-clean.sh
  "
else
  # copy the authorized_keys to ~/.ssh
  #su vagrant -c "cat $SSH_KEYS_PATH/authorized_keys >> /home/vagrant/.ssh/authorized_keys"
  sudo -u vagrant sh -c "cat $SSH_KEYS_PATH/authorized_keys >> /home/vagrant/.ssh/authorized_keys"
  #su vagrant -c "chmod 600 /home/vagrant/.ssh/authorized_keys"
  sudo -u vagrant sh -c "chmod 600 /home/vagrant/.ssh/authorized_keys"

  SCRIPTS="$SCRIPTS 99-clean.sh"
fi

# run scripts
echo "Scripts to install:"
echo $SCRIPTS
for SCRIPT in $SCRIPTS; do
  SCRIPT_NAME=$(basename $SCRIPT)
  if ! [[ ${SCRIPT_NAME} =~ ^# ]]; then
    echo $LINE 
    echo "Running... $SCRIPT_NAME"
    echo $LINE
    #echo $SCRIPT_NAME
    $SCRIPTS_PATH/$SCRIPT
    echo "Finished... $SCRIPT_NAME"
    #echo $LINE; echo
  fi
done

# Initialize cassandra muli-node cluster (single data center)
# configure Cassandra (see http://docs.datastax.com/en/cassandra/3.x/cassandra/initialize/initSingleDS.html); 
# https://www.digitalocean.com/community/tutorials/how-to-use-the-apache-cassandra-one-click-application-image
# and https://github.com/danielrmeyer/cassandra-analytics/blob/c337dfe726e7846f51cdb303741d78284da8a8f2/provisioning/setup_cassandra.sh
#NODE_IP = `hostname -I | cut -d' ' -f2`
NODE_IP=$(ip -4 address show eth1 | grep 'inet' | sed 's/.*inet \([0-9\.]\+\).*/\1/')
sudo sed -i "s/cluster_name: 'Test Cluster'/cluster_name: 'MyCassandraCluster'/g" /etc/cassandra/cassandra.yaml
#Seed nodes are used to bootstrap new nodes into the cluster. Set the master as the seed node.
#sudo sed -i "s/seeds: \"127.0.0.1\"/seeds: \"${IP}0\"/g" /etc/cassandra/cassandra.yaml
sudo sed -i "s/seeds: \"127.0.0.1\"/seeds: \"10.20.30.100\"/g" /etc/cassandra/cassandra.yaml
sudo sed -i "s/listen_address: localhost/listen_address:/g" /etc/cassandra/cassandra.yaml
sudo sed -i "s/rpc_address: localhost/rpc_address: 0.0.0.0/g" /etc/cassandra/cassandra.yaml
sudo sed -i "s/# broadcast_rpc_address: 1.2.3.4/broadcast_rpc_address: $NODE_IP/g" /etc/cassandra/cassandra.yaml
# Start Cassandra Cluster
sudo service cassandra start

# post-provision of the Spark MASTER
if [[ "$TYPE" == "MASTER" ]]; then
  # create $SPARK_HOME/conf/slaves file
  if [ -d $SPARK_HOME ]; then
    # create $SPARK_HOME/conf/slaves file
    for i in $(seq 1 $N); do
      SLAVE_NAME="${SLAVE}-${i}"
      sudo sh -c "echo $SLAVE_NAME >> $SPARK_HOME/conf/slaves"
      echo "$SLAVE_NAME >> $SPARK_HOME/conf/slaves"
      #ssh-copy-id -i ~/.ssh/id_rsa.pub -o "StrictHostKeyChecking=no" vagrant@"${SLAVE}-${i}"
    done
  fi  
fi

echo $LINE
echo "END provisioning $(date +'%Y/%m/%d %H:%M:%S')"
echo "TOTAL TIME: $(($(date +%s) - $STARTTIME)) seconds"
echo $LINE

