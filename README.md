# Fly.io Tailscale Gateway

Crappy way to forward network traffic to my home server without public IP. Somewhat similar to Tailscale Funnel, but allows for custom domain names. And it's cheaper than a full VPS. 😇

## Expectations

1. You are using [Tailscale](https://tailscale.com)
2. There is one server in your tailnet, which handles incoming HTTP(S) traffic and forwards it to proper services.
	- It should have valid TLS certificates.
	- Using [Caddy](https://caddyserver.com) with DNS challenge works really well.


## Usage

Deploy:

```
flyctl launch
flyctl ips allocate-v4
flyctl secrets set TARGET_IP=...
flyctl secrets set TAILSCALE_AUTH_KEY=...
flyctl deploy
```

DNS config:

- set an A record for the gateway with the IP from Fly.io (for example `gateway.vsq.cz -> $(flyctl ips list)`)
- for all the services, use CNAME records pointing to the gateway record
	- this way, if you have to change it in the future, it won't be that hard


## Warning

Do not rely on this for any critical connections. The setup is not at all robust and will definitely break.
