cat <<EOF | cfssl genkey - | cfssljson -bare server
{
  "hosts": [
    "namct.local.com",
    "controller-service.default.svc",
    "flask-api-service.default.svc",
    "flask-controller2.default.pod"
  ],
  "CN": "tls-nam",
  "key": {
    "algo": "ecdsa",
    "size": 256
  }
}
EOF

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: tls-nam
spec:
  request: $(cat server.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 8640000
  usages:
  - digital signature
  - key encipherment
  - server auth
  - client auth
EOF

kubectl certificate approve tls-nam

cat <<EOF | cfssl gencert -initca - | cfssljson -bare ca
{
  "CN": "tls-nam",
  "key": {
    "algo": "rsa",
    "size": 2048
  }
}
EOF

kubectl get csr tls-nam -o jsonpath='{.spec.request}' | \
  base64 --decode | \
  cfssl sign -ca ca.pem -ca-key ca-key.pem -config server-signing-config.json - | \
  cfssljson -bare ca-signed-server

kubectl get csr tls-nam -o json | \
  jq '.status.certificate = "'$(base64 ca-signed-server.pem | tr -d '\n')'"' | \
  kubectl replace --raw /apis/certificates.k8s.io/v1/certificatesigningrequests/tls-nam/status -f -

kubectl get csr tls-nam -o jsonpath='{.status.certificate}' \
    | base64 --decode > server.crt

kubectl create secret tls server --cert server.crt --key server-key.pem