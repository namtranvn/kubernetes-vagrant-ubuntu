#!/bin/bash

# rm -rf ./certs
# mkdir certs/
# cd ./certs;

openssl genrsa -out dev-nam.key 2048
openssl req -new -key dev-nam.key -out dev-nam.csr -subj "/CN=nam"

# request is the base64 encoded value of the CSR file content. You can get the content using this command:
cat dev-nam.csr | base64 | tr -d "\n"

kubectl apply -f dev-nam-csr.yaml
kubectl get csr
kubectl certificate approve dev-nam
kubectl get csr dev-nam -o yaml
kubectl get csr dev-nam -o jsonpath='{.status.certificate}'| base64 -d > dev-nam.crt