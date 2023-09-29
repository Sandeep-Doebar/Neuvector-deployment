#Install NeuVector
#We will now install NeuVector onto our Kubernetes01 Kubernetes cluster. The following command will add neuvector as a helm repository.
helm repo add neuvector https://neuvector.github.io/neuvector-helm/
 
#In order to automatically generate a selfsigned TLS certificate for NeuVector, we have to configure a ClusterIssuer in cert-manager, that the NeuVector helm chart can reference:
cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-cluster-issuer
spec:
  selfSigned: {}
EOF
 
#You can find more information in the cert-manager docs.
#Next, create a values file to configure the Helm installation:
cat <<EOF > ~/neuvector-values.yaml
k3s:
  enabled: true
controller:
  replicas: 1
cve:
  scanner:
    replicas: 1
manager:
  ingress:
    enabled: false
    host:
    annotations:
      cert-manager.io/cluster-issuer: selfsigned-cluster-issuer
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    tls: true
    secretName: neuvector-tls-secret
EOF
 
#Finally, we can install NeuVector using our helm install command.
helm install neuvector neuvector/core \
  --namespace cattle-neuvector-system \
  -f ~/neuvector-values.yaml \
  --version 2.6.0 \
  --create-namespace

