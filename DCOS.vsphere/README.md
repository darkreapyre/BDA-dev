# Installation of the Mesosphere DC/OS on vSphere
__WORK_IN_PROGRESS!!!__

## Overview
This repository outlines the installation process of getting open source [DC/OS](https://mesosphere.com/blog/2016/04/19/open-source-dcos/) containers with Spark, running on Vmware vSphere. In essence this document details taking the installation steps outlined in [The Mesosphere guide to getting started with DC/OS](https://mesosphere.com/blog/2016/04/20/mesosphere-guide-getting-started-dcos/) and porting them to run on vSphere using Ansible as the deployment framework.  It is important to __note__ that this document outlines the DC/OS installation only, for testing and evaluation purposes, to verify if this is indeed the correct architecture for Spark and Hadoop etc.

## Requirements
The following are the basic components needed to start. 
1. A working vSphere 6.0 environment
2. Vagrant 1.8.1
3. Vagrant Plugins:
  - _vagrant-guests-photon_
  - _vagrant-vsphere_  
    __Note:__ _vagrant-vsphere_ requires the that [Nokogiri](http://www.nokogiri.org/tutorials/installing_nokogiri.html) be installed.
4. [Centos 7 (1511) Minimal Install](http://buildlogs.centos.org/rolling/7/isos/x86_64/CentOS-7-x86_64-Minimal.iso)

## Create the Centos 7 Template
Creating the template for Vmware is exactly the same as creating a Vagrant "box". Therefore, the following is [based on](http://www.hostedcgi.com/how-to-create-a-centos-7-0-vagrant-base-box/) that process. After creating the *centos7-tmp* virtual machine, power it up, complete a minimal Centos 7 installation, login as `root` and perform the following:  

__Note:__ When installing Centos 7, make sure to set the `root` password to `vagrant`.
- Install VMware Tools.
```sh
$ yum -y install open-vm-tools
```
- Configure the `vagrant` user.
```sh
$ useradd vagrant
$ passwd vagrant # Set the password to vagrant
```
- Add the `vagrant` user to `/etc/sudoers`.
```sh
$ echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
```
- To allow Vagrant to apply changes during startup, comment out `requiretty` in the `/etc/sudoers` file.
```sh
$ sed -i 's/^\(Defaults.*requiretty\)/#\1/' /etc/sudoers
```
- Set `SELinux` to *permissive* mode.
```sh
$ sed -i -e 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config
```
- Create the `vagrant` user public key configuration.
```sh
$ mkdir /home/vagrant/.ssh && chmod 700 /home/vagrant/.ssh # Create the `.ssh` directory
$ curl https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub >> /home/vagrant/.ssh/authorized_keys # get the public key
$ chmod 600 /home/vagrant/.ssh/authorized_keys # Set the permission
$ chown -R vagrant:vagrant /home/vagrant # Set the correct ownership
```
- Load the basic packages.
```sh
$ yum -y install git wget curl zip unzip ntp openssh-clients
```
- Enable `ssh` and `ntp` on startup.
```sh
$ chkconfig ntpd on && chkconfig sshd on
```
- Disable `iptables` (if it's loaded).
```sh
chkconfig iptables off && chkconfig ip6tables off
```
- Prepare the virtual machine template by deleting unique and and temporary data.
```sh
$ yum update # Update the system
$ yum clean all
$ rm -f /etc/udev/rules.d/70* # Remove `udev` hardware rules
$ sed -i '/^\(HWADDR\|UUID\)=/d' /etc/sysconfig/network-scripts/ifcfg-enXXX # Remove MAC, UUID from ifcfg; where XXX is the name 
$ rm -f /etc/ssh/*key* # Remove host keys
$ /usr/sbin/logrotate -f /etc/logrotate.conf # Start logrotate to shrink logspace used
$ rm -rf /tmp/*  # Clean up the `tmp` directory
$ rm -rf /var/tmp/*  
$ rm -f ~root/.bash_history # Clean `root` bash and ssh history
$ unset HISTFILE
$ rm -rf ~root/.ssh/ 
$ rm -f ~root/anaconda-ks.cfg # Remove the kickstart file
```
__Note:__ The interface name (ifcfg-enXXX) can be found by running `ip link`.
- Shut down the server and convert it to a template
```sh
$ shutdown -P now
```

## Configure the *bootstrap node*
See the [system requirements](https://dcos.io/docs/1.7/administration/installing/custom/system-requirements/) for the *bootstrap node*. __Note__, however that for this architecture, we will not be configuring the the *HAProxy* on the *bootstrap node* as the docment suggest. The `Vagrantfile` in this repository is already configured to launch the __ansible__ node to provision the virtual machines. To tweak the confgiration, go to `<YOUR_BOX_FOLDER/provision>`, and edit the `Vagrantfile` to change the parameters: 

| Parameter  | Description | Default value |
|------------|-------------|:-------------:|
| *Total* | The total number of virtual machines to create, including *bootstratp*, *masters* and *workers*; maximum of __9__.  | 6 |
| *Username* | The vSphere user with sufficient privlidges to create/clone virtual machines. | "Administrator@vsphere.local" |
| *Password* | The password for the above user.  | NA |
| *Cluster* | The name of the ESXi Cluster where the virtual machines will be running. | NA |
| *Template* | The name of the teamplate the created in the previous section. | "centos7-tmp" |
| *Host* | The name of the ESXi Host or vCenter Host. | NA |
| *Master_User* | The master user for the cluster. This user will be used for DC/OS SSH access to all nodes. | "cluster" |
| *Master_Password* | The master user password. | "cluster" |
| *DCOS_Installer* | The URL for the current version of the *dcos_generate_config.sh* file. | NA |

By default, __6__ virtual machines are required,  he minimums are as follows:

| Name | Role | Quantity |
|------|------|:--------:|
| *bootstrap* | Bootstrap Docker and DC/OS. | 1 |
| *master-[1-3]* | DC/OS Master | 3 |
| *worker-[1-2]* | DC/OS Worker and HAProxy | 2 |
Once the `Vagrantfile` is configured, simply execute `vagrant up` to provision the __ansible__ control node. This node will provision the required amount of virtual machines on vSphere and prepare the necessary cmponents for the the *bootstrap* host to complete the DC/OS installation. 