#!/usr/bin/env bash

# Install kubernetes
sudo apt-get update
sudo apt-get install -y apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

echo 'Installing kubelet, kubeadm and kubectl...'
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "Checking kubelet version..."
kubectl version --client && kubeadm version

# Disable swap
echo 'Turning off swap...'
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

# Enable kernel modules
echo 'Enabling kernel modules...'
sudo modprobe overlay
sudo modprobe br_netfilter

# Pass bridged IPv4 traffic to iptables chains
echo 'Adding setting to sysctl...'
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload sysctl
echo 'Reloading sysctl...'
sudo sysctl --system

# Disable selinux
echo 'Turning off selinux'
sudo apt-get install selinux-utils
setenforce 0

# Enable kubelet service
sudo systemctl enable kubelet