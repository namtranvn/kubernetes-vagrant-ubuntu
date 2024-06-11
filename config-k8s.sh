#!/bin/bash

rm ~/.kube/config
vagrant ssh master -c "sudo cat /etc/kubernetes/admin.conf" > ~/.kube/config

declare -a arr=("master" "worker-1" "worker-2")

for i in "${arr[@]}"
do
    vagrant ssh $i -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1"
    vagrant ssh $i -c "sshpass -p vagrant ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.57.100"
    vagrant ssh $i -c "sshpass -p vagrant ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.57.101"
    vagrant ssh $i -c "sshpass -p vagrant ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.57.102"
done

# see what changes would be made, returns nonzero returncode if different
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system

# actually apply the changes, returns nonzero returncode on errors only
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.5/config/manifests/metallb-native.yaml
# kubectl apply -f ~/Desktop/doing/kubernetes-vagrant-ubuntu/metallb-config.yaml

rm -rf ./nginx-ingress
helm pull oci://ghcr.io/nginxinc/charts/nginx-ingress --untar
cd nginx-ingress
kubectl apply -f crds
helm install nginx-ingress oci://ghcr.io/nginxinc/charts/nginx-ingress

kubectl run test-nginx-svc --image=nginx
sleep 60
kubectl apply -f ~/Desktop/doing/kubernetes-vagrant-ubuntu/metallb-config.yaml

