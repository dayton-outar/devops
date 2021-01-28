# Watch cluster by a given namespace. In this case the cluster with namespace, drupal
kubectl get deployments -n drupal -w

# Sets context for any general command to run against a given namespace ... kubectl get deployments
kubectl config set-context --current --namespace=drupal

# Revert out of context
kubectl config set-context --current --namespace=""

# Show details for nodes
kubectl get nodes -o wide

# Find drupal service within drupal namespace
kubectl get service -n drupal drupal

# Delete namespace
kubectl delete namespace drupal