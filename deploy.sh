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
kubectl delete configmap mysql-init-config --ignore-not-found
kubectl create configmap mysql-init-config --from-file=init.sql=db/init.sql

echo "[3/6] Creating Storage..."
kubectl apply -f k8s/storage/mysql-pvc.yaml
kubectl apply -f k8s/storage/fuzzer-pvc.yaml


echo "[4/6] Deploying Database..."
kubectl apply -f k8s/database/mysql-statefulset.yaml
kubectl apply -f k8s/database/mysql-service.yaml
echo "⏳ Waiting for MySQL to be ready..."
kubectl wait --for=condition=ready pod/mysql-0 --timeout=280s
echo "⏳ Waiting for MySQL to accept connections..."
until kubectl exec mysql-0 -- \
  mysql -uroot -prootpassword -e "SELECT 1;" >/dev/null 2>&1; do
  echo "  MySQL not ready yet, retrying..."
  sleep 3
done
echo "✅ MySQL is accepting connections"


echo "[5/6] Deploying Web Application..."
kubectl apply -f k8s/web/web-deployment.yaml
kubectl apply -f k8s/web/web-service.yaml
echo "⏳ Waiting for Web pods to be ready..."
kubectl wait --for=condition=ready pod -l app=web-app --timeout=220s

echo "📊 Checking service endpoints..."
kubectl get endpoints mysql-service
kubectl get endpoints web-service
echo ""


echo "[6/6] Starting Fuzzer Job..."
kubectl apply -f k8s/fuzzer/fuzzer-job.yaml

echo ""
echo "================================="
echo "Deployment Complete!"
echo "================================="
echo ""
