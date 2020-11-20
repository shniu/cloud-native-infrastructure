#!/bin/bash

minikube kubectl -- delete deployment,svc mysql
minikube kubectl -- delete pvc mysql-pv-claim
minikube kubectl -- delete pv mysql-pv-volume