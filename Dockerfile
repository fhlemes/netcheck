# Dockerfile for NetCheck - A Kubernetes network analysis tool
# Maintained by Flavio Lemes

FROM alpine:latest

RUN apk add --no-cache netcat-openbsd iperf3

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]