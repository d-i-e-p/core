
echo "Starting Setup"

# Step 1 - Install Flux-System componenents in the cluster
k3s kubectl apply -f flux/flux-system/gotk-components.yaml
k3s kubectl apply -f flux/flux-system/gotk-sync.yaml


# Step 2 - Install core componentns
export COMPONENTS_CONFIG_DIR=components/config

k3s kubectl apply -f $COMPONENTS_CONFIG_DIR