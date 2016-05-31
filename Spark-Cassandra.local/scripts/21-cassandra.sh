#!/usr/bin/env bash

echo "# Install DataStax Distribution of Apache Cassandra"
CASSANDRA_VER=3.5
echo "deb http://debian.datastax.com/datastax-ddc $CASSANDRA_VER main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
curl -L https://debian.datastax.com/debian/repo_key | sudo apt-key add -
sudo apt-get update

# install DataStax Cassandra
sudo apt-get -y install datastax-ddc
