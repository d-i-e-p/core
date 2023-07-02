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

# Step 2 - Install Flux in the cluster
kubectl apply -f flux/flux-system/gotk-components.yaml
kubectl apply -f flux/flux-system/gotk-secret.yaml
kubectl apply -f flux/flux-system/gotk-sync.yaml