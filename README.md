# OpenNebula Docker Container

A Dockerized OpenNebula Front-End for easy deployment. This container allows users to quickly spin up an OpenNebula instance without manual installation.

## ✨ Features
- Preconfigured OpenNebula 6.10 with Sunstone, FireEdge, and OneGate.
- Secure non-root user (`oneadmin`) by default.
- Persistent storage support via Docker volumes.
- Health checks and CI/CD automation.

---

## 🚀 Quick Start

### Prerequisites
- Docker 20.10+ or Docker Compose v2.10+
- Ports `2633`, `9869`, `2474`, `29876`, `2616`, and `2222` available.

### Run with Docker
```bash
docker run -d \
    --name opennebula \
    -p 2633:2633 \
    -p 9869:9869 \
    -p 2474:2474 \
    -p 29876:29876 \
    -p 2616:2616 \
    -p 2222:22 \
    pablodelarco/opennebula-frontend:latest
```

### Run with Docker Compose
```bash
docker-compose up -d
```

---

## 🔧 Configuration

### Environment Variables
| Variable       | Default     | Description                      |
|---------------|------------|----------------------------------|
| ONEADMIN_PASS | opennebula | Password for `oneadmin` user.   |

### Volumes
| Volume Mount   | Purpose                              |
|---------------|--------------------------------------|
| /var/lib/one  | OpenNebula database and VMs data.   |

### Exposed Ports
| Port  | Service  | Protocol |
|-------|---------|----------|
| 2633  | Sunstone | HTTP     |
| 9869  | FireEdge | HTTP     |
| 2222  | SSH      | TCP      |

---

## 🛠 Development

### Build Locally
```bash
docker build -t opennebula-frontend:6.10 .
```

### Test Changes
```bash
docker-compose up --build
```

### Access Services
- **Sunstone Dashboard**: [http://localhost:2633](http://localhost:2633)
- **SSH Access**: `ssh oneadmin@localhost -p 2222` (password: `opennebula`)

---

## ⚙️ CI/CD Pipeline
This repo uses GitHub Actions to:
- Build and Test on every PR/push to `main`.
- Push to Docker Hub on merges to `main`.
- Semantic Versioning with tags (e.g., `v6.10.1`).

---

## 📜 License
MIT License. See [LICENSE](LICENSE).

---

## 🤝 Contributing
1. Fork the repo.
2. Create a feature branch:
   ```bash
   git checkout -b feat/amazing-feature
   ```
3. Commit changes:
   ```bash
   git commit -m 'Add amazing feature'
   ```
4. Push to the branch:
   ```bash
   git push origin feat/amazing-feature
   ```
5. Open a Pull Request.

---

## 🔗 Resources
- [OpenNebula Documentation](https://docs.opennebula.io)
- [Docker Hub Repository](https://hub.docker.com/r/pablodelarco/opennebula-frontend)

---

## **Key Files Explained**

### 1. `.dockerignore`
Prevents unnecessary files (like local logs or IDE configs) from being copied into the image:
```plaintext
.git
*/.
*.log
*.md
!scripts/entrypoint.sh
```

### 2. `docker-compose.yml`
Simplifies local testing with volume persistence and port mappings:
```yaml
version: '3.8'
services:
  opennebula:
    image: pablodelarco/opennebula-frontend:latest
    container_name: opennebula
    privileged: true
    ports:
      - "2633:2633"
      - "9869:9869"
      - "2616:2616"
      - "2474:2474"
      - "29876:29876"
      - "2222:22"
    volumes:
      - opennebula_data:/var/lib/one
volumes:
  opennebula_data:

```

### 3. `.github/workflows/ci-cd.yml`
Ensures automated testing and deployment.

---

## Final Notes
- Replace `your-dockerhub-username` with your actual Docker Hub username.
- Add OpenNebula configuration files to `configs/` if you need to customize `oned.conf` or `sunstone.conf`.
- Include a `LICENSE` file (e.g., MIT, Apache 2.0) in the repo root.
