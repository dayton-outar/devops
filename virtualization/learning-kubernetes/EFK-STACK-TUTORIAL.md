## Set up elastic stack in kubernetes cluster

###### Deploy and access Dasboard
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
    
_Wait for a couple of seconds for all components to get created and started before executing below commands_

    kubectl proxy 
    http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.

###### For alternatives/ways to access K8s dashboard externally, see
    https://www.edureka.co/community/31282/is-accessing-kubernetes-dashboard-remotely-possible

###### create docker-registry secret for dockerHub
    DOCKER_REGISTRY_SERVER=docker.io
    DOCKER_USER=your dockerID, same as for `docker login`
    DOCKER_EMAIL=your dockerhub email, same as for `docker login`
    DOCKER_PASSWORD=your dockerhub pwd, same as for `docker login`

    kubectl create secret docker-registry myregistrysecret \
    --docker-server=$DOCKER_REGISTRY_SERVER \
    --docker-username=$DOCKER_USER \
    --docker-password=$DOCKER_PASSWORD \
    --docker-email=$DOCKER_EMAIL


### Set cluster-config.yaml file for kubectl after you downloading config file from Linode

###### Restrict kubeconfig file permissions - to avoid security warning in helm v.3.3.2 upwards
https://github.com/microsoft/azure-pipelines-tasks/pull/13633#issue-495303841

    chmod 600 /path/to/config.yaml

###### Linux, MacOS
    export KUBECONFIG=/path/to/config.yaml

###### Windows
    create folder C:\Users\username\.kube
    rename cluster-config.yaml to config
    put config file in .kube folder


### Install Elastic Stack (EFK) Elastic, FluentD, Kibana

##### install elastic search chart 
    helm repo add elastic https://Helm.elastic.co
    helm install elasticsearch elastic/elasticsearch -f values-linode.yaml

##### install Kibana chart
    helm install kibana elastic/kibana

##### access Kibana locally
    kubectl port-forward deployment/kibana-kibana 5601
    access: localhost:5601

##### install nginx-ingress controller
    helm repo add stable https://charts.helm.sh/stable 
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm install nginx-ingress ingress-nginx/ingress-nginx

[New Chart Repo](https://github.com/kubernetes/ingress-nginx/tree/master/charts/ingress-nginx)

###### NOTE
The following repo has been deprecated - https://stackoverflow.com/a/57970816    
    
    helm repo add stable https://kubernetes-charts.storage.googleapis.com/ 

Also ingress rules have changed since Kubernetes 1.19. See https://kubernetes.io/docs/reference/using-api/deprecation-guide/

##### install Fluentd
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm install fluentd bitnami/fluentd


### Other useful commands

##### restart Fluentd deamonSet
    kubectl rollout restart daemonset/fluentd

##### restart elastic search statefulSet
    kubectl rollout restart statefulset/elasticsearch-master

##### install specific helm version
    helm install elasticsearch elastic/elasticsearch --version="7.9.0" -f values-linode.yaml
    helm install kibana elastic/kibana --version="7.9.0"
    helm install fluentd bitnami/fluentd --version="2.0.1"

    helm install nginx-ingress ingress-nginx/ingress-nginx --version="2.15.0"

##### install helm chart in a specific namespace (namespace must already exist)
    helm install elasticsearch elastic/elasticsearch -f values-linode.yaml -n elastic
