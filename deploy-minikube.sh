#!/bin/bash

[[ $(kubectl get nodes -o name) == "node/minikubevm" ]] || { echo current target is not minikube; exit 1; }

./env.sh minikube

# Setup GCR
kubectl patch serviceaccounts default -p '{"imagePullSecrets":[{"name":"gcr"}]}'
kubectl delete secret gcr
kubectl create secret docker-registry gcr \
--docker-server=https://eu.gcr.io \
--docker-username=_json_key \
--docker-password="$(cat deploy-key.json)" \
--docker-email=foo@bar.com

# App
(cd kit-gateway; ./deploy.sh)
(cd kit-crud; ./deploy.sh)