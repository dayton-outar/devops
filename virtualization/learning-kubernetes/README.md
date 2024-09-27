# Learning Kubernetes

### Kubernetes Guide

**Kubernetes (K8s)** is an open-source container orchestration platform designed to automate the deployment, scaling, and management of containerized applications. While Docker helps to package and run individual containers, Kubernetes manages containers across a cluster of machines, ensuring high availability, scaling, and failover.

#### **Key Concepts**

1. **Cluster**:
   - **Master (Control Plane)**: Manages the overall cluster by handling scheduling, state management, and API communication.
   - **Nodes**: Worker machines where containers (Pods) run. Each node is managed by the master.

2. **Pod**:
   - The smallest and most basic deployable unit in Kubernetes. A pod can run one or more containers and represents a single instance of an application.

3. **Service**:
   - A stable, reliable endpoint for a set of Pods. Services ensure that applications can talk to each other even as Pods are dynamically added or removed.

4. **Deployment**:
   - Defines how to deploy Pods and manage their lifecycle, including scaling and updates. It ensures that the desired number of Pods are always running.

5. **ConfigMap & Secret**:
   - **ConfigMap**: Manages configuration data for applications.
   - **Secret**: Stores sensitive information like passwords or tokens securely.

6. **Persistent Volumes (PV)**:
   - Storage that persists beyond the lifecycle of a Pod, ensuring that data remains available even if the Pod is destroyed.

7. **Namespace**:
   - Used to divide cluster resources and manage them more easily. It enables multiple teams or projects to share a Kubernetes cluster without conflict.

---

### Kubernetes Cheat Sheet

---

#### **Cluster Management**

- **Get cluster info**
  ```bash
  kubectl cluster-info
  ```

- **View nodes in the cluster**
  ```bash
  kubectl get nodes
  ```

- **View current contexts (clusters)**
  ```bash
  kubectl config get-contexts
  ```

- **Switch context (to a different cluster)**
  ```bash
  kubectl config use-context <context_name>
  ```

---

#### **Pods**

- **List Pods in all namespaces**
  ```bash
  kubectl get pods --all-namespaces
  ```

- **Get detailed information about a Pod**
  ```bash
  kubectl describe pod <pod_name>
  ```

- **Create a Pod from a YAML file**
  ```bash
  kubectl apply -f <pod.yaml>
  ```

- **Delete a Pod**
  ```bash
  kubectl delete pod <pod_name>
  ```

---

#### **Services**

- **List all services**
  ```bash
  kubectl get services
  ```

- **Get detailed information about a service**
  ```bash
  kubectl describe service <service_name>
  ```

- **Expose a deployment as a service**
  ```bash
  kubectl expose deployment <deployment_name> --type=<type> --port=<port> --target-port=<container_port>
  ```

---

#### **Deployments**

- **Create a deployment**
  ```bash
  kubectl create deployment <name> --image=<image_name>
  ```

- **Scale a deployment**
  ```bash
  kubectl scale deployment <deployment_name> --replicas=<number>
  ```

- **Update a deployment with a new image**
  ```bash
  kubectl set image deployment/<deployment_name> <container_name>=<new_image>
  ```

- **Rollback to a previous deployment**
  ```bash
  kubectl rollout undo deployment/<deployment_name>
  ```

---

#### **Logs & Debugging**

- **View Pod logs**
  ```bash
  kubectl logs <pod_name>
  ```

- **View logs of a specific container within a Pod**
  ```bash
  kubectl logs <pod_name> -c <container_name>
  ```

- **Get real-time Pod log updates**
  ```bash
  kubectl logs -f <pod_name>
  ```

- **Debug into a Pod**
  ```bash
  kubectl exec -it <pod_name> -- /bin/bash
  ```

---

#### **Configuration**

- **View current config (context, cluster, user)**
  ```bash
  kubectl config view
  ```

- **Create a ConfigMap from a file**
  ```bash
  kubectl create configmap <configmap_name> --from-file=<file_path>
  ```

- **Create a Secret**
  ```bash
  kubectl create secret generic <secret_name> --from-literal=<key>=<value>
  ```

---

#### **Namespaces**

- **List all namespaces**
  ```bash
  kubectl get namespaces
  ```

- **Create a namespace**
  ```bash
  kubectl create namespace <namespace_name>
  ```

- **Set a default namespace for a context**
  ```bash
  kubectl config set-context --current --namespace=<namespace_name>
  ```

---

#### **Persistent Storage**

- **Create a PersistentVolume (PV)**
  ```bash
  kubectl apply -f <pv.yaml>
  ```

- **Create a PersistentVolumeClaim (PVC)**
  ```bash
  kubectl apply -f <pvc.yaml>
  ```

- **View PVCs**
  ```bash
  kubectl get pvc
  ```

---

This guide and cheat sheet will help you get familiar with Kubernetes' core concepts and commands, making it easier to manage containerized applications at scale. Let me know if you need any more detailed explanations!

## More Commands

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

## Further Reading

1. [Kubernetes Documentation](https://kubernetes.io/docs/home/)
2. [Automated Tasks with Cronjob](https://kubernetes.io/docs/tasks/job/automated-tasks-with-cron-jobs/)
3. [Kubernetes Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
4. [WARNING: Kubernetes configuration file is group/world-readable](https://github.com/helm/helm/issues/9115)
5. [Kubernetes Cheat Sheet](https://github.com/RehanSaeed/Kubernetes-Cheat-Sheet#kubernetes-cheat-sheet)
6. [Kubernetes Kubectl Commands Cheat Sheet](https://acloudguru.com/blog/engineering/kubernetes-cheat-sheet)
7. [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
8. [Kubernetes 101](https://github.com/geerlingguy/kubernetes-101)

## Videos

1. [Kubernetes Explained in 100 Seconds](https://youtu.be/PziYflu8cB8) - [Fireship](https://www.youtube.com/channel/UCsBjURrPoezykLs9EqgamOA)
2. [Kubernetes Tutorial for Beginners [FULL COURSE in 4 Hours]](https://youtu.be/X48VuDVv0do) - TechWorld with Nana
3. [Kubernetes Provisioning](https://www.youtube.com/playlist?list=PL34sAs7_26wODP4j6owN-36Vg-KbACgkT) - [Just me and Opensource](https://www.youtube.com/c/wenkatn-justmeandopensource)