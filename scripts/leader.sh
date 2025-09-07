#!/bin/bash

NODES=("headscale-primary" "headscale-replica")
PORTS=(20202 20203)

# Find current primary
PRIMARY=""
PRIMARY_IDX=-1
for i in "${!NODES[@]}"; do
    NODE="${NODES[$i]}"
    PORT="${PORTS[$i]}"
    IS_PRIMARY=$(curl -s "http://127.0.0.1:$PORT/info" | jq -r 'select(.isPrimary == true)')
    if [ -n "$IS_PRIMARY" ]; then
        echo $NODE
        break
    fi
done