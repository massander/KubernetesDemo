# -*- mode: ruby -*-
# vi: set ft=ruby :

# See https://github.com/vagrant-libvirt/vagrant-libvirt
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'
ENV["LC_ALL"] = "en_US.UTF-8"

Vagrant.configure("2") do |config|
  # config.vm.box = "generic/ubuntu2004"
  config.vm.box = "kube-ubuntu20.04"

  сщташп.vm.provider "libvirt" do |libvirt|
      libvirt.memory = "2048"
      # Number of virtual cpus
      libvirt.cpus = 2
    end
  
  # Kube master node
  config.vm.define "kube-1-master" do |master|
    master.vm.network "private_network", ip: "192.168.50.10"
    master.vm.hostname = "kube-1-master"
  end
  
  # Kube worker nodes (Multi-machine environment)
  # N = 2
  # (1..N).each do |i|
  #   config.vm.define "kube-#{i+1}-worker" do |worker|
  #     worker.vm.network "private_network", ip: "192.168.50.#{i+1+10}"
  #     worker.vm.hostname = "kube-#{i+1}-worker"
  
  #     worker.vm.provider "libvirt" do |libvirt|
  #       libvirt.memory = "1024"
  #       # Number of virtual cpus
  #       libvirt.cpus = 2
  #     end
  
  #     worker.vm.provision "shell",
  #       inline: "echo 'Hello from kube-#{i+1}-worker :)'"
  #     end
  #   end
  
end
