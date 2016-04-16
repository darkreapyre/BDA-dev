#!/usr/bin/env bash

set -ex

for container in "$@"
do
    lxc-create -t download -n $container -- -d ubuntu -r vivid -a amd64
    lxc-start -n $container
    lxc-wait -n $container -s RUNNING
    until lxc-info -n $container | grep -P 'IP:\s+\S+'; do sleep 1; done
    lxc-attach -n $container -- sh -c 'apt-get -y --force-yes install openssh-server python sudo'
    lxc-attach -n $container -- sh -c 'mkdir -p /root/.ssh && chmod 0700 /root/.ssh && cat >> /root/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
done
