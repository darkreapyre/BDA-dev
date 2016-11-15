#!/usr/bin/env bash

echo "Configuring Ansible Control node"

sudo yum -y install epel-release
sudo yum -y install kernel-devel kernel-headers dkms git curl unzip wget
sudo yum -y groupinstall "Development Tools"
sudo yum -y update

# Install Vagrant
echo "Installing Vagrant"
sudo rpm -Uvh https://releases.hashicorp.com/vagrant/1.8.4/vagrant_1.8.4_x86_64.rpm
#vagrant plugin install vagrant-vsphere
vagrant plugin install vagrant-aws
vagrant plugin install vagrant-address

# Install Ansible
echo "Installing Ansible"
sudo yum -y install ansible
sudo easy_install pip

# Install Python libraries for vSphere
echo "Installing vSpehere API"
sudo pip install pysphere pyvmomi

# To resolve permission issues with nested Vagrant
#vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
cp -R /vagrant/provision /home/vagrant/
echo "Bootstrap Node Complete"

# Configure AWS specifics
echo -n "Enter the AWS Accewss Key ID:"
read -p key
export AWS_KEY='$key'
echo -n "Enter the AWS Secret Access Key:"
read -sp secret
export AWS_SECRET='$secret'
echo -n "Enter the AWS Key Name:"
read -p keyname
export AWS_KEYNAME='$keyname'
echo -n "Enter the path to the AWS Key:"
read -p keypath
export AWS_KEYPATH='$keypath'
echo -n "Enter the AWS Region:"
read -p region
export AWS_REGION='$region'

# Provision
echo "Deploy IoT Analytics Architecture on EC2"
cd /home/vagrant/provision
vagrant up --no-parallel
