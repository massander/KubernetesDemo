# Build vagrant box

    cd build
    vagrant up
    # modify whatever you need
    logout
    export VAGRANT_LIBVIRT_VIRT_SYSPREP_OPERATIONS="defaults,-ssh-userdir,-ssh-hostkeys,-lvm-uuids"
    vagrant package
    vagrant box add --name box-name package.box
