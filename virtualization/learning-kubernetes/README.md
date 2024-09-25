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

## Videos

1. [Kubernetes Explained in 100 Seconds](https://youtu.be/PziYflu8cB8) - [Fireship](https://www.youtube.com/channel/UCsBjURrPoezykLs9EqgamOA)
2. [Kubernetes Tutorial for Beginners [FULL COURSE in 4 Hours]](https://youtu.be/X48VuDVv0do) - TechWorld with Nana
3. [Kubernetes Provisioning](https://www.youtube.com/playlist?list=PL34sAs7_26wODP4j6owN-36Vg-KbACgkT) - [Just me and Opensource](https://www.youtube.com/c/wenkatn-justmeandopensource)
4. [Automated Tasks with Cronjob](https://kubernetes.io/docs/tasks/job/automated-tasks-with-cron-jobs/)
    - [CronJobs](https://v1-19.docs.kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) (Kubernetes 1.19)
5. [Kubernetes Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
6. [Docker Tagging: Best practices for tagging and versioning docker images](https://stevelasker.blog/2018/03/01/docker-tagging-best-practices-for-tagging-and-versioning-docker-images/)
7. [WARNING: Kubernetes configuration file is group/world-readable](https://github.com/helm/helm/issues/9115)