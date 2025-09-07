#!/bin/sh

iter=0
while true
do

    if wget -qO- http://localhost:20202/info | grep -q '"isPrimary": true'; then
        echo "Node is primary, starting headscale..."
        headscale serve
        exit_code=$?   # capture exit code of headscale serve
        echo "headscale serve exited with code: $exit_code"
        exit $exit_code  # propagate it if you want the script to exit with same code
    fi

    if [ $iter -eq 0 ]; then
        echo "Node is not primary, headscale cant works in read mode. Headscale not started. Entering standby mode."
        iter=$((iter + 1))
    fi
    sleep 5
done

