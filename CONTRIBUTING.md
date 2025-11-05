# Contributing to Helm Charts

## How to Contribute

### Reporting Issues

If you find a bug or have a suggestion for improvement:

1. Check if the issue already exists in the [issue tracker](https://github.com/OctoKode/helm-charts/issues)
2. If not, create a new issue with a clear description
3. Include steps to reproduce (for bugs) or detailed explanation (for enhancements)

### Submitting Changes

1. Fork the repository
2. Create a new branch for your changes: `git checkout -b feature/my-new-feature`
3. Make your changes following the guidelines below
4. Commit your changes with clear, descriptive messages
5. Push to your fork and submit a pull request

## Chart Guidelines

### Chart Structure

Each chart should follow the standard Helm chart structure:

```text
charts/
└── my-chart/
    ├── Chart.yaml          # Chart metadata
    ├── values.yaml         # Default configuration values
    ├── README.md           # Chart documentation
    ├── .helmignore        # Files to ignore when packaging
    └── templates/          # Kubernetes manifest templates
        ├── NOTES.txt       # Usage notes shown after installation
        ├── _helpers.tpl    # Template helpers
        └── ...             # Other Kubernetes resources
```

### Chart Requirements

1. **Documentation**: Every chart must have a README.md explaining:
   - What the chart does
   - How to install it
   - Configuration options
   - Examples

2. **Versioning**: Follow [Semantic Versioning](https://semver.org/)
   - MAJOR version for incompatible API changes
   - MINOR version for backwards-compatible functionality
   - PATCH version for backwards-compatible bug fixes

3. **Testing**: Charts should be tested locally before submitting:

   ```bash
   helm lint charts/my-chart
   helm template charts/my-chart
   helm install test-release charts/my-chart --dry-run
   ```

4. **Values**: Provide sensible defaults in `values.yaml`
   - Document all values with comments
   - Use nested structures for organization
   - Follow Kubernetes naming conventions

### Chart Testing

This repository uses [chart-testing](https://github.com/helm/chart-testing) to validate charts:

```bash
# Install ct
brew install chart-testing

# Lint all charts
ct lint --all

# Test installation in a kind cluster
kind create cluster
ct install --all
```

### Pull Request Process

1. Update the chart version in `Chart.yaml`
2. Update the chart's README.md if needed
3. Ensure all tests pass
4. Request a review from maintainers
5. Once approved, your PR will be merged

### Commit Message Guidelines

- Use clear and descriptive commit messages
- Start with a verb in present tense (Add, Fix, Update, etc.)
- Reference issues when applicable: `Fix #123: Description`

Example:

```text
Add nginx-ingress chart

- Include basic ingress controller setup
- Add configuration for TLS
- Document installation steps
```

## Code of Conduct

Please be respectful and constructive in all interactions. This project follows the standard open source code of conduct.

## Questions?

If you have questions about contributing, feel free to open an issue for discussion.

Thank you for contributing! 🎉
