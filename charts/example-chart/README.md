# Example Chart

This is an example Helm chart for Kubernetes.

## Installation

```bash
helm repo add my-charts https://<username>.github.io/helm-charts
helm install my-example my-charts/example-chart
```

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Image repository | `nginx` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `image.tag` | Image tag | `""` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Kubernetes service port | `80` |
| `resources` | CPU/Memory resource requests/limits | `{}` |

## Values

See [values.yaml](values.yaml) for the full list of available parameters.
