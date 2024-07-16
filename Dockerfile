# Dockerfile for NetCheck - A Kubernetes network analysis tool
# Maintained by Flavio Lemes

FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache netcat-openbsd iperf3 curl jq bash

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
