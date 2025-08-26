# **OpenNebula Frontend: Docker & Kubernetes Deployment 🚀**

A containerized **OpenNebula 6.10** frontend with **Helm support** and **automated CI/CD**.

## **Features**
✔️ **Dockerized** OpenNebula frontend  
☸️ **Helm chart** for Kubernetes deployment  
🛡️ **Security scanning** with CI/CD  
⚡ **Production-ready** Kubernetes setup  

---

## **🛠 Deployment Options**

### **1️⃣ Local Deployment with Docker**
```bash
# Build & Run
docker build -t opennebula-frontend:latest .
docker run -d --privileged -p 2633:2633 -p 9869:9869 \
  -p 2474:2474 -p 29876:29876 -p 2616:2616 -p 2222:22 \
  opennebula-frontend:latest
```

---

### **2️⃣ Kubernetes Deployment with Helm**
#### **Prerequisites**
- Kubernetes **v1.23+**, Helm **v3.12+**, `kubectl` configured

#### **Install Helm Chart**
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami && helm repo update
helm upgrade --install opennebula-frontend helm/ \
  --namespace opennebula --create-namespace \
  --set image.repository=pablodelarco/opennebula-frontend \
  --set image.tag=latest \
  --set postgresql.auth.password=your-secure-password
```

---

### **3️⃣ Production Setup**
Use **custom values.yaml**:
```yaml
image:
  repository: pablodelarco/opennebula-frontend
  tag: latest

service:
  type: LoadBalancer

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
Deploy with:
```bash
helm upgrade --install opennebula-frontend helm/ \
  -f helm/custom-values.yaml --namespace production --create-namespace
```

---

## **🔗 Accessing OpenNebula**
**Find External IP:**
```bash
kubectl get svc opennebula-frontend-service -n opennebula
```
**Access Web UI:**
```
http://<EXTERNAL-IP>:2616
```
**Local Port Forwarding:**
```bash
kubectl port-forward svc/opennebula-frontend-service 2616:2616 -n opennebula
```

---

## **⚙️ Helm Configuration**
| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Docker image repo | `docker.io/pablodelarco/opennebula-frontend` |
| `image.tag` | Image tag | `latest` |
| `service.type` | Kubernetes service type | `LoadBalancer` |
| `postgresql.enabled` | Deploy PostgreSQL | `true` |
| `postgresql.auth.password` | PostgreSQL password | `oneadmin` |
| `resources.limits` | CPU & RAM limits | `2 CPU / 4GB RAM` |

View all options:
```bash
helm show values helm/
```

---

## **🔍 Troubleshooting**
Check pod logs:
```bash
kubectl get pods -n opennebula
kubectl logs -f opennebula-frontend-<pod-id> -n opennebula
```
Uninstall OpenNebula:
```bash
helm uninstall opennebula-frontend -n opennebula
kubectl delete pvc -l app.kubernetes.io/instance=opennebula-frontend -n opennebula
```

---

## **🔄 CI/CD Pipeline**
- ✅ **Trivy security scanning**
- 🛠 **Automated Helm chart packaging**
- 🐳 **Docker Hub image publishing**
- ☸️ **Kubernetes deployment validation**

⏳ **Triggers**:
- Push to `main`
- Tag creation (semantic versioning)
- Pull requests

---

## **👥 Contributions**
We welcome contributions!  
See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

### **🚀 This README is now:**
✔️ **Shorter** & more concise  
✔️ **Easier to follow**  
✔️ **Retains all critical details**  
