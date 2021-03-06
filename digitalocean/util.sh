#!/bin/bash

function setup_ssh_config() {
	pushd ~/.ssh
	ssh-keygen -P "" -t rsa -f id_rsa_tmp -b 4096 -C "email@example.com"
	export TF_VAR_key_file='~/.ssh/id_rsa_tmp.pub'
	eval `ssh-agent -s`
	ssh-add id_rsa_tmp
	popd	
}
