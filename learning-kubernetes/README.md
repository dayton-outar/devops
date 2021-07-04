# Learning Kubernetes

The following command list all supported API versions:

```bash
kubectl api-versions
```

Following command successfully display all kubernetes objects

```bash
kubectl api-resources
```

Following command shows details for kubernetes object

```bash
kubectl explain --help
```

```bash
kubectl explain pods
```

## Notes

When applying the Kubernetes component, secrets and config maps has to be deployed before a deployment and service.

To convert a plain text into base64 encoded format in bash, use the following

```bash
echo -n 'boom' | base64

```

## Tutorial Videos

1. [Kubernetes Tutorial for Beginners [FULL COURSE in 4 Hours]](https://youtu.be/X48VuDVv0do) - TechWorld with Nana
2. [Kubernetes Provisioning](https://www.youtube.com/playlist?list=PL34sAs7_26wODP4j6owN-36Vg-KbACgkT) - [Just me and Opensource](https://www.youtube.com/c/wenkatn-justmeandopensource)