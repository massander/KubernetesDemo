# Notes

## Собрка образа

ОС - Ubuntu 20.04 lts

1. Установить Docker
2. Установить Kubernetes
3. Настроить группы
4. Создать snapshot

## Создание виртуальных машин

Гипервизор - QEMU

| VM name  | Role              | IP adress | CPU | RAM  | Disk |
|----------|-------------------|-----------|-----|------|------|
| kube-1-m | Kubernetes master | -         | 1   | 1024 | 10G  |
| kube-2-w | Kubernetes worker | -         | 1   | 1024 | 10G  |
| kube-3-w | Kubernetes worker | -         | 1   | 1024 | 10G  |

1. Прописать каждой vm свой статический адрес
2. Настроить SSH для каждой vm
  
## Настройка Kubernetes

1. Инициализировать master node
2. Установить pod network расширение
3. Добавить worker nodes
4. Создать файлы конфигурации дял развертывания

### Что развертывать?

1. Cвой кастомный сервис
2. Minecraft server
3. Nginx
4. Prometheus/Grafana дял мониторинга

## Скрипты для автоматизации

1. Установка vm
2. Запуск нескольких vm
3. Сборка образа
