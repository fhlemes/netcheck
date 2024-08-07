#!/bin/bash

# Entrypoint script for NetCheck - A Kubernetes network analysis tool
# Created and maintained by Flavio Lemes

# Configura o tempo limite para a verificação de conectividade
TIMEOUT=5

# Configura uma lista de sites externos para verificar a conectividade
EXTERNAL_SITES=("google.com" "cloudflare.com")

# Configura uma lista de sites internos para verificar a conectividade
INTERNAL_SITES=("host.k3d.internal" "host.docker.internal")

# Obtém o namespace do argumento ou define como todos os namespaces por padrão
NAMESPACE=${1:-"--all-namespaces"}

# Função para verificar a conectividade com sites externos
check_external_connectivity() {
  echo "Checking connectivity to external sites:"

  for site in "${EXTERNAL_SITES[@]}"; do
    echo "Checking connectivity to $site"
    if nc -zvw "$TIMEOUT" "$site" 80; then
      echo "Success"
    else
      echo "Failure"
    fi
  done
}

# Função para verificar a conectividade com sites internos
check_internal_connectivity() {
  echo "Checking connectivity to internal sites:"

  for site in "${INTERNAL_SITES[@]}"; do
    echo "Checking connectivity to $site"
    if nc -zvw "$TIMEOUT" "$site" 80; then
      echo "Success"
    else
      echo "Failure"
    fi
  done
}

# Função para listar todos os IPs de pod e suas portas e verificar a conectividade
check_pod_connectivity() {
  echo "Checking connectivity for all pod IPs and ports:"

  PODS=$(kubectl get pods $NAMESPACE -o json)
  echo "PODS: $PODS"
  echo $PODS | jq -r '
    .items[] | 
    select(.status.podIP != null) | 
    . as $pod |
    .spec.containers[]? | 
    select(.ports != null) | 
    .ports[]? | 
    "\($pod.status.podIP) \($pod.metadata.namespace) \($pod.metadata.name) \(.containerPort)"
  ' | sort -u | while read -r ip namespace pod port; do
    if [ -n "$port" ]; then
      echo "Checking connectivity to Pod: $namespace/$pod at $ip:$port"
      if nc -zvw "$TIMEOUT" "$ip" "$port"; then
        echo "Success"
      else
        echo "Failure"
      fi
    else
      echo "No port defined for Pod: $namespace/$pod at $ip"
    fi
  done
}

# Função para listar todos os IPs de serviço e suas portas e verificar a conectividade
check_service_connectivity() {
  echo "Checking connectivity for all service IPs and ports:"

  SERVICES=$(kubectl get svc $NAMESPACE -o json)
  echo "SERVICES: $SERVICES"
  echo $SERVICES | jq -r '
    .items[] | 
    "\(.spec.clusterIP) \(.metadata.namespace) \(.metadata.name) \(.spec.ports[].port)"
  ' | sort -u | while read -r ip namespace svc port; do
    echo "Checking connectivity to Service: $namespace/$svc at $ip:$port"
    if nc -zvw "$TIMEOUT" "$ip" "$port"; then
      echo "Success"
    else
      echo "Failure"
    fi
  done
}

# Main script
echo "Starting network connectivity checks..."
check_p
