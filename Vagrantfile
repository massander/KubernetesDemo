# -*- mode: ruby -*-
# vi: set ft=ruby :

# See https://github.com/vagrant-libvirt/vagrant-libvirt
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'
ENV["LC_ALL"] = "en_US.UTF-8"

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2004"

  # config.vm.box_check_update = false

  config.vm.provision "ansible" do |ansible|
    # ansible.verbose = "v"
    ansible.playbook = "provisioners/ansible/playbook.yaml"
    ansible.groups = {
      "master" => ["kube-1-master"],
      "worker" => ["kube-2-worker", "kube-3-worker"],
      "kube_cluster:children" => ["master", "worker"]
    }
    # ansible.inventory_path = "provisioners/ansible/hosts.ini"
    # ansible.limit = "all"
  end

  # Kube master node
  config.vm.define "kube-1-master" do |master|
    master.vm.network "private_network", ip: "192.168.50.10"
    master.vm.hostname = "kube-1-master"
    
    master.vm.provider "libvirt" do |libvirt|
      libvirt.memory = "2048"
      # Number of virtual cpus
      libvirt.cpus = 2
      # Physical cpus to which the vcpus can be pinned
      # libvirt.cpuset = '1-4,^3,6'
    end
  end

  # Kube worker nodes (Multi-machine environment)
  N = 2
  (1..N).each do |i|
    config.vm.define "kube-#{i+1}-worker" do |worker|
      worker.vm.network "private_network", ip: "192.168.50.#{i+1+10}"
      worker.vm.hostname = "kube-#{i+1}-worker"
     
      worker.vm.provider "libvirt" do |libvirt|
        libvirt.memory = "1024"
        # Number of virtual cpus
        libvirt.cpus = 2
        # Physical cpus to which the vcpus can be pinned
        # libvirt.cpuset = '1-4,^3,6'
      end

      # if i == N
      #   worker.vm.provision :ansible do |ansible|
      #     ansible.inventory_path = "provisioners/ansible/hosts.ini"
      #     ansible.limit = "all"
      #     ansible.playbook = "provisioners/ansible/playbook.yaml"
      #   end
      # end
     
      worker.vm.provision "shell",
        inline: "echo 'Hello from kube-#{i+1}-worker :)'"
      end
    end


  # Define three VMs with static private IP addresses.
  # vms = [
  #   { :name => "kube-1-master", :ip => "192.168.50.0" },
  #   { :name => "kube-2-worker", :ip => "192.168.50.2" },
  #   { :name => "kube-3-worker", :ip => "192.168.50.3" }
  # ]

  # vms.each_with_index do |opts, index|
  #   config.vm.define opts[:name] do |config|
  #     config.vm.hostname = opts[:name]
  #     # config.vm.hostname = opts[:name] + ".cluster.test"
  #     config.vm.network :private_network, ip: opts[:ip]

  #     # Provision all the VMs using Ansible after last VM is up.
  #     if index == vms.size - 1
  #       config.vm.provision "ansible" do |ansible|
  #         ansible.playbook = "provisioners/ansible/playbook.yaml"
  #         ansible.inventory_path = "provisioners/ansible/hosts.ini"
  #         ansible.limit = "all"
  #       end
  #     end
  #   end
  # end

end
