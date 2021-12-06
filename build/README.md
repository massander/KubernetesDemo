# How to create Vagrant box from existing box

Go to `build` directory and launch VM

    cd build
    vagrant up

Connect to VM

    vagrant ssh

Install packages or run commands
For example:

    git clone github.com/2thousandmax/k8s-qemu.git
    cd k8s-qemu/scripts
    chmod +x docker.sh kubernetes.sh && ./docker.sh && ./kubernetes.sh

Close connection to VM

    logout

Build Vagrant box using `vagrant package` command

    export VAGRANT_LIBVIRT_VIRT_SYSPREP_OPERATIONS="defaults,-ssh-userdir,-ssh-hostkeys,-lvm-uuids"

    vagrant package --output ubuntu-kube.box

Add built box to Vagrant

    vagrant box add --name ubuntu-kube ubuntu-kube.box
