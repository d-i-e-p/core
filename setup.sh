
#!/usr/bin/env bash

# Add the k3s executable path to the PATH variable
export PATH="$1:$PATH"

echo "Starting Setup"

# Inspired by  https://github.com/fluxcd/flux2/discussions/1499
# Step 2 - Install Flux-System componenents in the cluster
k3s kubectl apply -f flux/flux-system/gotk-components.yaml
k3s kubectl apply -f flux/flux-system/gotk-sync.yaml


# Step 3 - Install core componentns
export COMPONENTS_CONFIG_DIR=components/config

k3s kubectl apply -f $COMPONENTS_CONFIG_DIR