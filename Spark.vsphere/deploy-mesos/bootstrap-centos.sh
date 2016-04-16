#!/usr/bin/env bash

echo "Starting bootstrap.sh"

# RUN AS ROOT
# http://www.itzgeek.com/how-tos/linux/centos-how-tos/install-virtualbox-4-3-on-centos-7-rhel-7.html
# get the latest repo
sudo rpm -Uvh https://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
#rpm -Uvh https://linuxlib.us.dell.com/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
sudo yum -y install kernel-devel kernel-headers dkms 
sudo yum -y groupinstall "Development Tools"
sudo yum update

# Install Vitualbox
# Download the repo
#wget http://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo -O /etc/yum.repos.d/virtualbox.repo

# Install Virtualbox
#yum install VirtualBox-4.3

# Rebuild the dependencies
#/usr/lib/virtualbox/vboxdrv.sh setup

# Add the user to the virtual box user group
# VERIFY
#usermod -a -G vboxusers <USER>

# Install Vagrant (ADD FULL PATH THROUGH WGET)
sudo rpm -Ivh /vagrant/vagrant_1.8.1_x86_64.rpm
