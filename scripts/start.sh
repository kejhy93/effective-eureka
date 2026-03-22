#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
K8S_DIR="$SCRIPT_DIR/../k8s"
PROJECT_DIR="$SCRIPT_DIR/.."

echo "==> Starting minikube..."
minikube start

echo "==> Building Docker image inside minikube..."
minikube image build -t spring-test:latest "$PROJECT_DIR"

echo "==> Deploying dependencies..."
kubectl apply -f "$K8S_DIR/postgres.yml"
kubectl apply -f "$K8S_DIR/kafka.yml"

echo "==> Waiting for postgres to be ready..."
kubectl rollout status deployment/postgres --timeout=120s

echo "==> Waiting for kafka to be ready..."
kubectl rollout status deployment/kafka --timeout=120s

echo "==> Deploying spring-test..."
kubectl apply -f "$K8S_DIR/app.yml"

echo "==> Waiting for spring-test to be ready..."
kubectl rollout status deployment/spring-test --timeout=120s

echo ""
echo "==> All services are up."
echo "    Postgres:    postgres:5432 (internal)"
echo "    Kafka:       kafka:9092 (internal)"
echo "    spring-test: $(minikube service spring-test --url)"
