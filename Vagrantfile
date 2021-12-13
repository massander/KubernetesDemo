# -*- mode: ruby -*-
# vi: set ft=ruby :

# See https://github.com/vagrant-libvirt/vagrant-libvirt
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'
ENV["LC_ALL"] = "en_US.UTF-8"

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2004"

  # Define three VMs with static private IP addresses.
  vms = [
    { :name => "kube-1-master", :ip => "192.168.100.11", :mem => "2048", :host_port => 8081  },
    { :name => "kube-2-worker", :ip => "192.168.100.12", :mem => "2048", :host_port => 8082 }
    # { :name => "kube-3-worker", :ip => "192.168.100.13", :mem => "2048", :host_port => 8083 }
  ]

  # Configure VMs
  vms.each_with_index do |opts, index|
    config.vm.define opts[:name] do |xvm|
      xvm.vm.hostname = opts[:name] + 'cluster.demo'
      xvm.vm.network :private_network, ip: opts[:ip]
      xvm.vm.network "forwarded_port", guest: 8001, host: opts[:host_port]

      xvm.vm.provider "libvirt" do |libvirt|
        libvirt.driver = "qemu"
        libvirt.memory = opts[:mem]
        # Number of virtual cpus
        libvirt.cpus = 2
      end

      xvm.vm.provision "shell",
        inline: "echo 'Hello from #{opts[:name]} :)'"
      end
    end
  
end
