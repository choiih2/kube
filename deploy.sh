#!/bin/bash

# Capston Kubernetes Deployment Script
# This script deploys the web application fuzzing project to Kubernetes

set -e

echo "================================="
echo "Capston Kubernetes Deployment"
echo "================================="
echo ""

echo "[1/6] Creating Secrets..."
kubectl apply -f k8s/secrets/mysql-secret.yaml

echo "[2/6] Creating ConfigMaps..."
kubectl apply -f k8s/configmaps/mysql-init-configmap.yaml

echo "[3/6] Creating Storage..."
kubectl apply -f k8s/storage/mysql-pvc.yaml
kubectl apply -f k8s/storage/fuzzer-pvc.yaml

echo "[4/6] Deploying Database..."
kubectl apply -f k8s/database/mysql-statefulset.yaml
kubectl apply -f k8s/database/mysql-service.yaml


echo "[5/6] Deploying Web Application..."
kubectl apply -f k8s/web/web-deployment.yaml
kubectl apply -f k8s/web/web-service.yaml


echo "[6/6] Starting Fuzzer Job..."
kubectl apply -f k8s/fuzzer/fuzzer-job-xss.yaml
kubectl apply -f k8s/fuzzer/fuzzer-job-sqli.yaml

echo ""
echo "================================="
echo "Deployment Complete!"
echo "================================="
echo ""
