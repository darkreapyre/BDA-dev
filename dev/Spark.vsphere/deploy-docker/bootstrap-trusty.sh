#!/usr/bin/env bash

echo "Starting bootstrap.sh"

# The following needs to be tested to change hostnames in Virtual Machines
# Configure machine name in /etc/hostname and /etc/hosts
#oldhostname="<boxname>"
#newhostname="<machine_name>"
#
#for filename in /etc/hostname /etc/hosts; do
#    grep "$oldhostname" $filename
#    rc=$?
#    if [ $rc -eq 0 ]; then
#        sed -i.original "s/${oldhostname}/${newhostname}/" $filename
#    fi
#done

echo "Update system"
sudo apt-get -y update
sudo apt-get -y upgrade

echo "Install packages"
sudo apt-get -y install dos2unix libxml2 libxml2-dev libxslt-dev git zip unzip curl rsync wget build-essential python-pip python-dev ruby-dev zlib1g-dev liblzma-dev

# Install vagrant and virtualbox AS root
#sudo apt-get install  vagrant virtualbox virtualbox-dkms
##RESTART REQUIRED

#first try install nokogiri
#sudo gem install nokogiri

# Install Vagrant vSphere Plugin AS root
#vagrant plugin install vagrant-vsphere






# The followig must be verified if needed


#echo "Install Java"
#JAVA_JDK=openjdk-7-jdk
#HOME=/home/vagrant
#BASHRC=$HOME/.bashrc
#JAVA_DIR=/usr/lib/jvm/java-7-openjdk-i386
#SYSTEM=`uname -m`

#if [ "$SYSTEM" == "x86_64" ]; then 
#  JAVA_DIR=/usr/lib/jvm/java-7-openjdk-amd64
#fi

#sudo apt-get -y install "$JAVA_JDK" libjansi-java

#export JAVA_HOME=$JAVA_DIR

#if ! [ "$JAVA_HOME" ]; then
#if ! grep -q 'export JAVA_HOME' $BASHRC; then
#  echo "export JAVA_HOME=$JAVA_HOME" >> $BASHRC
#fi

#echo "Install python packages"
#sudo pip install paramiko PyYAML Jinja2 httplib2 ansible==1.9.1 boto==2.34.0

#echo "Install Maven"
# maven package's location 
#MAVEN_LOC=http://apache.arvixe.com/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz 
 
# maven package's name 
#MAVEN_FN=$(basename "$MAVEN_LOC") 
 
#mkdir -p /vagrant/shared 
#cd /vagrant/shared 
 
# maven's dir after uncompression 
#IFS='-' read -a array <<< "$MAVEN_FN" 
#MAVEN_DIR=/vagrant/shared/${array[0]}-${array[1]}-${array[2]} 
 
#if [ -d $MAVEN_DIR ] && [ `readlink -f /usr/bin/mvn` == "$MAVEN_DIR/bin/mvn" ]; then
#  echo "Maven 3 is already installed." 
#  exit 0 
#fi 
 
# install maven 
#wget -q $MAVEN_LOC 
#tar xzvf $MAVEN_FN 
#sudo ln -f -s "$MAVEN_DIR/bin/mvn" /usr/bin/mvn 

# relocate local repo to shared folder 
#mkdir -p ~/.m2
#cat > ~/.m2/settings.xml <<EOF
#<settings>
#<localRepository>/vagrant/shared</localRepository>
#</settings>
#EOF

#manual vagrant install if necessary
#sudo apt-get install dpkg-dev virtualbox-dkms
#wget https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.deb
#dpkg -i vagrant_1.8.1_x86_64.deb
#sudo apt-get install linux-headers-$(uname -r)
#sudo dpkg-reconfigure virtualbox-dkms

#OR

#Confirm versions before executing
#wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2_x86_64.deb
#wget http://download.virtualbox.org/virtualbox/4.3.22/virtualbox-4.3_4.3.22-98236~Ubuntu~raring_amd64.deb
#sudo dpkg -i vagrant_1.7.2_x86_64.deb
#sudo dpkg -i virtualbox-4.3_4.3.22-98236~Ubuntu~raring_amd64.deb

echo "bootstrap.sh Complete"