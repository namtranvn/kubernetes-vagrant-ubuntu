# kubernetes-vagrant-ubuntu

An automated, unattended script that creates on-premises Kubernetes 1.29 Clusters running on Ubuntu virtual machines using Vagrant.

What do you going to need?
- Vagrant https://www.vagrantup.com/docs/installation. Vagrant, developed by HashiCorp, is an open-source tool for creating and managing virtualized development environments. It allows users to easily configure and replicate development setups across different machines.
- VirtualBox https://www.virtualbox.org. VirtualBox is a free and open-source virtualization platform offered by Oracle.
- 4 Virtual Machines. One for the master node (3GB RAM, 1 vCPU), and three as workers (3GB RAM, 1 vCPU). All of them will be automatically provisioned via Vagrant, which is actually the partial scope of this article.
- An additional VirtualBox Host-Only Network. A Host-Only Network is a network configuration that allows communication between virtual machines and the host system but not with external networks. It provides a private network for isolated communication among virtual machines and the host. This can be useful for development and testing scenarios where you want to create a closed network environment.

Just execute the following script, and depending on your hardware you should expect a fully functionable Kubernetes 1.29 Cluster to be created in the next 10 minutes:

```
./setup.sh
```

# Git
```
git init
git add .
git commit -m "first commit"
git remote add origin https://github.com/namtranvn/kubernetes-vagrant-ubuntu.git
git push --set-upstream origin master
```

# Docker Build
```
docker build --no-cache -t flask-controller:v1 .
docker login
docker tag flask-controller:v1 hoainamtran204/flask-controller:v1
docker push hoainamtran204/flask-controller:v1
docker run -td flask-controller:v1
docker exec -it containerid bash
```

# Local Test
```
curl -I namct.local.test
kubectl run test-nginx-svc --image=nginx
kubectl exec -it test-nginx-svc -- bash
```
