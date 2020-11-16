#Connect to the proxy container of any of the protected services
kubectl exec -i -t my-pod --container main-app -- /bin/bash

curl http://details.bookinfo.svc.cluster.local:9080/details/100

## Containers level
docker container exec -it $(docker container ls --filter name=istio-proxy_productpage --format '{{ .ID}}') sh

curl -k https://details:9080/details/100 --key /etc/certs/key.pem --cert /etc/certs/cert-chain.pem --cacert /etc/certs/root-cert.pem

cat /etc/certs/cert-chain.pem | openssl x509 -text -noout  | grep Validity -A 2

cat /etc/certs/cert-chain.pem | openssl x509 -text -noout  | grep 'Subject Alternative Name' -A 1