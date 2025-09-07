# About
This small tutorial show how to deploy a [Headscale](https://github.com/juanfont/headscale) and setup sqlite auto replica with [`LiteFS`](https://github.com/superfly/ with autofailover by LiteFs and consul leader election.

# Features
- Primary, replica mode for headscale
- Headscale cannot run with read only mode. Headscale have to have access for write in sqlite. This stack detect when node is leader and do not start headscale. Headscale only start when node is primary.
- Auto failover and leader election by consul
- Auto replica `sqlite` database by `LiteFS`)

# Demo

### Downlaod docker containers and start stack
```bash
#Execute stack
docker-compose up -d 

echo "Sleeping for 20s for first election and execute servers..."
sleep 20
```

### Run small demo with auto failover
```bash
echo "Run status report"
scripts/status.sh

echo "Get actual leader"
leader_name=`scripts/leader.sh`
echo "Actual leader: $leader_name"

echo "Create users in actual leader headscale"
docker-compose exec $leader_name headscale users create test test2

echo "List users from actual leader headscal"
docker-compose exec $leader_name headscale users list

echo "Emulate failover of primary"
scripts/failover-test.sh

echo "Get actual leader"
leader_name=`scripts/leader.sh`
echo "Actual leader: $leader_name"

echo "Now headscale should run in second node"
docker-compose exec $leader_name headscale users list
```


