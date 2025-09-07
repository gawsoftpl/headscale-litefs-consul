# About
This small tutorial show how to deploy a [Headscale](https://github.com/juanfont/headscale) and setup sqlite auto replica with [`LiteFS`](https://github.com/superfly/ with autofailover by LiteFs and consul leader election.

## Conspect
Achieving High Availability for Headscale with SQLite Using Consul and Auto Failover

Headscale, the open-source self-hosted alternative to Tailscale, is designed to be simple, lightweight, and primarily uses SQLite as its database. While Headscale does not natively support high availability (HA) setups or multiple active servers, there are ways to ensure resilience in production environments. In this article, I will explain why I chose a particular architecture using SQLite, Consul, and automatic failover, and why alternatives like PostgreSQL were not suitable.


##

# Features
- Primary, replica mode for headscale
- Headscale cannot run with read only mode. Headscale have to have access for write in sqlite. This stack detect when node is leader and do not start headscale. Headscale only start when node is primary.
- Auto failover and leader election by consul
- Auto replica `sqlite` database by `LiteFS`)

# Demo

### Download docker containers and start stack
```bash
#Execute stack
docker-compose up -d 

echo "Sleeping for 20s for first election and execute servers..."
sleep 20
```

### Run small demo with auto failover
Those commands emulate failover of primary and auto switch to another node by consule leader election:

```bash
echo "Run status report"
scripts/status.sh

# Get actual ledaers
leader_name=`scripts/leader.sh`
echo "Actual leader: $leader_name"

# Create users
docker-compose exec $leader_name headscale users create test test2

# List headscale users
docker-compose exec $leader_name headscale users list

echo "Emulate failover of primary"
scripts/failover-test.sh

# Get new leader
leader_name=`scripts/leader.sh`
echo "Actual leader: $leader_name"

echo "Now headscale should run in second node"
docker-compose exec $leader_name headscale users list
```


