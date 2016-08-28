#!/bin/bash

[[ $(kubectl get nodes -o name) == "node/minikubevm" ]] || { echo current target is not minikube; exit 1; }

[[ -f minikube.env ]] || { echo minikube.env not found; exit 1; }
ln -s -f minikube.env .env

# Setup GCR
kubectl patch serviceaccounts default -p '{"imagePullSecrets":[{"name":"gcr"}]}'
kubectl delete secret gcr
kubectl create secret docker-registry gcr \
--docker-server=https://eu.gcr.io \
--docker-username=_json_key \
--docker-password="$(cat deploy-key.json)" \
--docker-email=foo@bar.com

# kit-gateway
./mo kit-gateway/deployment.mo.yml | kubectl apply -f -
./mo kit-gateway/service.mo.yml | kubectl apply -f -
./mo kit-gateway/ingress.mo.yml | kubectl apply -f -

# kit-crud
./mo kit-crud/deployment.mo.yml | kubectl apply -f -
./mo kit-crud/service.mo.yml | kubectl apply -f -