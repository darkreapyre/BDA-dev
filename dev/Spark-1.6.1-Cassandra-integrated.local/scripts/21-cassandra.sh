#!/usr/bin/env bash

CASSANDRA_VER=3.5

echo "# Install DataStax Distribution of Apache Cassandra"
echo "deb http://debian.datastax.com/datastax-ddc $CASSANDRA_VER main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
curl -L https://debian.datastax.com/debian/repo_key | sudo apt-key add -
sudo apt-get update

# install Cassandra utils->sstablelevelreset, sstablemetadata, sstableofflinerelevel, sstablerepairedset, sstablesplit, token-generator.
sudo apt-get -y install datastax-ddc

# Because the Cassandra service starts automatically, stop the server and clear the data on each node
sleep 60 # wait for cassandra to fully start
sudo service cassandra stop
sudo rm -rf /var/lib/cassandra/data/system/*