# Installing a Spark and Cassandra Cluster on VMware vSphere
__WORK IN PROGRESS!__  
## Introduction
This document details the process of setting up an admin node with `Vagrant` and connecting to a __Vmware vSphere 6.0__ environment to configure a virtualized Big Data ecosystem for Data Science purposes. It further details how to leverage the admin node to build out the environment using __ansible playbooks__ with the following:
- Spark 1.5.2
- Hadoop 2.6.2
- Jupyter 4.0.6
- Python 2 & 3
- Scala 2.10
- R
- RStudio Server 0.99.491
- RStudio Shiny Server 1.4.1.759
- Java 7
- Cassandra 3.5

### Requirements
The following are the basic components needed to start. 
1. A working vSphere 6.0 environment
2. Vagrant 1.8.1
3. Vagrant Plugins:
  - _vagrant-guests-photon_
  - _vagrant-vsphere_  
    __Note:__ _vagrant-vsphere_ requires the that [Nokogiri](http://www.nokogiri.org/tutorials/installing_nokogiri.html) be installed.
4. [VMware Photon](https://vmware.github.io/photon/assets/files/getting_started_with_photon_on_vsphere.pdf)
5. Ubuntu 15.04

### Create a Photon Template  
Follow the __[Vmware Photon](https://vmware.github.io/photon/assets/files/getting_started_with_photon_on_vsphere.pdf)__ Getting Started Guide to create the *photon-tmp* Virtual Machine. After the Template has been created, power it up, login and perform the following:  
- Create the *vagrant* user.
  ```sh
  $ useradd vagrant
  ```
- Configure the *vagrant* user password as *vagrant*.
  ```sh
  $ passwd vagrant
  ```
- Use `visudo` to add the *vagrant* user as a __sudoer__, by adding the following line.
  ```sh
  vagrant ALL=(ALL) NOPASSWD:ALL
  ```
- Add the __SSH Key__ to the *vagrant* user account.
  ```sh
  $ mkdir -p /home/vagrant/.ssh
  $ wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
  $ chmod 0700 /home/vagrant/.ssh
  $ chmod 0600 /home/vagrant/.ssh/authorized_keys
  $ chown -R vagrant /home/vagrant/.ssh
  ```
- Shut down thesh Virtual Machine.
  ```sh
  $ shutdown now
  ```
- Using the vSphere Web Client, convert the *photon-tmp* Virtual Machine to a Template.

### Create an Ubuntu Template  
In order to leverage the `systemd` service funcitonality within Ubuntu, the Ubuntu Template is based on Ubuntu 15.04 (Vivid Vervet). Creating the template for Vmware is exactly the same as creating a Vagrant "box". Therefore, the following is [based on](https://blog.engineyard.com/2014/building-a-vagrant-box) that process. After creating the *vivid-tmp* virtual machine, power it up, login and perform the following:  
- Install VMware Tools
```sh
$ sudo apt-get install open-vm-tools
```
- Configure the `root` and `vagrant` users
```sh
$ sudo passwd root # set to vagrant
$ su -
$ sudo visudo -f /etc/sudoers.d/vagrant
$ vagrant ALL=(ALL) NOPASSWD:ALL
```
- Update the System.
```sh
$ sudo apt-get -y update
$ sudo apt-get -y upgrade
$ sudo shutdown -r now
```
- Install the Vagrant SSH Key
```sh
$ mkdir -p /home/vagrant/.ssh
$ chmod 0700 /home/vagrant/.ssh
/$ chmod 0600 /home/vagrant/.ssh/authorized_keys
$ chown -R vagrant /home/vagrant/.ssh
```
- Install and Configure OpenSSH Server. As a good practice it is suggested to add some of the basic tools to the template, even if these are part of the overall deployment process later.
```sh
$ sudo apt-get -y install openssh-server git zip unzip curl wget
```
- Edit `/etc/ssh/sshd_config` and uncomment the following line
```sh
AuthorizedKeysFile %h/.ssh/authorized_keys
```
- Restart the `ssh` server
```sh
$ sudo service ssh restart
```
- Shut down the server and convert it to a template
```sh
$ sudo shutdown now
```
### Configure Vagrant to deploy the Templates
Using the Vagrant system, locate the `example_box`. This *dummy* box should have been created when installing the _vagrant-vsphere_ plugin and will typically be located in the ~/.vagrant.d/gems/gems/vagrant-vsphere-1.6.0/ directory. Once located, perform the following:  
- Create the _dummy box_.
```sh
$ cd ~/.vagrant.d/gems/gems/vagrant-vsphere-1.6.0/example_box
$ tar cvfz dummy.box ./metadata.json
```
- Make a new in directory your `<Vagrant Configuration Directory>` to start creating the new box and additional configuration files.
```sh
$ cd /`<Vagrant Configuration Directory>`
$ mkdir -p example_box
```
- Move the *dummy box* to this location.
```sh
$ mv dummy.box example_box/
```
- Create a `Vagrantfile` for the *dummy.box*.
```sh
$ cd example_box
$ touch Vagrantfile
```
- Create the configuration as follows, while making the necessary adjustments that are specific to your vSphere environment.
```
  Vagrant.configure("2") do |config|
    config.vm.box = 'vsphere'
    config.vm.box_url = './example_box/dummy.box'
    config.vm.provider :vsphere do |vsphere|
      # The host we're going to connect to
      vsphere.host = '<ESXi Host>'
      # The host for the new VM
      vsphere.compute_resource_name = '<vSphere Cluster>'
      # The resource pool for the new VM
      vsphere.resource_pool_name = 'VagrantVMs'
      # The template we're going to clone
      vsphere.template_name = 'photon-tmp'
      # The name of the new machine
      vsphere.name = 'admin-node'
      # vSphere login
      vsphere.user = 'administrator@vsphere.local' 
      # vSphere password
      vsphere.password = '<vSphere Administrator Passowrd>'
      # If you don't have SSL configured correctly, set this to 'true'
      vsphere.insecure = true
    end
  end
```
- Launch the virtual machines.
```sh
$ vagrant up --provider=vsphere
```
