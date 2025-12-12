# DevOps CI/CD Demo — Python Microservice

This project demonstrates a full CI/CD pipeline:

- Python microservice (FastAPI)
- Docker containerization
- Kubernetes deployment (k3d / k3s)
- CI: GitLab CI (build, test, push to ECR)
- CD: Jenkins (deploy to k8s)
- Provisioning: Ansible (Jenkins, k3s)

## Prerequisites

- Ubuntu 22.04
- Git
- Python 3.10+ and pip
- Ansible 2.17+ (or installed via pip)
- Docker

## Setup Instructions

### 1. Clone the repository

```bash
git clone <repo-url>
cd devops-ci-cd-k8s
```

### 2. Run the full DevOps environment

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

### 5. Clean Environment

```bash
make clean
```

See `/docs/architecture.md` for details.