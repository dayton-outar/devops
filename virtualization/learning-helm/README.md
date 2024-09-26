# Learning Helm

### Short Guide to Using Helm

**Helm** is a package manager for Kubernetes that helps you define, install, and upgrade even the most complex Kubernetes applications. It uses "charts" to manage application deployment.

Helm makes Kubernetes deployments easier by encapsulating resources into reusable packages.

A Helm Chart is a collection of files that describe a related set of Kubernetes resources.

#### 1. **Installation**
   - **MacOS:**
     ```bash
     brew install helm
     ```
   - **Linux:**
     Download the Helm binary from [here](https://github.com/helm/helm/releases) and move it to `/usr/local/bin`.
   - **Windows:** Use Chocolatey:
     ```bash
     choco install kubernetes-helm
     ```

#### 2. **Basic Helm Commands**
   - **Search Charts:**
     Search for a Helm chart from a Helm repository (e.g., the official stable repo):
     ```bash
     helm search repo <chart-name>
     ```
   - **Add a Repository:**
     To add a Helm repository:
     ```bash
     helm repo add <repo-name> <repo-url>
     ```
     Example for adding the stable repository:
     ```bash
     helm repo add stable https://charts.helm.sh/stable
     ```
   - **Update Repositories:**
     To update Helm repositories:
     ```bash
     helm repo update
     ```

#### 3. **Installing a Chart**
   Install a chart into a Kubernetes cluster:
   ```bash
   helm install <release-name> <chart-name>
   ```
   Example for installing WordPress:
   ```bash
   helm install my-wordpress bitnami/wordpress
   ```

#### 4. **Upgrade a Release**
   Upgrade an existing release:
   ```bash
   helm upgrade <release-name> <chart-name>
   ```

#### 5. **Uninstall a Release**
   Uninstall a release:
   ```bash
   helm uninstall <release-name>
   ```

#### 6. **List Installed Releases**
   To list all the installed Helm releases:
   ```bash
   helm list
   ```

#### 7. **Rollback a Release**
   Roll back to a previous release revision:
   ```bash
   helm rollback <release-name> <revision-number>
   ```

---

### Helm Cheat Sheet

| **Command**                      | **Description**                                      |
|-----------------------------------|------------------------------------------------------|
| `helm repo add <repo> <url>`      | Add a Helm repository                                |
| `helm repo list`                  | List all added Helm repositories                     |
| `helm search repo <keyword>`      | Search charts in added repositories                  |
| `helm install <release> <chart>`  | Install a chart with a release name                  |
| `helm upgrade <release> <chart>`  | Upgrade a Helm release                               |
| `helm uninstall <release>`        | Uninstall a Helm release                             |
| `helm list`                       | List all installed releases                          |
| `helm rollback <release> <rev>`   | Rollback a release to a specific revision            |
| `helm template <chart>`           | Render chart templates locally without installing    |
| `helm get all <release>`          | Get all info about a specific release                |
| `helm status <release>`           | Display status of a release                          |
| `helm history <release>`          | View the history of a release                        |
| `helm show values <chart>`        | Show default chart values                            |
| `helm repo update`                | Update the repository index                          |
| `helm create <chart-name>`        | Create a new Helm chart with boilerplate templates   |
| `helm package <chart-folder>`     | Package a chart for sharing or distribution          |
| `helm lint <chart-folder>`        | Check the chart for issues                           |
| `helm test <release>`             | Test a release (if test cases are defined)           |
| `helm diff upgrade <release>`     | Show changes between the current and proposed chart  |


Perform the following to create a chart,

```bash
helm create [chart name]
```

Perform the following to test out the chart to see what it would have Kubernetes execute,

```bash
helm install --dry-run --debug [chart name]
```

## Further Reading

1. [Bitnami Helm Charts](https://github.com/bitnami/charts/tree/master/bitnami)
2. [Create Your First Helm Chart](https://docs.bitnami.com/tutorials/create-your-first-helm-chart/)
3. [Manage Auto-generated Secrets In Your Helm Charts](https://itnext.io/manage-auto-generated-secrets-in-your-helm-charts-5aee48ba6918)

## Tutorial Videos

1. [Create a Helm chart](https://youtu.be/TJ9hPLn0oAs)
2. [Kubernetes & Helm](https://www.youtube.com/playlist?list=PL34sAs7_26wM3HHa6IcTHCGGF3GHNhbcc) - [Just me and Opensource](https://www.youtube.com/c/wenkatn-justmeandopensource)