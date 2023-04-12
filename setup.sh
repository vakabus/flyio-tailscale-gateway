#!/bin/bash

# fail fast
set -e

# give tailscaled time to initialize
echo "starting tailscaled"
tailscaled &

echo "waiting for tailscaled full startup"
sleep 5

## Forwarding the traffic directly from the kernel would be nice, but 
## Fly.io's firecracker VM's probably don't have the required kernel modules?
## I don't know, what is the exact problem, but it doesn't work. :(
#
#
# echo "configuring forwarding"
# sysctl -w net.ipv4.ip_forward=1

# echo "updating firewall rules"
# nft add table ip nat
# nft -- add chain ip nat prerouting \{ type nat hook prerouting priority -100 \; \}
# nft -- add chain ip nat postrouting \{ type nat hook postrouting priority 100 \; \}
# nft add rule ip nat prerouting tcp dport 80 dnat to $TARGET_IP
# nft add rule ip nat prerouting tcp dport 443 dnat to $TARGET_IP
# nft add rule ip nat postrouting ip daddr $TARGET_IP masquerade


echo "setting up tailscale VPN"
tailscale up --hostname gateway --auth-key $TAILSCALE_AUTH_KEY

echo "starting forwarders"
socat -d -d TCP4-LISTEN:80,reuseaddr,fork,su=nobody TCP4:$TARGET_IP:80 &
socat -d -d TCP4-LISTEN:443,reuseaddr,fork,su=nobody TCP4:$TARGET_IP:443 &
socat -d -d UDP4-LISTEN:443,reuseaddr,fork,su=nobody UDP4:$TARGET_IP:443 &


echo "waiting for exit of all processes"
wait
