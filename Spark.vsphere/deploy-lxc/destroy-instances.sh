#!/usr/bin/env bash

set -ex

for container in "$@"
do
    lxc-destroy -f -n $container
done
