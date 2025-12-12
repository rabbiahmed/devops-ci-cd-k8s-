#!/usr/bin/env bash
set -e
ACCOUNT_ID=${AWS_ACCOUNT_ID:-YOUR_ACCOUNT_ID}
REGION=${AWS_REGION:-us-east-1}
REPO=${AWS_ECR_REPO:-devops-demo-app}
IMAGE=${1:-devops-demo-app:latest}

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

docker tag $IMAGE ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPO}:latest

docker push ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPO}:latest