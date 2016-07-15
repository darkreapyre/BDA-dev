#!/usr/bin/env bash

echo "Configuring Ansible Control node"

# RUN AS ROOT
# http://www.itzgeek.com/how-tos/linux/centos-how-tos/install-virtualbox-4-3-on-centos-7-rhel-7.html
# get the latest repo
#sudo rpm -Uvh https://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm <-- Issues
#sudo rpm -Uvh https://linuxlib.us.dell.com/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm <-- Issues

sudo yum -y install epel-release
sudo yum -y install kernel-devel kernel-headers dkms git curl unzip wget
sudo yum -y groupinstall "Development Tools"
sudo yum -y update

# Install Vagrant
echo "Installing Vagrant"
sudo rpm -Uvh https://releases.hashicorp.com/vagrant/1.8.4/vagrant_1.8.4_x86_64.rpm
vagrant plugin install vagrant-vsphere
vagrant plugin install vagrant-address


# Install Ansible
echo "Installing Ansible"
sudo yum -y install ansible
sudo easy_install pip

# Install Python libraries for vSphere
echo "Installing vSpehere API"
sudo pip install pysphere pyvmomi

# To resolve permission issues with nested Vagrant
cp -R /vagrant/provision /home/vagrant/
echo "Bootstrap Node Complete"

# Provision
echo "Deploy Datastax Enterprise on VMware vSphere Virtual Machines"
cd /home/vagrant/provision
vagrant up --no-parallel
