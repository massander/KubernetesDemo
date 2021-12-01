packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

variables {
  name = "ubuntu-20.04"
  mirror = "http://releases.ubuntu.com"
  mirror_directory = "focal"
  iso_name = "ubuntu-20.04.3-live-server-amd64.iso"
  iso_checksum = "sha256:f8e3086f3cea0fb3fefb29937ab5ed9d19e767079633960ccb50e76153effc98"
  box_basename = "ubuntu-20.04"
}

source "qemu" "k8s" {
  format            = "qcow2"
  accelerator       = "kvm"
  
  vm_name           = "kube-{{timestamp}}.qcow2"
  output_directory  = ".build"

  iso_url           = "https://releases.ubuntu.com/20.04.3/ubuntu-20.04.3-live-server-amd64.iso"
  iso_checksum      = "sha256:f8e3086f3cea0fb3fefb29937ab5ed9d19e767079633960ccb50e76153effc98"
  // iso_path          = "iso"
  
  cpus              = 1
  memory            = 2048
  disk_size         = "10000M"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  headless          = false

  http_directory    = "http"
  ssh_port          = 22
  ssh_timeout       = "10000s"
  ssh_username      = "vagrant"
  ssh_password      = "vagrant"

  boot_wait         = "10s"
  boot_command      = [
    " <wait>",
    " <wait>",
    " <wait>",
    " <wait>",
    " <wait>",
    "<esc><wait>",
    "<f6><wait>",
    "<esc><wait>",
    "<bs><bs><bs><bs><wait>",
    " autoinstall<wait5>",
    " ds=nocloud-net<wait5>",
    ";s=http://<wait5>{{.HTTPIP}}<wait5>:{{.HTTPPort}}/<wait5>",
    " ---<wait5>",
    "<enter><wait5>"
  ]
  // shutdown_command  = "echo '{{user `ssh_password`}}'|sudo -S shutdown -P now"
  // shutdown_command  = "echo ${var.ssh_username} | sudo -S shutdown -P now"
  shutdown_command  = "echo 'vagrant' | sudo -S shutdown -P now"
}

source "vagrant" "kube" {
  output_dir = ".build"
  communicator = "ssh"
  source_path = "generic/ubuntu2004"
  provider = "libvirt"
  add_force = true
}


build {
  sources = ["source.vagrant.kube"]

  provisioner "shell"{
    scripts = [
      "${path.root}/scripts/docker.sh",
    ]
  }
}
