#!/bin/sh
set -o errexit

CMDS="kind flux kubectl"

for i in $CMDS
do
    # command -v will return >0 when the $i is not found
	command -v $i >/dev/null && continue || { echo "command $i not found. Please install $i to proceed!"; exit 1; }
done
 
echo "Starting setup...."

# desired cluster name; default is "kind"
KIND_CLUSTER_NAME="${KIND_CLUSTER_NAME:-shap}"

# Prune cluster
kind delete cluster --name $KIND_CLUSTER_NAME

# Prune temp configs
rm -rf temp?

# Step 1 - Create new cluster
kind create cluster --config kind/config/cluster-ingress-config.yaml --name $KIND_CLUSTER_NAME

kubectl config use-context kind-$KIND_CLUSTER_NAME
kubectl cluster-info 

# Inspired by  https://github.com/fluxcd/flux2/discussions/1499
# Step 2 - Install Flux-System componenents in the cluster
kubectl apply -f flux/flux-system/gotk-components.yaml
kubectl apply -f flux/flux-system/gotk-sync.yaml


# Step 3 - Create mqtt flux files
export COMPONENTS_CONFIG_DIR=temp/components/config
mkdir -p $COMPONENTS_CONFIG_DIR

flux create source git mqtt-component \
  --url=https://github.com/s-h-a-p/mqtt-component \
  --branch=main \
  --interval=30s \
  --export > ./$COMPONENTS_CONFIG_DIR/mqtt-component-source.yaml

flux create source git ingress-nginx-component \
  --url=https://github.com/kubernetes/ingress-nginx \
  --branch=main \
  --interval=30s \
  --export > ./$COMPONENTS_CONFIG_DIR/ingress-nginx-component-source.yaml  

flux create source git mqtt-web-client-component \
  --url=https://github.com/s-h-a-p/mqtt-web-client-component \
  --branch=main \
  --interval=30s \
  --export > ./$COMPONENTS_CONFIG_DIR/mqtt-web-client-component-source.yaml    

flux create kustomization mqtt-component \
  --target-namespace=mqtt \
  --source=mqtt-component \
  --path="./deployment" \
  --prune=true \
  --interval=5m \
  --export > ./$COMPONENTS_CONFIG_DIR/mqtt-component-kustomization.yaml

flux create kustomization ingress-nginx-component \
  --target-namespace=ingress-nginx \
  --source=ingress-nginx-component \
  --path="./deploy/static/provider/kind" \
  --prune=true \
  --interval=5m \
  --export > ./$COMPONENTS_CONFIG_DIR/ingress-nginx-component-kustomization.yaml

flux create kustomization mqtt-web-client-component \
  --target-namespace=mqtt \
  --source=mqtt-web-client-component \
  --path="./deployment" \
  --prune=true \
  --interval=5m \
  --export > ./$COMPONENTS_CONFIG_DIR/mqtt-web-client-component-kustomization.yaml

kubectl apply -f $COMPONENTS_CONFIG_DIR