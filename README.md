# kubernetes-install

OS version = Ubuntu 20.04.6 LTS
kubernetes version = v1.26
master simple use this script == sh master.sh 

IMP:-

==> If localhost:8080 connection is refused on the node machine
step 1) kubeadm reset
step 2) then you need to create a .kube/config file and copy the .kube/config file from your master machine and paste it into the .kube/config file of the node machine.
step 3) this command run on master machine "kubeadm token create --print-join-command" and join master machine 
step 4) wait 1-2 min 
step 5) kubeclt get nodes
