# Installing a DataStax Analytics and Flink Complex Event Processing Cluster on VMware vSphere
__WORK IN PROGRESS!__  
## Introduction
This document details the process of setting up an ansible control node with `Vagrant` and connecting to a __Vmware vSphere 6.0__ environment to configure a virtualized Big Data ecosystem for the purpose of using it during Data Science for the Internet of Things (DSIoT) course. It further details how to leverage the ansible control node to build out the environment using __ansible playbooks__ with the following:

- Jupyter 4.0.6
- Zeppelin 0.7-SNAPSHOT
- Python 2.7
- Scala 2.10.5
- R __TBD__
- RStudio Server 0.99.491
- RStudio Shiny Server 1.4.1.759
- Java 8
- DataStax Enterprise 5.0.1 (incl. Cassandra 3.0; Titan Graph __VERSION TBD__, Spark 1.6.1 and Solr __VERISON TBD__)
- DataStax Opscenter 6.0
- Flink 1.0

This documnet further details some of the additional processes and tools used in order to fully leverage the architecture, 

### Requirements
The following are the basic components needed to start. 
1. A working vSphere 6.0 environment
2. Vagrant 1.8.4
3. Vagrant Plugins:
  - _vagrant-vsphere_  
    __Note:__ _vagrant-vsphere_ requires the that [Nokogiri](http://www.nokogiri.org/tutorials/installing_nokogiri.html) be installed.
4. Ubuntu 14.04 (Trusty)

### Create an Ubuntu Template  
#### Virtual Machine Configuration
Below are the recommended virtual machine configuration settings to ensure that all hardware reuquirements are met:
- 16 vCPU
- 64GB Virtual RAM
- 250GB Virtual Disk

#### Ubuntu Installation and Configuration
Creating the template for Vmware is exactly the same as creating a Vagrant "box". Therefore, the following is [based on](https://blog.engineyard.com/2014/building-a-vagrant-box) that process. After creating the *trusty-tmp* virtual machine, power it up, login and perform the following:  
- Install VMware Tools. As a good practice it is suggested to add some of the basic tools to the template, even if these are part of the overall deployment process later.
```sh
$ sudo apt-get install open-vm-tools git zip unzip wget curl acl
```
- Configure the `root` and `vagrant` users
```sh
$ sudo passwd root # set to vagrant
$ sudo visudo -f /etc/sudoers.d/vagrant
$ vagrant ALL=(ALL) NOPASSWD:ALL
```
- Update the System.
```sh
$ sudo apt-get -y update
$ sudo apt-get -y upgrade
$ sudo shutdown -r now
```
- Install the Public Vagrant SSH Key
```sh
$ mkdir -p /home/vagrant/.ssh
$ chmod 0700 /home/vagrant/.ssh
$ wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
$ chmod 0600 /home/vagrant/.ssh/authorized_keys
$ chown -R vagrant /home/vagrant/.ssh
```
- Install and Configure OpenSSH Server (If not installed during intial Ubuntu installation)
.
```sh
$ sudo apt-get -y install openssh-server git zip unzip curl wget acl
```
- Edit `/etc/ssh/sshd_config` and uncomment the following line
```sh
AuthorizedKeysFile %h/.ssh/authorized_keys
```
- Restart the `ssh` server
```sh
$ sudo service ssh restart
```
- Remove the `trusty-tmp` entry in `/etc/hosts`
- Shut down the server and convert it to a template
```sh
$ sudo shutdown now
```

### Configure the Ansible Control node
A dedicated Ansible Control node is required to load and execute the Ansible deployment. To this end a dedicated Vagrant virtual machine(Centos 7.2) is created.  
To launch the Ansible Control node without starting the cluster deployment:
1. Edit the `bootstrap.sh` file in the root directory, and comment out the last line as follows:
```
#vagrant up --no-parallel
```
2. Start the Ansible Control node by typing:
```
$ vagrant up
```

During the installation process, Vagrant, Ansible and the necessary Python API's to communicate with VMware are installed as well as the `provision` directory is copied to the Ansible Control node. This directory contains all the necessary code to deploy the cluster. 

--provision
 |
 |--example_box
 | |
 | -dummy.box
 |
 |--roles





The next section describes how to 




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

#Appendix A: Create a "fat" jar for the 'spark-cassandra-connector'



```
...

        case x => old(x)
      }
    }
  )

...

```


```
...

        case x => old(x)
      }
    },
    assemblyShadeRules in assembly := {
      val shadePackage = "shade.com.datastax.connector"
      Seq(
        ShadeRule.rename("com.google.**" -> s"$shadePackage.google.@1").inAll
      )
    }
  )

...

```