#Install cert-manager
#cert-manager is a Kubernetes add-on to automate the management and issuance of TLS certificates from various issuing sources.
#The following set of steps will install cert-manager which will be used to manage the TLS certificates for NeuVector.
#First, we'll add the helm repository for Jetstack
helm repo add jetstack https://charts.jetstack.io
 
#Now, we can install cert-manager version 1.7.1
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.7.1 \
  --set installCRDs=true \
  --create-namespace
 
#Once the helm chart has installed, you can monitor the rollout status of both cert-manager and cert-manager-webhook
kubectl -n cert-manager rollout status deploy/cert-manager
 
#You should eventually receive output similar to:
#Waiting for deployment "cert-manager" rollout to finish: 0 of 1 updated replicas are available...
#deployment "cert-manager" successfully rolled out
kubectl -n cert-manager rollout status deploy/cert-manager-webhook
 
#You should eventually receive output similar to:
#Waiting for deployment "cert-manager-webhook" rollout to finish: 0 of 1 updated replicas are available...
#deployment "cert-manager-webhook" successfully rolled out
