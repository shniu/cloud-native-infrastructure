#!/bin/bash

minikube kubectl -- delete deployment,svc redis
minikube kubectl -- delete pvc redis-pv-claim
minikube kubectl -- delete pv redis-pv-volume