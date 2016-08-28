#!/bin/bash

currentDir=$(basename $(pwd))

echo "Compiling $currentDir"
GOGC=off GOOS=linux GOARCH=amd64 go build -i -v

echo "Building $currentDir Docker image"
[[ $(docker info | sed -n 's/^Name: *//p') == "minikubeVM" ]] || eval $(minikube docker-env) 
docker build -t minikube/$currentDir:latest .

echo "Deploying $currentDir to minikube"
[[ $(kubectl get nodes -o name) == "node/minikubevm" ]] || kubectl config use-context minikube
kubectl --namespace=default patch deployment $currentDir -p \
'{"spec":{"template":{"spec":{"containers":[{"name":"'$currentDir'","image":"minikube/'$currentDir':latest","imagePullPolicy":"Never"}]}}}}'