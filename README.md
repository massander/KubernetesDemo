# kubernetes-vagrant-demo

Run 3 node[Kubernetes](https://kubernetes.io/) cluster using libvirt
[QEMU](https://www.qemu.org/)/[KVM](https://www.linux-kvm.org/page/Main_Page)

## Requirements

- Linux host with root access.
- Packages:
  - `qemu-kvm` – Machine emulator and virtualizer
  - `libvirt` – Includes the libvirtd server exporting the virtualization support
  - `vagrant` - Utility for building and maintaining portable virtual software development environments
  - `vagrant-libvirt` - Plugin for vagrant to communicate with libvirt
  - `virt-manager` - Graphical utility to manage KVM, Xen, or LXC via libvirt.

    Optional:

  - `libvirt-client` – This package contains `virsh` and other client-side utilities
  - `virt-install` – Utility to install virtual machines
  - `virt-viewer` – Utility to display graphical console for a virtual machine
  - `packer` - Tool for creating identical machine images for multiple platforms from a single source configuration
  - `ansible` - Provisioning, configuration management, and application-deployment tool enabling infrastructure as code
  
## Installation

### Arch

Install packages

    sudo pacman -S qemu qemu-arch-extra vagrant libvirt

Install vagrant plugin

    vagrant plugin install vagrant-libvirt

### Fedora

Install packages

    sudo dnf install qemu-kvm libvirt

Install vagrant plugin to connect to libvirt daemon.
See <https://github.com/vagrant-libvirt/vagrant-libvirt-qa/blob/main/scripts/install.bash>.

    chmod +x ./vagrant-install.sh && ./vagrant-install.sh
    vagrant plugin install vagrant-libvirt

## Создание виртуальных машин

| VM name  | Role              | IP adress      | CPU | RAM  | Disk |
|----------|-------------------|----------------|-----|------|------|
| kube-1-m | Kubernetes master | 192.168.100.11 | 2   | 2048 | 10G  |
| kube-2-w | Kubernetes worker | 192.168.100.12 | 1   | 1024 | 10G  |
| kube-3-w | Kubernetes worker | 192.168.100.13 | 1   | 1024 | 10G  |

Vargrant will install os image and set up VMs at first boot

    vagrant up

## Настройка Kubernetes

1. Инициализия кластера

        sudo kubeadm init  --pod-network-cidr 192.168.100.11/16

2. Запуск кластера от имени обычного полтзователя

        mkdir -p $HOME/.kube
        sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
        sudo chown $(id -u):$(id -g) $HOME/.kube/config

3. Установка pod network расширения

        kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

4. Добавление worker ноды

        sudo kubeadm join --token <token> <control-plane-host>:<control-plane-port> --discovery-token-ca-cert-hash sha256:<hash>

5. Создание Kubernetes Dashboard

    Добавление пользователя admin

        kubectl create serviceaccount dashboard -n default

    Добавление роли

        kubectl create clusterrolebinding dashboard-admin -n default --clusterrole=cluster-admin --serviceaccount=default:dashboard

    Get Token

        kubectl get secret $(kubectl get serviceaccount dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode

6. Развертывание приложений в кластере

        kubectl create deployment nginx --image=nginx

## Troublshooting

If you have problems with kvm, try to add user to kvm group

    sudo usermod -aG kvm $(whoami) && sudo reboot
