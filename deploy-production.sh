#!/bin/bash

[[ $(kubectl get nodes -o name) != "node/minikubevm" ]] || { echo current target is minikube; exit 1; }

./env.sh production

# Namespace
./mo namespace.mo.yml | kubectl apply -f -

# App
(cd kit-gateway; ./deploy.sh)
(cd kit-crud; ./deploy.sh)