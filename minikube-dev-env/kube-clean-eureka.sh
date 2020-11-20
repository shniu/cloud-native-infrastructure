#!/bin/bash

minikube kubectl -- delete svc eureka-np
minikube kubectl -- delete svc eureka
minikube kubectl -- delete statefulset eureka
minikube kubectl -- delete configmap eureka-cm