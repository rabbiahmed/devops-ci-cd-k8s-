#!/usr/bin/env bash
set -euo pipefail

APP_LABEL="demo-app"
K8S_DIR="./k8s"
NAMESPACE="default"
NODE_PORT=30080

echo "▶ Applying updated Kubernetes manifests..."
kubectl apply -f "$K8S_DIR/deployment.yaml"
kubectl apply -f "$K8S_DIR/service.yaml"

echo "▶ Deleting old pods to trigger rollout..."
kubectl delete pod -l app=$APP_LABEL -n $NAMESPACE || true

echo "▶ Waiting for pod to become ready..."
kubectl wait --for=condition=Ready pod -l app=$APP_LABEL -n $NAMESPACE --timeout=120s

echo "▶ Pods are ready:"
kubectl get pods -l app=$APP_LABEL -n $NAMESPACE

SERVICE_IP=$(kubectl get svc $APP_LABEL -n $NAMESPACE -o jsonpath='{.spec.clusterIP}')
echo "▶ Service '$APP_LABEL' is available on ClusterIP: $SERVICE_IP and NodePort: $NODE_PORT"
echo "▶ You can now access the app on your browser at: http://localhost:$NODE_PORT"