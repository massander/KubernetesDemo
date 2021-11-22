# k8s-qemu

Run [Kubernetes](https://kubernetes.io/) cluster using [QEMU](https://www.qemu.org/)/[KVM](https://www.linux-kvm.org/page/Main_Page)

## Requirements

System

- kvm
- QEMU
- libvirt

cli

- virsh
- virt-install

## installation

### Arch

```shell
sudo pacman -S qemu \
    qemu-arch-extra \
    ovmf bridge-utils \
    dnsmasq vde2 \
    openbsd-netcat \
    ebtables iptables
```

- `ovmf` helps to do the UEFI Bios and Secure Boot setups.
- `bridge-utils` for network bridge needed for VMs
- `vde2` for QEMU distributed ethernet emulation
- `dnsmasq` the DNS forwarder and DHCP server
- `openbsd-netcat` network testing tool (Optional)
- `ebtables` and `iptables` to create packet routing and firewalls

### Fedora

```shell
sudo dnf install qemu-kvm
```

## Собрка образа

1. Установка ОC

    Image: Ubuntu 20.04 lts

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
    <!-- How to do same thing but with qemu or HashiCorp Paker -->

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

5. Создание snapshot

## Создание виртуальных машин

Гипервизор - QEMU

| VM name  | Role              | IP adress | CPU | RAM  | Disk |
|----------|-------------------|-----------|-----|------|------|
| kube-1-m | Kubernetes master | -         | 2   | 2048 | 10G  |
| kube-2-w | Kubernetes worker | -         | 2   | 2048 | 10G  |
| kube-3-w | Kubernetes worker | -         | 2   | 2048 | 10G  |

1. Клонирование vm

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
4. Настройка SSH
  
## Настройка Kubernetes

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

   <!-- - Nginx
   - Простой сервис на Go
   - Minecraft server
   - Prometheus/Grafana дял мониторинга -->

## Автоматизация

1. Сборка образа
2. Клонироваие vm
3. Запуск нескольких vm одновременно

## Ресурсы

- <https://devopscube.com/packer-tutorial-for-beginners/>

## Troublshooting

```shell
sudo usermod -aG kvm $(whoami) && sudo reboot
```
