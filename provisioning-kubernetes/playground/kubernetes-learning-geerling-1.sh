# Displays cluster information
kubectl cluster-info

# Displays nodes in cluster
kubectl get nodes

kubectl create deployment hello-k8s --image=geerlingguy/kube101:intro

# Exposes the cluster
kubectl expose deployment hello-k8s --type=NodePort --port=80

# Displays list of services on cluster
kubectl get services hello-k8s

# Get IP address of cluster
minikube ip

# Opens browser with exposed service
minikube service hello-k8s

# If you want to un-expose the node
kubectl delete service hello-k8s

# Remove Kubernetes Cluster ... (Removes Docket Container, Network, Volumes. Everything associated with this setup)
minikube delete