# -*- mode: ruby -*-
# vi: set ft=ruby :

# Docs for vagrant-libvirt
# https://github.com/vagrant-libvirt/vagrant-libvirt
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'
ENV["LC_ALL"] = "en_US.UTF-8"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2004"
  # config.vm.box_version = "1.0.282"
  # config.vm.box_url = "https://vagrantcloud.com/hashicorp/bionic64

  # Kube master node
  config.vm.define "kube-1-master" do |master|
    master.vm.network "private_network", ip: "192.168.50.10"
    master.vm.hostname = "kube-1-master"
    master.vm.provision "ansible" do |ansible|
      ansible.playbook = "provisioners/ansible/playbook-master.yaml"
      ansible.extra_vars = {
          node_ip: "192.168.50.10",
      }
    end
    master.vm.provider "libvirt" do |libvirt|
      libvirt.memory = "2048"
      # Number of virtual cpus
      libvirt.cpus = 4
      # Physical cpus to which the vcpus can be pinned
      # libvirt.cpuset = '1-4,^3,6'
    end
    
     
  end

  # (Kube worker nodes (Multi-machine environment)
  #(1..2).each do |i|
  #  config.vm.define "kube-#{i+1}-worker" do |worker|
  #    worker.vm.network "private_network", ip: "192.168.50.#{i+1+10}"
  #    worker.vm.hostname = "kube-#{i+1}-worker"
  #    
  #    worker.vm.provider "libvirt" do |libvirt|
  #      libvirt.memory = "640"
  #      # Number of virtual cpus
  #      libvirt.cpus = 4
  #      # Physical cpus to which the vcpus can be pinned
  #      # libvirt.cpuset = '1-4,^3,6'
  #    end
  #    
  #    # Install Ansible first
  #    worker.vm.provision "shell",
  #      inline: "echo hello from kube-#{i+1}-worker"
  #    end
  #    
  #    # # Apply Ansible
  #    # worker.vm.provision "ansible" do |ansible|
  #    #   ansible.playbook = "provisioners/ansible/playbook-worker.yaml"
  #    #   ansible.extra_vars = {
  #    #       node_ip: "192.168.50.10",
  #    #   }
  #    # end
  #end

  # Define primary vm
  # config.vm.define "web", primary: true do |web|
  # # ...
  # end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  # config.vm.provision :shell, path: "bootstrap.sh"
end
