#!/bin/bash

[[ $(kubectl get nodes -o name) != "node/minikubevm" ]] || { echo current target is minikube; exit 1; }

[[ -f production.env ]] || { echo production.env not found; exit 1; }
ln -s -f production.env .env

# namespace
./mo namespace.mo.yml | kubectl apply -f -

# kit-gateway
./mo kit-gateway/deployment.mo.yml | kubectl apply -f -
./mo kit-gateway/service.mo.yml | kubectl apply -f -
./mo kit-gateway/ingress.mo.yml | kubectl apply -f -

# kit-crud
./mo kit-crud/deployment.mo.yml | kubectl apply -f -
./mo kit-crud/service.mo.yml | kubectl apply -f -