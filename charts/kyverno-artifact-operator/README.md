# kyverno-artifact-operator

A Kubernetes operator that automatically syncs Kyverno policies from OCI artifacts (like GitHub Container Registry) to your cluster.

## Description

The Kyverno Artifact Operator watches OCI artifacts for changes and automatically applies Kyverno policies to your Kubernetes cluster. When you push a new version of your policy artifact, the operator detects the change, pulls the new policies, and applies them to your cluster.

## Features

- 🔄 Automatic policy synchronization from OCI registries
- 📦 Support for GitHub Container Registry (GHCR) and Artifactory
- ⏱️ Configurable polling intervals
- 🔒 Secure token management via Kubernetes secrets
- 📊 Prometheus metrics for monitoring

## Prerequisites

- Kubernetes 1.25+
- Helm 3.0+
- Kyverno installed in the cluster

## Installing the Chart

```bash
helm repo add octokode https://octokode.github.io/helm-charts
helm repo update
helm install kyverno-artifact-operator octokode/kyverno-artifact-operator -n kyverno-artifact-operator-system --create-namespace
```

## Configuration

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
| `watcher.image.repository` | Watcher image repository | `ghcr.io/octokode/kyverno-artifact-watcher` |
| `watcher.image.tag` | Watcher image tag | `latest` |
| `watcher.secret.name` | Name of secret containing registry credentials | `kyverno-watcher-secret` |
| `watcher.secret.githubTokenKey` | Key for GitHub token in secret | `github-token` |
| `watcher.secret.artifactoryUsernameKey` | Key for Artifactory username in secret | `artifactory-username` |
| `watcher.secret.artifactoryPasswordKey` | Key for Artifactory password in secret | `artifactory-password` |
| `controller.resources.limits.cpu` | CPU limit for controller | `500m` |
| `controller.resources.limits.memory` | Memory limit for controller | `128Mi` |
| `controller.resources.requests.cpu` | CPU request for controller | `10m` |
| `controller.resources.requests.memory` | Memory request for controller | `64Mi` |
| `namespace.create` | Create the namespace | `true` |
| `namespace.name` | Namespace name | `kyverno-artifact-operator-system` |

### Example Custom Values

```yaml
# custom-values.yaml
image:
  tag: "v0.1.0"

watcher:
  image:
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
```

Install with custom values:

```bash
helm install kyverno-artifact-operator octokode/kyverno-artifact-operator \
  -n kyverno-artifact-operator-system \
  --create-namespace \
  -f custom-values.yaml
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
