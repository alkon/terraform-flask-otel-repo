#!/bin/bash

CLUSTER_NAME="${cluster_name}"
HOST_PORT="${host_port}"
CONTAINER_PORT="${container_port}"
NODE_FILTER="${node_filter}"
PROTOCOL="${protocol}"
AGENTS=${agent_count}
SERVER_ARGS="${server_args}"

PORT_MAPPING_1="${host_port}:${container_port}/${protocol}@${node_filter}"
PORT_MAPPING_2="${argocd_host_port}:${argocd_container_port}/${protocol}@server:0"

echo "Checking if k3d cluster '$CLUSTER_NAME' exists..."
echo "Port mapping for app:    $PORT_MAPPING_1"
echo "Port mapping for ArgoCD: $PORT_MAPPING_2"

if ! k3d cluster list | grep -q "^$CLUSTER_NAME"; then
  echo "Creating k3d cluster: $CLUSTER_NAME"
  k3d cluster create "$CLUSTER_NAME" \
    --agents "$AGENTS" \
    --port $PORT_MAPPING_1 \
    --port $PORT_MAPPING_2 \
    $SERVER_ARGS
else
  echo "Cluster '$CLUSTER_NAME' already exists. Checking status..."
  STATUS=$(k3d cluster list "$CLUSTER_NAME" | grep "$CLUSTER_NAME" | awk '{print $3}')
  if [[ "$STATUS" == "stopped" ]]; then
    echo "Starting cluster '$CLUSTER_NAME'..."
    k3d cluster start "$CLUSTER_NAME"
  else
    echo "Cluster '$CLUSTER_NAME' is already running."
  fi
fi
