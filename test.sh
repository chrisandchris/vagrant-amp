#!/usr/bin/env bash

rm -rf output-virtualbox-iso
packer build "$1.json"
vagrant box add packer_virtualbox-iso_virtualbox.box --name="tmp/$1" --force
cd test
rm -rf ./.sql_dumps
vagrant destroy -f
vagrant box update
vagrant up $1
