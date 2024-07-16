## NetCheck

[EXPERIMENTAL]

NetCheck is a Kubernetes service for network visibility and connectivity analysis, designed to quickly identify and troubleshoot network issues within your cluster.

### Features

- Executes dedicated pods for network tests
- Performs tests on malfunctioning application pods
- Tests connectivity between pods on the same host
- Verifies internal and external network connectivity

### Getting Started

These instructions will guide you through setting up and using the NetCheck service in your Kubernetes cluster.

### Prerequisites

- Kubernetes cluster
- kubectl configured to interact with your cluster

### Installation

1. Apply Kubernetes Permissions

```sh
kubectl apply -f config/permission.yaml
```

2. Apply Example

```sh
kubectl apply -f example/deployment.yaml
```

3. Check Logs

To check the logs of the NetCheck pod and see the results of the connectivity tests, use:

```
kubectl logs -l app=netcheck
```
