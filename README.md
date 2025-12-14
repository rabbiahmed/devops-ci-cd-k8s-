# DevOps CI/CD Demo — Python Microservice

This project demonstrates a full CI/CD pipeline:

- Python microservice (FastAPI)
- Docker containerization
- Kubernetes deployment (k3d / k3s)
- CI: GitLab CI (build, test, push to registry)
- CD: Jenkins (deploy to Kubernetes)
- Provisioning: Ansible (Jenkins, k3s, app deployment)

## Prerequisites

- Ubuntu 22.04
- Git
- Python 3.10+ and pip
- Ansible 2.17+ (or installed via pip)
- Docker
- k3d (for local Kubernetes cluster)

## Setup Instructions

### 1. Clone the repository

```bash
git clone <repo-url>
cd devops-ci-cd-k8s
```

### 2. Run the full DevOps environment

This will provision Jenkins, k3s/k3d, and deploy the demo app.

```bash
make ansible
```

### 3. Docker Tasks

```bash
make docker-build     # Build app Docker image
make docker-run       # Run app container locally
make docker-push      # Push image to your registry
```

### 4. Kubernetes Tasks

```bash
make k8s-apply        # Apply manifests
make k8s-delete       # Delete manifests
```

Note: The demo app is exposed via NodePort 30080 in the cluster.
Use port-forwarding if NodePort is inaccessible:

```bash
kubectl port-forward svc/demo-app 8000:8000 -n default
```
Then access the app: http://localhost:8000

### 5. Clean Environment

```bash
make clean
```

- Stops Jenkins container
- Removes demo-app Docker image
- Deletes the k3d cluster

### Useful Notes

- The site.yml playbook is at the project root.
- The docker/Dockerfile and app source are in src/app/.
- Jenkins runs in a container and can be accessed at http://localhost:8090 (or the mapped port you chose).
- Local images are imported into k3d for fast deployment without pulling from DockerHub.

### References

See `/docs/architecture.md` for details.