#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Define the path to your loki-values.tmpl.yaml
HELM_VALUES_FILE="$(dirname "$0")/../templates/loki-values.tmpl.yaml"

# Get the initial directory to return to later
INITIAL_DIR=$(pwd)

echo "--- Starting Loki template cleanup and targeted Terraform apply ---"

# --- Inspection Point 1: Initial loki-values.tmpl.yaml content (before script modification) ---
echo "--- Inspection Point 1: Initial loki-values.tmpl.yaml content (before script modification) ---"
if [ -f "$HELM_VALUES_FILE" ]; then
    cat "$HELM_VALUES_FILE"
else
    echo "Warning: ${HELM_VALUES_FILE} does not exist yet. It will be created."
fi
echo "--- End of Initial Template Content ---"


# 1. Creating/overwriting loki-values.tmpl.yaml with clean content
echo "1. Creating/overwriting ${HELM_VALUES_FILE} with clean content..."
# Use a heredoc to write the clean content directly
cat << EOF > "$HELM_VALUES_FILE"
deploymentMode: SingleBinary
loki:
  auth_enabled: false
  server:
    http_listen_port: 3100
    grpc_listen_port: 9095
  singleBinary:
    enabled: true
    replicas: 1
  backend:
    replicas: 0
    enabled: false
  distributor:
    replicas: 0
    enabled: false
  ingester:
    replicas: 0
    enabled: false
  querier:
    replicas: 0
    enabled: false
  queryFrontend:
    replicas: 0
    enabled: false
  compactor:
    replicas: 0
    enabled: false
  ruler:
    replicas: 0
    enabled: false
  indexGateway:
    replicas: 0
    enabled: false
  read:
    replicas: 0
    enabled: false
  write:
    replicas: 0
    enabled: false
  queryScheduler:
    replicas: 0
    enabled: false
  commonConfig: null
  storage:
    type: filesystem
    filesystem:
      chunks_directory: /var/loki/chunks
      rules_directory: /var/loki/rules
      admin_api_directory: /var/loki/admin
  schemaConfig:
    configs:
      - from: "2020-09-07"
        store: "boltdb-shipper"
        object_store: "filesystem"
        schema: "v11"
        index:
          prefix: index_
          period: 24h
service:
  port: 3100
  type: ClusterIP
EOF
echo "    Content written."

# --- Inspection Point 2: loki-values.tmpl.yaml content AFTER script write ---
echo "--- Inspection Point 2: loki-values.tmpl.yaml content AFTER script write ---"
cat "$HELM_VALUES_FILE"
echo "--- End of Content AFTER Write ---"

# 2. Stripping any non-breaking spaces
echo "2. Stripping any non-breaking spaces from ${HELM_VALUES_FILE}..."
# Use sed to remove non-breaking spaces (U+00A0)
# 'sed -i' behaves differently on macOS vs Linux. Using a portable way.
if sed -i '' 's/\xC2\xA0/ /g' "$HELM_VALUES_FILE"; then
    echo "    Non-breaking spaces removed (if any were present)."
else
    # Fallback for systems where -i '' is not supported or if it fails
    sed 's/\xC2\xA0/ /g' "$HELM_VALUES_FILE" > "${HELM_VALUES_FILE}.tmp" && mv "${HELM_VALUES_FILE}.tmp" "$HELM_VALUES_FILE"
    echo "    Non-breaking spaces removed (using fallback)."
fi


# 3. !!! CRITICAL CHECK: Verifying file content with hexdump AFTER SED, BEFORE TERRAFORM:
echo "3. !!! CRITICAL CHECK: Verifying file content with hexdump AFTER SED, BEFORE TERRAFORM:"
hexdump -C "$HELM_VALUES_FILE" | head -n 10 # Display first 10 lines of hexdump for brevity
echo "    (This output MUST show only '20' bytes for spaces, no 'c2 a0')"
echo "----------------------------------------------------------------------"


# --- Inspection Point 4: Running 'helm template' directly with the modified file to debug chart rendering ---
echo "--- Inspection Point 4: Running 'helm template' directly with the modified file to debug chart rendering ---"
TEMP_DIR=$(mktemp -d)
echo "    Changing to temporary directory: $TEMP_DIR"
cd "$TEMP_DIR" || exit 1

# Run helm template with --debug and capture output
echo "    Running: helm template loki-test grafana/loki --version 6.30.1 --values "$HELM_VALUES_FILE" --debug"
HELM_OUTPUT=$(helm template loki-test grafana/loki --version 6.30.1 --values "$HELM_VALUES_FILE" --debug 2>&1)
HELM_STATUS=$?

if [ $HELM_STATUS -ne 0 ]; then
    echo "--- Helm Template Test FAILED! Error Output Below: ---"
    # Print the full debug output in case of failure
    echo "$HELM_OUTPUT"
    echo "--- End Helm Template Test Error ---"
    echo "    The Helm chart itself is failing to render with the provided values, which is the root cause."
    exit 1
else
    echo "--- Helm Template Test SUCCEEDED! ---"
    # Print the full debug output even if successful, for future reference
    echo "$HELM_OUTPUT"
    echo "--- End Helm Template Test Success ---"
fi

# Return to the initial directory
cd "$INITIAL_DIR" || exit 1

# Proceed with Terraform plan (only if helm template succeeded)
echo "--- Running Terraform Plan for Loki module ---"
# Navigate to the loki module directory for Terraform commands
cd "$INITIAL_DIR/modules/loki" || exit 1

terraform init
terraform plan -var-file=loki.tfvars
echo "--- Loki Terraform Plan Complete ---"