# OpenNebula Frontend in Docker/Kubernetes

A containerized OpenNebula frontend with automated CI/CD pipeline and Helm chart support.

## Features

- 🐳 Docker container with OpenNebula 6.10
- ⚙️ Helm chart for Kubernetes deployment
- 🔄 CI/CD pipeline with vulnerability scanning
- ☁️ Production-ready Kubernetes configuration

## Deployment Options

### 1. Local Docker Deployment

```bash
# Build the image
docker build -t opennebula-frontend:latest .

# Run the container
docker run -d --privileged \
  -p 2633:2633 -p 9869:9869 \
  -p 2474:2474 -p 29876:29876 \
  -p 2616:2616 -p 2222:22 \
  opennebula-frontend:latest
```

### 2. Kubernetes Deployment with Helm

#### Prerequisites
- Kubernetes cluster (v1.23+)
- Helm (v3.12+)
- kubectl configured for your cluster

#### Deployment Steps

1. **Clone the repository**
```bash
git clone https://github.com/your-username/opennebula-docker.git
cd opennebula-docker
```

2. **Add Bitnami Helm repository**
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

3. **Deploy with Helm**
```bash
helm upgrade --install opennebula-frontend helm/ \
  --namespace opennebula \
  --create-namespace \
  --set image.repository=your-dockerhub-username/opennebula-frontend \
  --set image.tag=latest \
  --set postgresql.auth.password=your-secure-password
```

### 3. Production Configuration

**Custom values.yaml**
```yaml
# helm/prod-values.yaml
image:
  repository: your-registry/opennebula-frontend
  tag: latest

service:
  type: LoadBalancer
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: nlb

postgresql:
  auth:
    password: "secure-password"
  persistence:
    size: 20Gi

resources:
  limits:
    cpu: 2000m
    memory: 4Gi
```

**Deploy with custom values**
```bash
helm upgrade --install opennebula-frontend helm/ \
  -f helm/prod-values.yaml \
  --namespace production \
  --create-namespace
```

## Accessing Services

1. **Get external IP**
```bash
kubectl get svc opennebula-frontend-service -n opennebula
```

2. **Access Web UI**
```
http://<EXTERNAL-IP>:2633
```

3. **Port-forward for local access**
```bash
kubectl port-forward svc/opennebula-frontend-service 2633:2633 -n opennebula
```

## Configuration Options

Key Helm chart parameters:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Docker image repository | `docker.io/<your-username>/opennebula-frontend` |
| `image.tag` | Docker image tag | `latest` |
| `service.type` | Kubernetes service type | `LoadBalancer` |
| `postgresql.enabled` | Enable PostgreSQL subchart | `true` |
| `postgresql.auth.password` | PostgreSQL admin password | `oneadmin` |
| `resources.limits` | Resource limits | `2 CPU / 4GB RAM` |

View all options:
```bash
helm show values helm/
```

## Persistence

The Helm chart configures these persistent volumes:
- PostgreSQL data (50GB default)
- OpenNebula configuration files
- SSH keys storage

## Troubleshooting

**Check pod status**
```bash
kubectl get pods -n opennebula

kubectl logs -f opennebula-frontend-<pod-id> -n opennebula
```

**Uninstall**
```bash
helm uninstall opennebula-frontend -n opennebula
kubectl delete pvc -l app.kubernetes.io/instance=opennebula-frontend -n opennebula
```

## CI/CD Pipeline

This repository includes:
- 🛡️ Trivy vulnerability scanning
- ✅ Integration tests
- ☸️ Automatic Helm chart packaging
- 🔄 Docker Hub image publishing

Triggered on:
- Push to `main` branch
- Tag creation (semantic versioning)
- Pull requests

---

**Contributions welcome!** See [CONTRIBUTING.md](CONTRIBUTING.md) for details.