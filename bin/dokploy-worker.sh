#!/bin/bash

# Wait for apt lock to be released before running any package operations.
# Cloud images run unattended-upgrades on first boot which holds the lock.
while fuser /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock /var/lib/dpkg/lock >/dev/null 2>&1; do
  sleep 5
done

# Install OpenSSH server and UFW
apt-get install -y openssh-server ufw

# Install Dokploy
DOKPLOY_INSTALLER="$(mktemp)"
curl -sSfL https://dokploy.com/install.sh -o "$DOKPLOY_INSTALLER"
chmod 700 "$DOKPLOY_INSTALLER"
bash "$DOKPLOY_INSTALLER"
rm -f "$DOKPLOY_INSTALLER"

# Allow Docker Swarm traffic
ufw allow 80,443,996,7946,4789,2377/tcp
ufw allow 7946,4789,2377/udp

iptables -I INPUT 1 -p tcp --dport 2377 -j ACCEPT
iptables -I INPUT 1 -p udp --dport 7946 -j ACCEPT
iptables -I INPUT 1 -p tcp --dport 7946 -j ACCEPT
iptables -I INPUT 1 -p udp --dport 4789 -j ACCEPT

# Reorder FORWARD chain rules:
# Remove the default REJECT rule (ignore error if not found)
iptables -D FORWARD -j REJECT --reject-with icmp-host-prohibited || true
# Append the REJECT rule at the end so that Docker rules can be matched first
iptables -A FORWARD -j REJECT --reject-with icmp-host-prohibited

netfilter-persistent save
