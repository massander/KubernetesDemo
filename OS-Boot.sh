#!/usr/bin/env bash

# qemu-img create -f qcow2 -b fedora-coreos-qemu.qcow2 my-fcos-vm.qcow2

# qemu-kvm -m 2048 -cpu host -nographic \
# 	-drive if=virtio,file=my-fcos-vm.qcow2 \
# 	-fw_cfg name=opt/com.coreos/config,file=path/to/example.ign \
# 	-nic user,model=virtio,hostfwd=tcp::2222-:22

ALLOCATED_RAM="2048" # MiB
CPU_SOCKETS="1"
CPU_CORES="2"
CPU_THREADS="4"

args=(
	-enable-kvm -m "$ALLOCATED_RAM"
	-cpu host
	-drive if=virtio,file=my-fcos-vm.qcow2
	# -fw_cfg name=opt/com.coreos/config,file=path/to/example.ign
	# -nic user,model=virtio,hostfwd=tcp::2222-:22
)

qemu-system-x86_64 "${args[@]}"