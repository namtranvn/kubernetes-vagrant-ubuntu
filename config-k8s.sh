#!/bin/bash

rm ~/.kube/config
vagrant ssh master -c "sudo cat /etc/kubernetes/admin.conf" > ~/.kube/config

vagrant ssh master -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1"
vagrant ssh master -c "sshpass -p vagrant ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.57.100"
vagrant ssh master -c "sshpass -p vagrant ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.57.101"
vagrant ssh master -c "sshpass -p vagrant ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.57.102"

vagrant ssh worker-1 -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1"
vagrant ssh worker-1 -c "sshpass -p vagrant ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.57.100"
vagrant ssh worker-1 -c "sshpass -p vagrant ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.57.101"
vagrant ssh worker-1 -c "sshpass -p vagrant ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.57.102"

vagrant ssh worker-2 -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1"
vagrant ssh worker-2 -c "sshpass -p vagrant ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.57.100"
vagrant ssh worker-2 -c "sshpass -p vagrant ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.57.101"
vagrant ssh worker-2 -c "sshpass -p vagrant ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.57.102"


# see what changes would be made, returns nonzero returncode if different
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system

# actually apply the changes, returns nonzero returncode on errors only
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.5/config/manifests/metallb-native.yaml
kubectl apply -f ~/Desktop/doing/kubernetes-vagrant-ubuntu/metallb-config.yaml

# helm install ingress-nginx ingress-nginx/ingress-nginx --set controller.extraArgs.enable-ssl-passthrough=""
# helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# helm repo update
# helm install ingress-nginx ingress-nginx/ingress-nginx

rm -rf ~/Desktop/doing/kubernetes-vagrant-ubuntu/nginx-ingress
helm pull oci://ghcr.io/nginxinc/charts/nginx-ingress --untar
cd nginx-ingress
kubectl apply -f crds
helm install nginx-ingress oci://ghcr.io/nginxinc/charts/nginx-ingress

kubectl run test-nginx-svc --image=nginx

