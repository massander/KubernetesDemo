## Установка

### Arch

Установка пакетов

    sudo pacman -S qemu qemu-arch-extra vagrant libvirt

Установка плагина vagrant

    vagrant plugin install vagrant-libvirt

### Fedora

Установка пакетов

    sudo dnf install qemu-kvm libvirt

Установка плагина vagrant
Могут возникнуть проблемы с версиями библиотек.
Лучше посмотреть [здесь](https://github.com/vagrant-libvirt/vagrant-libvirt-qa/blob/main/scripts/install.bash).

    cd tools
    chmod +x ./vagrant-libvirt.sh && ./vagrant-libvirt.sh
    vagrant plugin install vagrant-libvirt

## Создание виртуальных машин

| VM name  | Role              | IP adress      | CPU | RAM  | Disk |
|----------|-------------------|----------------|-----|------|------|
| kube-1-m | Kubernetes master | 192.168.100.11 | 2   | 2048 | 128G |
| kube-2-w | Kubernetes worker | 192.168.100.12 | 2   | 2048 | 128G |
| kube-3-w | Kubernetes worker | 192.168.100.13 | 2   | 2048 | 128G |

При первом запуске vagrant сам скачает образ ubuntu и начнет запуск VM'ок

Настройки VM'ок(память, процессор) находятся в `Vagrantfile`

    vagrant up

Теперь нужно подключится по ssh к каждой vm'ке и выполнить следующие команды
для установки docker'а и kubernetes'a

Название vm'ки можно посмотреть в `Vagrantfile`

    vagrant ssh <название vm'ки>
    wget https://raw.githubusercontent.com/2thousandmax/kubernetes-vagrant-demo/main/scripts/docker.sh && chmod +x ./docker.sh && ./docker.sh
    wget https://raw.githubusercontent.com/2thousandmax/kubernetes-vagrant-demo/main/scripts/kubernetes.sh && chmod +x ./kubernetes.sh && ./kubernetes.sh

## Настройка Kubernetes

Первым делом надо инициализировать кластер с помощью утилиты `kubeadm`

    sudo kubeadm init  --pod-network-cidr 192.168.100.11/16

Переместить конфигупационные файлы в домашнюю директорию(чтобы постоянно не писать `sudo`)

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

Или
    mkdir -p $HOME/.kube
    scp root@192.168.100.11:/etc/kubernetes/admin.conf $HOME/.kube/config

Установить расширения для сети подов

    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

Тепрь можно присоеденить зависимые(worker) ноды

Чтобы присоеденить ноду к контроллеру(master) нужно для начала создать токен с помощью команды:

    kubeadm token create --print-join-command

Команда вернет новую команду, которую можно использовать для присоединения, следующего вида:

    sudo kubeadm join <control-plane-host>:<control-plane-port> \
        --token <token> \
        --discovery-token-ca-cert-hash sha256:<hash>

Например:

    kubeadm join 192.168.121.53:6443 \
        --token o3o95x.9v9y2iqpuonydoi6 \
        --discovery-token-ca-cert-hash sha256:9b6f9f38031c029a8df831c0f56ccb7ebb67449258bb7242839587fa7b5912a8

Проверим что все работает как и должно

    kubectl get nodes -o wide

Теперь можно приступить к запуску чего-то внутри кластера

Склонировать этот репозиторий и применить конфигурационные(.yaml) файлы.

    git clone <ссылка на репозиторий>
    cd <название репозитория>
    kubectl apply -f kubernetes/kubernetes-dashbord/kdash-deployment.yaml

Команда создаст дашборд для графического управления кластером.

[Как открыть дашборд](https://github.com/kubernetes/dashboard/blob/master/docs/user/accessing-dashboard/README.md)

Получить токен можно командой:

    kubectl get secret $(kubectl get serviceaccount dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode

Развертывание приложений в кластере применяется утилитой `kubectl`.

    cd kuberntes/postgres
    kubectl apply -f postgres-secret.yaml
    kubectl apply -f postgres-deployment.yaml

    kubectl describe deployment postgres-deployment
