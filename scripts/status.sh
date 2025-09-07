#!/bin/bash

echo "=== Consul Status ==="
curl -s http://127.0.0.1:8500/v1/status/leader || echo "Consul unavailable"
echo

echo "=== Consul KV Store (LiteFS Lease) ==="
curl -s http://127.0.0.1:8500/v1/kv/litefs/primary | jq '.[0] | {Key, Value: (.Value | @base64d)}' 2>/dev/null || echo "No lease found"

echo
# echo "=== Container Health ==="
# docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep headscale


echo "=== LiteFS Cluster Status ==="

# Define arrays for node names and ports
NAMES=("Primary" "Slave")
PORTS=("20202" "20203")

for i in "${!NAMES[@]}"; do
	echo "${NAMES[$i]}:"
	curl -s "http://127.0.0.1:${PORTS[$i]}/info" | jq '{isPrimary, primary, pos}' 2>/dev/null || echo "Node ${NAMES[$i]} unavailable"
	echo
done

