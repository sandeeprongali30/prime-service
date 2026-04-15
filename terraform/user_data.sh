#!/bin/bash

set -e

echo "Starting EC2 setup..."

apt-get update -y
apt-get upgrade -y

apt-get install -y docker.io docker-compose curl

systemctl start docker
systemctl enable docker

mkdir -p /opt/prime-service
cd /opt/prime-service

echo "Downloading docker-compose.yaml..."

curl -o docker-compose.yaml \
https://raw.githubusercontent.com/sandeeprongali30/prime-service/main/docker-compose.yaml

mkdir -p vpn

echo "Starting containers..."
docker compose up -d

echo "Waiting for WireGuard config..."

for i in {1..12}; do
  if docker exec wireguard_vpn test -f /config/peer1/peer1.conf; then
    echo "peer1.conf found"
    break
  fi
  sleep 5
done

echo "Updating peer1.conf..."

docker exec wireguard_vpn sh -c "
  sed -i 's|AllowedIPs = .*|AllowedIPs = 10.0.0.0/24|' /config/peer1/peer1.conf
  sed -i 's|^ListenPort =|# ListenPort =|' /config/peer1/peer1.conf
"

echo "peer1.conf updated"

echo "Setup completed!"