#!/bin/bash

REQUIRED_CRD_NAME="${crd_name}"             # Changed internal variable name slightly for clarity
TIMEOUT_SECONDS="${timeout_seconds}"
SLEEP_INTERVAL_SECONDS="${sleep_interval_seconds}"

echo "Waiting for CRD '$$REQUIRED_CRD_NAME' to be available (timeout: $$TIMEOUT_SECONDS s, interval: $$SLEEP_INTERVAL_SECONDS s)..."
end_time=$((SECONDS + $$TIMEOUT_SECONDS)) # $$TIMEOUT_SECONDS for shell variable

while true; do
    # Use the shell variable REQUIRED_CRD_NAME for kubectl command
    kubectl get crd "$$REQUIRED_CRD_NAME" > /dev/null 2>&1
    if [ $$? -eq 0 ]; then # $$? for literal $? (exit code of last command)
        echo "CRD '$$REQUIRED_CRD_NAME' is available."
        exit 0
    fi

    if [ "$SECONDS" -ge "$$end_time" ]; then # $$end_time for shell variable
        echo "Error: Timeout waiting for CRD '$$REQUIRED_CRD_NAME'."
        exit 1
    fi

    sleep "$$SLEEP_INTERVAL_SECONDS"
done