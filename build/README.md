# Custom Vagrant box

Download from release page pre built vagran
box and add box to vagrant

```shell
vagrant box add --name ubuntu-kube path/to/ubuntu-kube.box
```

Build from scratch

```shell
cd build
vagrant up
vagrant ssh
```

Now you can modify what you need
For example, clone this repo and run scripts to install docker
and kubernetes.

```shell
git clone github.com/2thousandmax/k8s-qemu.git
cd k8s-qemu/scripts
chmod +x docker.sh kubernetes.sh
./docker.sh
./kubernetes.sh
```

Than logout and build package vagrant box

```shell
logout
export VAGRANT_LIBVIRT_VIRT_SYSPREP_OPERATIONS="defaults,-ssh-userdir,-ssh-hostkeys,-lvm-uuids"
export VAGRANT_LIBVIRT_VIRT_SYSPREP_OPERATIONS="defaults,-ssh-userdir,-ssh-hostkeys,-lvm-uuids"

vagrant package --output ubuntu-kube.box
vagrant box add --name ubuntu-kube ubuntu-kube.box
```
