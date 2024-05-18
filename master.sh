#!/bin/bash

echo "disabling swap"
swapoff -a
sed -e '/swap/s/^/#/g' -i /etc/fstab

echo "installing kubernetes version v1.26"

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.26/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

sudo mkdir -m 755 /etc/apt/keyrings

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl docker.io
sudo apt-mark hold kubelet kubeadm kubectl
cat <<EOF | sudo tee /etc/docker/daemon.json
{
    "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF


systemctl daemon-reload
systemctl restart docker
systemctl restart kubelet

echo "Initializing cluster"

kubeadm init --apiserver-advertise-address 192.168.1.42

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf


curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml -O

kubectl apply -f calico.yaml

echo "wait"


kubectl get nodes

kubectl get pods -n kube-system

kubectl get pods -n kube-system -o wide
