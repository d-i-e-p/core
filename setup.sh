#!/bin/sh
set -o errexit
echo "Starting Setup"

# Inspired by  https://github.com/fluxcd/flux2/discussions/1499
# Step 2 - Install Flux-System componenents in the cluster
kubectl apply -f flux/flux-system/gotk-components.yaml
kubectl apply -f flux/flux-system/gotk-sync.yaml


# Step 3 - Install core componentns
export COMPONENTS_CONFIG_DIR=components/config

kubectl apply -f $COMPONENTS_CONFIG_DIR