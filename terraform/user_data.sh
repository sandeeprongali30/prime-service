#!/bin/bash
set -ex

echo "Installing Docker (latest)..."

apt-get update -y
apt-get install -y ca-certificates curl gnupg

# Add Docker GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add repo
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker + Compose v2
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable docker
systemctl start docker

echo "Docker installed"

# Setup app dir
mkdir -p /opt/prime-service
cd /opt/prime-service

echo "Downloading docker-compose.yaml..."

curl -o docker-compose.yaml \
https://raw.githubusercontent.com/sandeeprongali30/prime-service/main/docker-compose.yaml

mkdir -p vpn

echo "Starting containers..."
docker compose up -d

echo "Waiting for WireGuard container..."

# Wait until container is up
for i in {1..20}; do
  CONTAINER=$(docker ps --format "{{.Names}}" | grep wireguard || true)
  if [ ! -z "$CONTAINER" ]; then
    echo "Container found: $CONTAINER"
    break
  fi
  sleep 5
done

echo "Waiting for peer1.conf..."

for i in {1..20}; do
  if docker exec $CONTAINER test -f /config/peer1/peer1.conf; then
    echo "peer1.conf found"
    break
  fi
  sleep 5
done

echo "Updating peer1.conf..."

docker exec $CONTAINER sh -c "
  sed -i 's|AllowedIPs = .*|AllowedIPs = 10.0.0.0/24|' /config/peer1/peer1.conf
  sed -i 's|^ListenPort =|# ListenPort =|' /config/peer1/peer1.conf
"

echo "Verifying changes..."

docker exec $CONTAINER cat /config/peer1/peer1.conf

echo "Setup completed!"