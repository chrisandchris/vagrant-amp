#!/usr/bin/env bash

command_exists () {
    type "$1" &> /dev/null ;
}

if ! export | grep -Eq '^declare -x ATLAS_TOKEN=' ; then
    echo "You need to export the ATLAS_TOKEN"
    exit 1
fi

if ! command_exists packer; then
    echo "Packer is not installed"
    exit 1
fi
if ! command_exists vagrant; then
    echo "Vagrant is not installed"
    exit 1
fi
if ! command_exists virtualbox; then
    echo "Virtualbox is not installed"
    exit 1
fi

rm -rf output-virtualbox-iso
packer build "$1.json"
vagrant box add packer_virtualbox-iso_virtualbox.box --name="tmp/$1" --force
cd test
rm -rf ./.sql_dumps
vagrant destroy -f
vagrant box update
vagrant up $1
