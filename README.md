
## Minikube

```bash
minikube start --vm-driver=hyperkit

minikube dashboard
```

## Run Using Docker

```bash
./docker-build-all.sh

docker run -it -e LANG=en -p 9000:9000 page-service

docker run -it -e SALUTATION=Dear -p 8000:8000 hello-service

docker run -it -e HELLO_SERVICE_URL=http://192.168.108.93:8000 -e PAGES_SERVICE_URL=http://192.168.108.93:9000 -p 7000:7000 hello-page-service
```

## Run Using Kubernetes

```bash
# Push Docker images to the _minikube_ registry
eval $(minikube docker-env)
./docker-build-all.sh

# Create kubernetes resources
cd kubernetes
kubectl create -f .

# call the service (must wait for the ingress to be ready)
ingress_address=`kubectl get ingress -o json | jq -r .items[0].status.loadBalancer.ingress[0].ip`
curl -k "https://$ingress_address/"

# Delete resources
kubectl delete -f .
```
