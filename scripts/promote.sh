#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


echo "Attempting to promote $NODE to primary on port $PORT..."

# Force the node to become primary by deleting the current lease
echo "Deleting current lease from Consul..."
curl -X DELETE "http://127.0.0.1:8500/v1/kv/litefs/primary"

echo "Waiting for $NODE to acquire lease..."
sleep 5

echo "=== Final Cluster Status ==="
bash "$SCRIPT_DIR/status.sh"