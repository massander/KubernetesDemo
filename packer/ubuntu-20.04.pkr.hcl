packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "k8s" {
  vm_name           = "kube-{{timestamp}}.qcow2"
  output_directory  = "build"

  iso_url           = "https://releases.ubuntu.com/20.04.3/ubuntu-20.04.3-live-server-amd64.iso"
  iso_checksum      = "sha256:f8e3086f3cea0fb3fefb29937ab5ed9d19e767079633960ccb50e76153effc98"
  // iso_path          = "iso"
  
  cpus              = 1
  memory            = 2048
  disk_size         = "10000M"
  format            = "qcow2"
  accelerator       = "kvm"
  net_device        = "virtio-net"
  disk_interface    = "virtio"

  http_directory    = "http"
  ssh_username      = "${var.ssh_username}"
  ssh_password      = "${var.ssh_password}"
  ssh_timeout       = "20m"

  boot_wait         = "10s"
  boot_command      = [
    "<esc><esc><enter><wait>",
    "/install/vmlinuz noapic ",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ",
    "hostname=kube ",
    "fb=false debconf/frontend=noninteractive ",
    "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA ",
    "keyboard-configuration/variant=USA console-setup/ask_detect=false ",
    "initrd=/install/initrd.gz -- <enter>"
  ]
  // shutdown_command  = "echo '{{user `ssh_password`}}'|sudo -S shutdown -P now"
  shutdown_command  = "echo ${var.ssh_username} | sudo -S shutdown -P now"
}

build {
  sources = ["source.qemu.k8s"]

  provisioner "shell"{
    scripts = [
      "scripts/install.docker.sh",
      "scripts/install.kubernetes.sh",
    ]
  }
}
