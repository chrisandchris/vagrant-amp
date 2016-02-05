#!/usr/bin/env bash

rm -rf output-virtualbox-iso
packer build "$1.json"
vagrant box add packer_virtualbox-iso_virtualbox.box --name="tmp/$1" --force
cd test
vagrant destroy -y
rm -f Vagrantfile
vagrant init "tmp/$1"
vagrant up