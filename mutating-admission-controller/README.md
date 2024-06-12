# Create Certificates
```
openssl genrsa -out dev-nam.key 2048
openssl req -new -key dev-nam.key -out dev-nam.csr -subj "/CN=nam"

touch dev-nam-csr.yaml  #create dev-nam-csr.yaml file
https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/

request is the base64 encoded value of the CSR file content. You can get the content using this command:
cat dev-nam.csr | base64 | tr -d "\n"

kubectl apply -f dev-nam-csr.yaml
kubectl get csr
kubectl certificate approve dev-nam
kubectl get csr dev-nam -o yaml
kubectl get csr dev-nam -o jsonpath='{.status.certificate}'| base64 -d > dev-nam.crt
```

# Docker Build
```
docker build --no-cache -t flask-controller2:v1 .
docker login
docker tag flask-controller2:v1 hoainamtran204/flask-controller2:v1
docker push hoainamtran204/flask-controller2:v1

docker run -td flask-controller2:v1
docker exec -it 71aac4d190e1b0ea8d8add7cc2f2af5aaee40c6d8b8d888d619e2e39bbd569c8 sh
```

# Deploy mutation controller
kubectl apply -f controller-https.yaml
kubectl apply -f mutating_admission_webhook.yaml

kubectl delete -f controller-https.yaml
kubectl delete -f mutating_admission_webhook.yaml


kubectl apply -f test-deployment.yaml
kubectl exec -it test-nginx-svc -- bash



https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/

Error from server (InternalError): error when creating "test-deployment.yaml": Internal error occurred: failed calling webhook "test.example.com": failed to call webhook: Post "https://controller-service.default.svc:443/mutate/deployments?timeout=30s": tls: failed to verify certificate: x509: certificate is not valid for any names, but wanted to match controller-service.default.svc

kubernetes tls: failed to verify certificate: x509: certificate signed by unknown authority

Error from server (InternalError): error when creating "test-deployment.yaml": Internal error occurred: failed calling webhook "test.example.com": received invalid webhook response: expected response.uid="1e2947ee-ec75-44a6-8cee-db7fe22ec5b8", got ""

https://kmitevski.com/kubernetes-mutating-webhook-with-python-and-fastapi/