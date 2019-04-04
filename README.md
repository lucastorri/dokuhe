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

## Run Using Helm

> Helm automatically maintains a versioned history of your releases. If
> something goes wrong with a deployment, getting back to your previous state
> can be as simple as `helm rollback RELEASE_NAME`.

```bash
TEMPLATES_HOME='/Users/lucastorri/Projects/k8s-services/helm'

helmut() {
  local action="$1"
  local service
  local env
  IFS=':' read -r service env <<< "$2"
  shift 2

  local args=("helm")

  cd "$TEMPLATES_HOME"

  case "$action" in
  "render")
    args+=(upgrade "$service" "$service" --dry-run --install --debug --force)
    ;;
  "deploy")
    args+=(upgrade "$service" "$service" --install --atomic)
    ;;
  "purge-all")
    helm list --output json | jq '.Releases[] | .Name' -r | xargs helm delete --purge
    return 0
    ;;
  *)
    >&2 echo "Invalid action $action"
    return 1
    ;;
  esac

  if [ ! -z "$env" ]; then
    args+=(-f "$service/$env.values.yaml")
  fi

  "${args[@]}" "$@"
}

helmut deploy hello:dev \
  --set config.salutation='Hello there'

helmut deploy page:dev \
  --set config.lang='en'

helmut deploy hello-page:dev \
  --set config.helloServiceUrl='http://hello' \
  --set config.pageServiceUrl='http://page'

helmut deploy ingress \
  --set target.service='hello-page'

helmut purge-all
```

## Tools

### Debug Pod

```bash
kubectl run -it --image=busybox --rm busybox -- sh
```

## References

- [How To Create Your First Helm Chart](https://docs.bitnami.com/kubernetes/how-to/create-your-first-helm-chart/)
- [Kubernetes NodePort vs LoadBalancer vs Ingress? When should I use what?](https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0)
- [Helm Chart Hooks](https://github.com/helm/helm/blob/master/docs/charts_hooks.md)
- [Kubernetes Debug Services](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service/)
