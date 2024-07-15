#!/bin/sh

# Entrypoint script for NetCheck - A Kubernetes network analysis tool
# Created and maintained by Flavio Lemes

if [ "$1" = "netcat" ]; then
    nc -vz $2 $3
elif [ "$1" = "iperf3" ]; then
    iperf3 -c $2 -p $3
else
    echo "Usage: $0 {netcat|iperf3} <target_ip> <target_port>"
fi