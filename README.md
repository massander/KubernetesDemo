# k8s-qemu

Run [Kubernetes](https://kubernetes.io/) cluster using [QEMU](https://www.qemu.org/)/[KVM](https://www.linux-kvm.org/page/Main_Page)

## Requirements

Linux host with root access.

Installed following packages:

- `qemu-kvm` – Machine emulator and virtualizer
- `libvirt` – Includes the libvirtd server exporting the virtualization support
- `vagrant` - Utility for building and maintaining portable virtual software development environments
- `vagrant-libvirt` - Plugin for vagrant to communicate with libvirt

Optional:

- `libvirt-client` – This package contains `virsh` and other client-side utilities
- `virt-install` – Utility to install virtual machines
- `virt-viewer` – Utility to display graphical console for a virtual machine
- `virt-manager` - Graphical utility to manage KVM, Xen, or LXC via libvirt.
- `packer` - Tool for creating identical machine images for multiple platforms from a single source configuration
- `ansible` - Provisioning, configuration management, and application-deployment tool enabling infrastructure as code
  
## Installation

### Arch

```shell
sudo pacman -S qemu qemu-arch-extra vagrant libvirt
vagrant plugin install vagrant-libvirt
```

### Fedora

See <https://github.com/vagrant-libvirt/vagrant-libvirt-qa/blob/main/scripts/install.bash>

```shell
sudo dnf install qemu-kvm libvirt
chmod +x ./vagrant-install.sh
./vagrant-install.sh
vagrant plugin install vagrant-libvirt
```

## Создание виртуальных машин

| VM name  | Role              | IP adress      | CPU | RAM  | Disk |
|----------|-------------------|----------------|-----|------|------|
| kube-1-m | Kubernetes master | 192.168.100.11 | 2   | 2048 | 10G  |
| kube-2-w | Kubernetes worker | 192.168.100.12 | 1   | 1024 | 10G  |
| kube-3-w | Kubernetes worker | 192.168.100.13 | 1   | 1024 | 10G  |

### Vagrant

```shell
vagrant up
```
  
## Настройка Kubernetes

1. Инициализия Kubernetes кластера

    ```shell
    sudo kubeadm init  --pod-network-cidr 192.168.100.11/16
    ```

2. Запуск кластера от имени обычного полтзователя

    ```shell
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    ```

3. Установка pod network расширения

    ```shell
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
    ```

4. Добавление worker ноды

    ```shell
    sudo kubeadm join --token <token> <control-plane-host>:<control-plane-port> --discovery-token-ca-cert-hash sha256:<hash>
    ```

5. Развертывание приложений в кластере

    ```shell
    kubectl create deployment nginx --image=nginx
    ```

## Troublshooting

```shell
sudo usermod -aG kvm $(whoami) && sudo reboot
```
