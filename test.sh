#!/usr/bin/env bash

command_exists () {
    type "$1" &> /dev/null ;
}

if ! export | grep -Eq '^declare -x ATLAS_TOKEN=' ; then
    echo "You need to export the ATLAS_TOKEN"
    exit 1
fi

declare -a reqs=(
    "packer"
    "vagrant"
    "virtualbox"
    "libvirt"
)

for (( i = 0; i < ${#cmds[@]} ; i++ )); do
    if ! command_exists ${cmds[$i]}; then
        echo "Command not installed, aborting."
        echo ${cmds[$i]}
        exit 1
    fi
done

declare -a cmds=(
    "rm -rf output-virtualbox-iso"
    "packer build -only=qemu \"$1.json\""
    "vagrant box add packer_virtualbox-iso_virtualbox.box --name=\"tmp/$1\" --force"
    "rm -rf packer_cache/*"
    "rm -rf output-virtualbox-iso/*"
    "cd test"
    "rm -rf ./.sql_dumps"
    "vagrant destroy -f"
    "vagrant box update"
    "vagrant up $1"
)

echo "Running commands in a row..."

for (( i = 0; i < ${#cmds[@]} ; i++ )); do
    printf "\n**** Running: ${cmds[$i]} *****\n\n"

    if ! eval "${cmds[$i]}"; then
        echo ""
        echo "-------------------------"
        echo "Command failed, aborting."
        echo "${cmds[$i]}"
        exit 1
    fi
done

