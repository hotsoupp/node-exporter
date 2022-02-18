#!/bin/bash
# Install Node Export on all LXC's

# list of container ids we need to iterate through
containers=$(pct list | tail -n +2 | cut -f1 -d' ')

function update_container() {
  container=$1
  echo "Installing Node Exporter on $container..."
  # to chain commands within one exec we will need to wrap them in bash
  pct exec $container -- bash -c "wget https://raw.githubusercontent.com/hotsoupp/node-exporter/main/node_exporter.sh"
  pct exec $container -- bash -c "chmod +x node_exporter.sh"
  pct exec $container -- bash -c "./node_exporter.sh"
}

for container in $containers
do
  update_container $container
done