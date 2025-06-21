#!/bin/bash

CLUSTER_NAME="${cluster_name}"
PORT_MAPPINGS="${port_mappings}"
AGENTS="${agent_count}"
SERVER_ARGS="${server_args}"

echo "🔧 Checking if k3d cluster '$CLUSTER_NAME' exists..."

if ! k3d cluster list | grep -q "$CLUSTER_NAME"; then
  echo "🔧 Creating k3d cluster: $CLUSTER_NAME"
  k3d cluster create "$CLUSTER_NAME" \
    --agents "$AGENTS" \
    $PORT_MAPPINGS \
    $SERVER_ARGS
else
  echo "Cluster '$CLUSTER_NAME' already exists. Skipping creation."
fi
