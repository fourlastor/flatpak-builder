FROM ubuntu:24.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    flatpak \
    zip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Add flathub remote and set collection ID for P2P/USB export
RUN flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && \
    flatpak remote-modify --collection-id=org.flathub.Stable flathub

# Setup volume for output
VOLUME /output

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
