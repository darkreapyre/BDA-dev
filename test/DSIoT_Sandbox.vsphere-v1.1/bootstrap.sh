#!/usr/bin/env bash

echo "Starting bootstrap.sh"

# Install git
sudo apt-get install -y git

# Install Vagrant
sudo apt-get install -y vagrant
vagrant plugin install vagrant-vsphere
vagrant plugin install vagrant-address

# Install Ansible
sudo easy_install pip
sudo pip install ansible
sudo pip install pysphere pyvmomi #for vSphere integration

# Configure the zeppelin
git clone git://git.apache.org/zeppelin.git /home/vagrant/zeppelin
cd /home/vagrant/zeppelin/scripts/vagrant/zeppelin-dev
sed -i "s/hosts: all/hosts: 127.0.0.1/g" ansible-roles.yml
ansible-playbook ansible-roles.yml --conection-local
cd /home/vagrant/zeppelin/
mvn clean package -Pcassandra-spark-1.5 -Ppyspark -Phadoop-2.6 -Psparkr -DskipTests

# Deploy the cluster
echo "Deploying cluster"
cp -R /vagrant/provision /home/vagrant/ #resolve permission issues with nested Vagrant
cd /home/vagrant/provision
vagrant up --no-parallel

# Start Zeppelin
cd /home/vagrant/zeppelin
./bin/zeppelin-daemon.sh start
