FROM docker.io/debian:bookworm

RUN apt-get update && \
	apt-get upgrade && \
	apt-get install -y --no-install-recommends --no-install-suggests \
	curl \
	debian-keyring \
	debian-archive-keyring \
	apt-transport-https \
	ca-certificates \
	gnupg && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# tailscale keyring and repo
RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null && \
	curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list
	

# install
RUN apt-get update && \
	apt-get install -y --no-install-recommends --no-install-suggests \
	tailscale socat && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

COPY setup.sh /setup.sh

CMD ["/bin/bash", "/setup.sh"]
