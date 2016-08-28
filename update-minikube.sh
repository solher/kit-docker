#!/bin/bash

scriptPath=$(cd $(dirname $0); pwd)
currentDir=$(basename $(pwd))

[[ $(kubectl get nodes -o name) == "node/minikubevm" ]] || { echo current target is not minikube; exit 1; }

[[ -f $scriptPath/minikube.env ]] || { echo minikube.env not found; exit 1; }
ln -s -f $scriptPath/minikube.env $scriptPath/.env

echo "Compiling $currentDir"
GOGC=off GOOS=linux GOARCH=amd64 go build -i -v

echo "Building $currentDir Docker image"
docker build -t minikube/$currentDir:latest .

echo "Deploying $currentDir to minikube"
(
    export $(cat $scriptPath/minikube.env)
    kubectl --namespace=$ENVIRONMENT patch deployment $currentDir -p \
    '{"spec":{"template":{"spec":{"containers":[{"name":"'$currentDir'","image":"minikube/'$currentDir':latest","imagePullPolicy":"Never"}]}}}}'
)