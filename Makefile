# ---------------------------------------------
# Makefile for DevOps CI/CD Scaffold
# ---------------------------------------------

APP_NAME := demo-app
IMG := $(APP_NAME):latest
ANSIBLE_PLAYBOOK := infra/ansible/site.yml
INVENTORY := infra/ansible/inventory.ini

.PHONY: docker-build docker-run docker-push k8s-apply k8s-delete ansible clean

# -------------------------------
# Docker tasks
# -------------------------------

docker-build:
	docker build -t $(IMG) .

docker-run:
	docker run -p 8000:8000 $(IMG)

docker-push:
	docker tag $(IMG) <your-ecr-uri>/$(IMG)
	docker push <your-ecr-uri>/$(IMG)

# -------------------------------
# Kubernetes tasks
# -------------------------------

k8s-apply:
	kubectl apply -f k8s/

k8s-delete:
	kubectl delete -f k8s/

# -------------------------------
# Ansible tasks
# -------------------------------

ansible:
	ansible-playbook -i $(INVENTORY) $(ANSIBLE_PLAYBOOK) --ask-become-pass

# -------------------------------
# Clean environment (optional)
# -------------------------------

clean:
	docker rm -f jenkins || true
	docker rmi -f $(IMG) || true
	k3d cluster delete dev-cluster || true
