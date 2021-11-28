# -*- mode: ruby -*-
# vi: set ft=ruby :

# Docs for vagrant-libvirt
# https://github.com/vagrant-libvirt/vagrant-libvirt
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'
ENV["LC_ALL"] = "en_US.UTF-8"

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2004"

  config.vm.box_check_update = false

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provisioners/ansible/playbook.yaml"
  end

  # Kube master node
  config.vm.define "kube-1-master" do |master|
    master.vm.network "private_network", ip: "192.168.50.10"
    master.vm.hostname = "kube-1-master"
    
    master.vm.provider "libvirt" do |libvirt|
      libvirt.memory = "2048"
      # Number of virtual cpus
      libvirt.cpus = 4
      # Physical cpus to which the vcpus can be pinned
      # libvirt.cpuset = '1-4,^3,6'
    end
  end

  # Kube worker nodes (Multi-machine environment)
  (1..2).each do |i|
   config.vm.define "kube-#{i+1}-worker" do |worker|
     worker.vm.network "private_network", ip: "192.168.50.#{i+1+10}"
     worker.vm.hostname = "kube-#{i+1}-worker"
     
     worker.vm.provider "libvirt" do |libvirt|
       libvirt.memory = "640"
       # Number of virtual cpus
       libvirt.cpus = 4
       # Physical cpus to which the vcpus can be pinned
       # libvirt.cpuset = '1-4,^3,6'
     end
     
     worker.vm.provision "shell",
       inline: "echo hello from kube-#{i+1}-worker"
     end
  end
end
