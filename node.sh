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


echo "Generate token on master using"

echo "kubeadm token create --print-join-command"
