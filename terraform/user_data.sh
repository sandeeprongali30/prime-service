#!/bin/bash
set -ex

echo "Installing Docker (latest)..."

apt-get update -y
apt-get install -y ca-certificates curl gnupg

# Add Docker official GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repo
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start Docker
systemctl enable docker
systemctl start docker

echo "Docker installed"

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