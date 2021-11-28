# k8s-qemu

Run [Kubernetes](https://kubernetes.io/) cluster using [QEMU](https://www.qemu.org/)/[KVM](https://www.linux-kvm.org/page/Main_Page)

## TODO

- [ ] Create custom Vagrant box, so not to install software every time Vagrant boot enviroment
- [ ] Ansibale or shell provisioner
- [ ] Vagrant share

## Requirements

Linux host with root access.

Installed following packages:

- `qemu-kvm` – Machine emulator and virtualizer
- `libvirt` – Includes the libvirtd server exporting the virtualization support
- `vagrant` - Utility for building and maintaining portable virtual software development environments
- `vagrant-libvirt` - Plugin for vagrant to communicate with libvirt
- `ansible` - Provisioning, configuration management, and application-deployment tool enabling infrastructure as code

Optional:

- `libvirt-client` – This package contains `virsh` and other client-side utilities
- `virt-install` – Utility to install virtual machines
- `virt-viewer` – Utility to display graphical console for a virtual machine
- `virt-manager` - Graphical utility to manage KVM, Xen, or LXC via libvirt.
- `packer` - Tool for creating identical machine images for multiple platforms from a single source configuration
  
## Installation

### Arch

```shell
sudo pacman -S qemu qemu-arch-extra vagrant libvirt ansible
vagrant plugin install vagrant-libvirt
```

### Fedora

<!-- <https://github.com/vagrant-libvirt/vagrant-libvirt-qa/blob/main/scripts/install.bash> -->

```shell
sudo dnf install qemu-kvm libvirt
chmod +x ./vagrant-install.sh
./vagrant-install.sh
vagrant plugin install vagrant-libvirt
```

## Создание виртуальных машин

| VM name  | Role              | IP adress     | CPU | RAM  | Disk |
|----------|-------------------|---------------|-----|------|------|
| kube-1-m | Kubernetes master | 192.168.50.10 | 2   | 2048 | 10G  |
| kube-2-w | Kubernetes worker | 192.168.50.12 | 1   | 1024 | 10G  |
| kube-3-w | Kubernetes worker | 192.168.50.12 | 1   | 1024 | 10G  |

### Vagrant

```shell
vagrant up
```

### Manual

In Progress...

<!-- 1. Клонирование vm

    ```shell
    virt-clone \
        --original ubuntu18.04 \
        --name cloned-ubuntu \
        --file /var/lib/libvirt/images/cu.qcow2
    ```

2. Изменение hostname

    ```shell
    hostnamectl set-hostname <yourhostname here>
    hostnamectl status #to check it worked
    ```

3. Изменение ip адреса vm
4. Настройка SSH -->
  
## Настройка Kubernetes

### Ansible

TODO

### Manual

1. Инициализия Kubernetes кластера

    ```shell
    sudo kubeadm init --control-plane-endpoint kube-master:6443 --pod-network-cidr 192.168.150.0/23
    ```

2. Запуск кластера от имени обычного полтзователя

    ```shell
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    ```

3. Установка pod network расширения

    ```shell
    curl https://docs.projectcalico.org/manifests/calico.yaml -O
    kubectl apply -f calico.yaml
    ```

4. Добавление worker ноды

    ```shell
    sudo kubeadm join --token <token> <control-plane-host>:<control-plane-port> --discovery-token-ca-cert-hash sha256:<hash>
    ```

5. Развертывание приложений в кластере

    ```shell
    kubectl create deployment nginx --image=nginx
    ```

## Собрка кастомного образа

### Using Packer

```shell
packer build
```

### Manual

In Progress...

<!-- 1. Установка ОC

    Download image, for example Ubuntu 20.04 lts and run folowing command

    ```shell
    virt-install \
        --name ubuntu1804 \
        --ram 2048 \
        --disk path=/var/lib/libvirt/images/u19.qcow2,size=8 \
        --vcpus 2 \
        --os-type linux \
        --os-variant generic \
        --console pty,target_type=serial \
        --cdrom /var/lib/libvirt/isos/ubuntu-18.04.4-live-server-amd64.iso
    ```
2. Установка Docker
  
   ```shell
   ./scripts/install-docker.sh
   ```

3. Установка Kubernetes
  
   ```shell
   ./scripts/install-kubernetes.sh
   ```

4. Настройка групп

   ```shell
   ./scripts/add-user-to-groups.sh
   ```

5. Создание snapshot -->

## Troublshooting

```shell
sudo usermod -aG kvm $(whoami) && sudo reboot
```
