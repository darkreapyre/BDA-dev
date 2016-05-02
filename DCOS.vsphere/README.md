# Installation of the Mesosphere DC/OS on vSphere
__WORK_IN_PROGRESS!!!__

## Overview
This repository outlines the installation process of getting open source [DC/OS](https://mesosphere.com/blog/2016/04/19/open-source-dcos/) containers with Spark, running on Vmware vSphere. In essence this document details taking the installation steps outlined in [The Mesosphere guide to getting started with DC/OS](https://mesosphere.com/blog/2016/04/20/mesosphere-guide-getting-started-dcos/) and porting them to run on vSphere using Ansible as the deployment framework.  It is important to __note__ that this document outlines the DC/OS installation only, for testing and evaluation purposes, to verify if this is indeed the correct architecture for Spark and Hadoop etc.

## Configure the *bootstrap node*
See the [system requirements](https://dcos.io/docs/1.7/administration/installing/custom/system-requirements/) for the *bootstrap node*. __Note__, however that for this architecture, we will not be configuring the the *HAProxy* on the *bootstrap node*. The `Vagrantfile` in this repository is already configured. 