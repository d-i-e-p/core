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

# Step 1 - Create new cluster
kind create cluster --config kind/config/cluster-ingress-config.yaml --name $KIND_CLUSTER_NAME

kubectl config use-context kind-$KIND_CLUSTER_NAME
kubectl cluster-info 

# Inspired by  https://github.com/fluxcd/flux2/discussions/1499
# Step 2 - Install Flux-System componenents in the cluster
kubectl apply -f flux/flux-system/gotk-components.yaml
kubectl apply -f flux/flux-system/gotk-sync.yaml


# Step 3 - Install core componentns
export COMPONENTS_CONFIG_DIR=components/config

kubectl apply -f $COMPONENTS_CONFIG_DIR