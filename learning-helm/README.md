# Learning Helm

Helm is an application package manager for Kubernetes. It simplifies creating, deploying and managing applications on Kubernetes.

A Helm Chart is a collection of files that describe a related set of Kubernetes resources.

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

## Tutorial Videos

1. [Create a Helm chart](https://youtu.be/TJ9hPLn0oAs)
2. [Kubernetes & Helm](https://www.youtube.com/playlist?list=PL34sAs7_26wM3HHa6IcTHCGGF3GHNhbcc) - [Just me and Opensource](https://www.youtube.com/c/wenkatn-justmeandopensource)