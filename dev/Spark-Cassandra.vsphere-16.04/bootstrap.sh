#!/usr/bin/env bash

echo "Starting bootstrap.sh"

# RUN AS ROOT
# http://www.itzgeek.com/how-tos/linux/centos-how-tos/install-virtualbox-4-3-on-centos-7-rhel-7.html
# get the latest repo
#sudo rpm -Uvh https://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm <-- Issues
#sudo rpm -Uvh https://linuxlib.us.dell.com/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm <-- Issues

sudo yum -y install epel-release
sudo yum -y install kernel-devel kernel-headers dkms 
sudo yum -y groupinstall "Development Tools"
sudo yum -y update

# Install Vitualbox
# Download the repo
#wget http://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo -O /etc/yum.repos.d/virtualbox.repo

# Install Virtualbox
#yum install VirtualBox-4.3

# Rebuild the dependencie
#/usr/lib/virtualbox/vboxdrv.sh setup

# Add the user to the virtual box user group
# VERIFY
#usermod -a -G vboxusers vagrant

# Install Vagrant (ADD FULL PATH THROUGH WGET)
sudo rpm -Uvh https://releases.hashicorp.com/vagrant/1.8.4/vagrant_1.8.4_x86_64.rpm
vagrant plugin install vagrant-vsphere
vagrant plugin install vagrant-address

# Install Ansible
sudo yum -y install ansible #install necessary python dependancies
sudo easy_install pip
sudo pip install pysphere pyvmomi

# To resolve permission issues with nested Vagrant
cp -R /vagrant/provision /home/vagrant/
echo "Bootstrap Complete"

# Deploy
echo "Deploy Hadoop/Spark/Cassandra on Vmware vSphere Virtual Machines"
cd /home/vagrant/provision
vagrant up --no-parallel

# Manually check ip address of a VM
#vagrant address [name]
#vagrant ssh-config [name] | grep HostName | awk '{ print "[name]:" $2}'
