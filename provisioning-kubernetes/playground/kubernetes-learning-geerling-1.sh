# Displays cluster information
kubectl cluster-info

# Displays nodes in cluster
kubectl get nodes

kubectl create deployment hello-k8s --image=geerlingguy/kube101:intro

# Exposes the cluster
kubectl expose deployment hello-k8s --type=NodePort --port=80

# Watch the pods created
watch kubectl get deployment hello-k8s

# Another way to see status of pods
kubectl get pod -l app=hello-k8s

# Describe pod
kubectl describe pod -l app=hello-k8s

# Displays list of services on cluster
kubectl get services hello-k8s

# Outputs list of services on cluster in YAML
kubectl get svc hello-k8s -o yaml

#Output list of services on cluster in JSON
kubectl get svc hello-k8s -o json

# View history of changes to cluster
kubectl rollout history deployment hello-k8s

# Get IP address of cluster
minikube ip

# Opens browser with exposed service
minikube service hello-k8s

# If you want to un-expose the node
kubectl delete service hello-k8s

# View to edit deployment YAML
kubectl edit deployment hello-k8s

# Remove Kubernetes Cluster ... (Removes Docket Container, Network, Volumes. Everything associated with this setup)
minikube delete