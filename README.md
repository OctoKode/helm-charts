# Helm Charts

This repository contains Helm charts for Kubernetes applications.

## Usage

[Helm](https://helm.sh) must be installed to use the charts. Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

```bash
helm repo add octokode https://OctoKode.github.io/helm-charts
```

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages. You can then run `helm search repo
octokode` to see the charts.

To install a chart:

```bash
helm install my-release octokode/<chart-name>
```

To uninstall a chart:

```bash
helm delete my-release
```

## Charts

- [kyverno-artifact-operator](charts/kyverno-artifact-operator) - Kubernetes operator that automatically syncs Kyverno policies from OCI artifacts

## Development

### Prerequisites

- [Helm](https://helm.sh/docs/intro/install/) 3.13+
- [chart-testing](https://github.com/helm/chart-testing) 3.10+
- [kind](https://kind.sigs.k8s.io/) for local testing

### Testing Charts Locally

```bash
# Lint charts
ct lint --all

# Create a kind cluster
kind create cluster

# Install and test charts
ct install --all
```

## Repository Setup

### Enabling GitHub Pages

To publish your Helm charts, you need to enable GitHub Pages:

1. Go to your repository settings
2. Navigate to "Pages" section
3. Under "Source", select "gh-pages" branch
4. Save the settings

The GitHub Actions workflow will automatically create and update the `gh-pages` branch when you push tags.

### Publishing a Chart Release

1. Update your chart version in `Chart.yaml`
2. Commit your changes
3. Create and push a version tag:

   ```bash
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```

4. GitHub Actions will automatically package and publish the chart

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
