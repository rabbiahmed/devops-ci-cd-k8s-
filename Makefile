# ----------------------------------------------------
# Makefile for DevOps CI/CD K8s Scaffold
# ----------------------------------------------------

# -------- Variables ---------------------------------
APP_NAME        := demo-app
IMG             := $(APP_NAME):latest

ROOT_DIR        := $(CURDIR)
DOCKER_DIR      := $(ROOT_DIR)/docker
K8S_DIR         := $(ROOT_DIR)/k8s
INVENTORY       := infra/ansible/inventory.ini
PLAYBOOK        := site.yml

NODEPORT        := 30080   # NodePort mapped for demo-app service

# Uncomment and set your real ECR or DockerHub repository
# REGISTRY       := <your-ecr-or-dockerhub-uri>

# -------- Phony Targets ------------------------------
.PHONY: docker-build docker-run docker-push \
        k8s-apply k8s-delete ansible clean

# -----------------------------------------------------
# Docker tasks
# -----------------------------------------------------

docker-build:
	@echo "▶ Building Docker image: $(IMG)"
	docker build -t $(IMG) $(DOCKER_DIR)

docker-run:
	@echo "▶ Running Docker container on port 8000"
	docker run -p 8000:8000 $(IMG)

docker-push:
ifndef REGISTRY
	$(error REGISTRY is not set. Edit the Makefile and set REGISTRY=<repo-url>)
endif
	@echo "▶ Pushing Docker image to $(REGISTRY)"
	docker tag $(IMG) $(REGISTRY)/$(IMG)
	docker push $(REGISTRY)/$(IMG)

# -----------------------------------------------------
# Kubernetes tasks
# -----------------------------------------------------

k8s-apply:
	@echo "▶ Applying Kubernetes manifests from $(K8S_DIR)"
	kubectl apply -f $(K8S_DIR)
	@echo "▶ If using NodePort, your app is available at http://localhost:$(NODEPORT)"

k8s-delete:
	@echo "▶ Deleting Kubernetes resources from $(K8S_DIR)"
	kubectl delete -f $(K8S_DIR)

# -----------------------------------------------------
# Ansible tasks
# -----------------------------------------------------

ansible:
	@echo "▶ Running Ansible playbook: $(PLAYBOOK)"
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK) --ask-become-pass

# -----------------------------------------------------
# Cleanup tasks
# -----------------------------------------------------

clean:
	@echo "▶ Cleaning Docker, Jenkins and k3d resources"
	-docker rm -f jenkins 2>/dev/null || true
	-docker rmi -f $(IMG) 2>/dev/null || true
	-k3d cluster delete dev-cluster 2>/dev/null || true
	@echo "✔ Cleanup complete"
