#!/bin/bash

NODES=$1 

echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

echo -e  'y\n'|ssh-keygen -q -t rsa -P "" -f ~/.ssh/id_rsa
ssh-agent $SHELL
ssh-add -L
ssh-add
ssh-add -L


for i in $(seq 2 $NODES);do

	expect <<- DONE
	       set timeout 5
       	       spawn ssh-copy-id -i  root@node$i
	       expect "*?assword:*"
	       send -- "vagrant\r"
	       send -- "\r"
	       interact
	       expect eof
	DONE
done


