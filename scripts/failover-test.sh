#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# List your nodes here in order
NODES=("headscale-primary" "headscale-replica")
# NODES=("headscale-primary" "headscale-replica" "headscale-node3" "headscale-node4")
PORTS=(20202 20203)

echo "Starting failover test..."

# Find current primary
PRIMARY=""
PRIMARY_IDX=-1
for i in "${!NODES[@]}"; do
    NODE="${NODES[$i]}"
    PORT="${PORTS[$i]}"
    IS_PRIMARY=$(curl -s "http://127.0.0.1:$PORT/info" | jq -r 'select(.isPrimary == true)')
    if [ -n "$IS_PRIMARY" ]; then
        PRIMARY="$NODE"
        PRIMARY_IDX=$i
        break
    fi
done

if [ -z "$PRIMARY" ]; then
    echo "Error: Could not determine primary node."
    exit 1
fi

echo "Current primary: $PRIMARY"

# Select next node in array (circular)
NEXT_IDX=$(( (PRIMARY_IDX + 1) % ${#NODES[@]} ))
NEW_PRIMARY="${NODES[$NEXT_IDX]}"

echo "Starting new primary container: $NEW_PRIMARY"
docker start "$NEW_PRIMARY"

echo "Stopping primary container: $PRIMARY"
docker stop "$PRIMARY"

echo "Waiting 15 seconds for failover..."
sleep 15

echo "=== After Status ==="
for i in "${!NODES[@]}"; do
    NODE="${NODES[$i]}"
    PORT="${PORTS[$i]}"
    curl -s "http://127.0.0.1:$PORT/info" || echo "$NODE: unavailable"
done

echo
echo "Restarting stopped container..."
docker start "$PRIMARY"

echo "Waiting 10 seconds for node to rejoin..."
sleep 10

echo "=== Final Cluster Status ==="
bash "$SCRIPT_DIR/status.sh"