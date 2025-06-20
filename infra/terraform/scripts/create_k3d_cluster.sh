#!/bin/bash
# infra/terraform/scripts/create_k3d_cluster.sh

# This script creates a k3d Kubernetes cluster if it doesn't already exist.
# It now receives parameters as command-line arguments ($1, $2, $3).

# Assign command-line arguments to descriptive shell variables
K3D_CLUSTER_NAME="$1" # First argument is the cluster name
HOST_PORT="$2"        # Second argument is the host port
K8S_PORT="$3"         # Third argument is the k8s port

echo "Checking for k3d cluster: ${K3D_CLUSTER_NAME}"

# Check if the k3d cluster already exists.
# `grep -q` is for quiet mode, suppresses output.
if ! k3d cluster list | grep -q "${K3D_CLUSTER_NAME}"; then
  echo "Creating k3d cluster '${K3D_CLUSTER_NAME}'..."
  # Create the k3d cluster with specified name, servers, agents, wait for readiness,
  # and map the host port to the load balancer's Kubernetes port.
  k3d cluster create "${K3D_CLUSTER_NAME}" \
    --servers 1 --agents 1 --wait \
    --port "${HOST_PORT}:${K8S_PORT}@loadbalancer"
  echo "k3d cluster '${K3D_CLUSTER_NAME}' created."
else
  echo "k3d cluster '${K3D_CLUSTER_NAME}' already exists. Skipping creation."
fi

# Exit with success code
exit 0