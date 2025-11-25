# kyverno-artifact-operator

A Kubernetes operator that automatically syncs Kyverno policies from OCI artifacts (like GitHub Container Registry) to your cluster.

## Description

The Kyverno Artifact Operator watches OCI artifacts for changes and automatically applies Kyverno policies to your Kubernetes cluster. When you push a new version of your policy artifact, the operator detects the change, pulls the new policies, and applies them to your cluster.

**Architecture:** The operator uses a unified binary that can run in three modes:

- **Operator mode** (default): Manages KyvernoArtifact custom resources
- **Watcher mode**: Monitors OCI registries for policy updates
- **GC mode** (optional): Performs garbage collection of orphaned resources

The operator automatically deploys watcher pods using the same container image with the `-watcher` flag.

## Features

- Automatic policy synchronization from OCI registries
- Support for GitHub Container Registry (GHCR) and Artifactory
- Configurable polling intervals
- Secure token management via Kubernetes secrets
- Prometheus metrics for monitoring

## Prerequisites

- Kubernetes 1.25+
- Helm 3.0+

## Dependencies

This chart has a dependency on [Kyverno](https://kyverno.io/) v3.5.2, which will be automatically installed by default.

If you already have Kyverno installed, you can disable the dependency installation:

```bash
helm install kyverno-artifact-operator octokode/kyverno-artifact-operator \
  -n kyverno-artifact-operator-system \
  --create-namespace \
  --set kyverno.enabled=false
```

## Installing the Chart

### With Kyverno (Default)

This will install both Kyverno and the operator:

```bash
helm repo add octokode https://octokode.github.io/helm-charts
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno-artifact-operator octokode/kyverno-artifact-operator -n kyverno-artifact-operator-system --create-namespace
```

### Without Kyverno (if already installed)

```bash
helm repo add octokode https://octokode.github.io/helm-charts
helm repo update
helm install kyverno-artifact-operator octokode/kyverno-artifact-operator \
  -n kyverno-artifact-operator-system \
  --create-namespace \
  --set kyverno.enabled=false
```

## Configuration

### Garbage Collection Deployment

The chart includes an optional garbage collection (GC) deployment that can clean up orphaned or stale resources. This deployment is disabled by default.

To enable the GC deployment:

```bash
helm install kyverno-artifact-operator octokode/kyverno-artifact-operator \
  -n kyverno-artifact-operator-system \
  --create-namespace \
  --set gc.enabled=true
```

The GC deployment runs the same operator image with the `gc` command, which performs periodic cleanup tasks. You can customize its polling interval using the `POLL_INTERVAL` environment variable (defaults to 60s):

```yaml
gc:
  enabled: true
  env:
    - name: POLL_INTERVAL
      value: "300s"  # Check every 5 minutes
```

### Registry Credentials

Before creating KyvernoArtifact resources, you need to create a secret with your registry credentials:

#### For GitHub Container Registry (GHCR)

```bash
kubectl create secret generic kyverno-watcher-secret \
  --from-literal=github-token=ghp_YOUR_GITHUB_TOKEN_HERE \
  --namespace=kyverno-artifact-operator-system
```

**Note:** Your GitHub token needs `read:packages` permission.

#### For Artifactory

```bash
kubectl create secret generic kyverno-watcher-secret \
  --from-literal=artifactory-username=YOUR_USERNAME \
  --from-literal=artifactory-password=YOUR_PASSWORD \
  --namespace=kyverno-artifact-operator-system
```

### Creating a KyvernoArtifact Resource

#### For GitHub Container Registry

```yaml
apiVersion: kyverno.octokode.io/v1alpha1
kind: KyvernoArtifact
metadata:
  name: my-policies
  namespace: default
spec:
  url: ghcr.io/YOUR_ORG/YOUR_POLICIES:latest
  type: oci
  provider: github
  pollingInterval: 60
```

#### For JFrog Artifactory

```yaml
apiVersion: kyverno.octokode.io/v1alpha1
kind: KyvernoArtifact
metadata:
  name: my-artifactory-policies
  namespace: default
spec:
  url: artifactory.example.com/docker-local/policies:latest
  type: oci
  provider: artifactory
  pollingInterval: 60
```

### Chart Values

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of controller replicas | `1` |
| `image.repository` | Controller image repository | `ghcr.io/octokode/kyverno-artifact-operator` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `image.tag` | Image tag | `latest` |
| `kyverno.enabled` | Install Kyverno as a dependency | `true` |
| `watcher.image.repository` | Watcher image repository (same as operator) | `ghcr.io/octokode/kyverno-artifact-operator` |
| `watcher.image.tag` | Watcher image tag (same as operator) | `latest` |
| `watcher.secret.name` | Name of secret containing registry credentials | `kyverno-watcher-secret` |
| `watcher.secret.githubTokenKey` | Key for GitHub token in secret | `github-token` |
| `watcher.secret.artifactoryUsernameKey` | Key for Artifactory username in secret | `artifactory-username` |
| `watcher.secret.artifactoryPasswordKey` | Key for Artifactory password in secret | `artifactory-password` |
| `controller.resources.limits.cpu` | CPU limit for controller | `500m` |
| `controller.resources.limits.memory` | Memory limit for controller | `128Mi` |
| `controller.resources.requests.cpu` | CPU request for controller | `10m` |
| `controller.resources.requests.memory` | Memory request for controller | `64Mi` |
| `gc.enabled` | Enable garbage collection deployment | `false` |
| `gc.replicaCount` | Number of GC replicas | `1` |
| `gc.resources.limits.cpu` | CPU limit for GC | `500m` |
| `gc.resources.limits.memory` | Memory limit for GC | `128Mi` |
| `gc.resources.requests.cpu` | CPU request for GC | `10m` |
| `gc.resources.requests.memory` | Memory request for GC | `64Mi` |
| `gc.extraArgs` | Additional arguments for GC command | `[]` |
| `gc.env` | Environment variables for GC deployment | `[]` |
| `namespace.create` | Create the namespace | `true` |
| `namespace.name` | Namespace name | `kyverno-artifact-operator-system` |

### Example Custom Values

```yaml
# custom-values.yaml
image:
  tag: "v0.1.0"

# Note: watcher.image should match the operator image
# since they use the same unified binary
watcher:
  image:
    repository: ghcr.io/octokode/kyverno-artifact-operator
    tag: "v0.1.0"
  secret:
    name: "my-registry-credentials"
    githubTokenKey: "token"

controller:
  resources:
    limits:
      cpu: 1000m
      memory: 256Mi
    requests:
      cpu: 100m
      memory: 128Mi

# Enable garbage collection deployment
gc:
  enabled: true
  replicaCount: 1
  resources:
    limits:
      cpu: 500m
      memory: 128Mi
    requests:
      cpu: 50m
      memory: 64Mi
  # Optional: Customize polling interval
  env:
    - name: POLL_INTERVAL
      value: "300s"  # Check every 5 minutes
```

Install with custom values:

```bash
helm install kyverno-artifact-operator octokode/kyverno-artifact-operator \
  -n kyverno-artifact-operator-system \
  --create-namespace \
  -f custom-values.yaml
```

### Upgrading from Separate Watcher Image

If you're upgrading from a version that used a separate watcher image (`ghcr.io/octokode/kyverno-artifact-watcher`), the chart will automatically use the new unified image. You can:

1. **Let the chart use defaults** (recommended):

   ```bash
   helm upgrade kyverno-artifact-operator octokode/kyverno-artifact-operator \
     -n kyverno-artifact-operator-system
   ```

2. **Or explicitly set the watcher image** (if using custom registry):

   ```yaml
   watcher:
     image:
       repository: my-registry/kyverno-artifact-operator
       tag: "v0.2.7"
   ```

## Uninstalling the Chart

```bash
helm uninstall kyverno-artifact-operator -n kyverno-artifact-operator-system
```

## Source

- **GitHub Repository**: [https://github.com/OctoKode/kyverno-artifact-operator](https://github.com/OctoKode/kyverno-artifact-operator)
- **Chart Repository**: [https://github.com/OctoKode/helm-charts](https://github.com/OctoKode/helm-charts)

## License

Apache License 2.0
