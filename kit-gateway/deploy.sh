#!/bin/bash

../mo deployment.mo.yml | kubectl apply -f -
../mo service.mo.yml | kubectl apply -f -
../mo ingress.mo.yml | kubectl apply -f -