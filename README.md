# OpenNebula Docker Container

A Dockerized OpenNebula Front-End for easy deployment. This container allows users to quickly spin up an OpenNebula instance without manual installation.

## ✨ Features
- Preconfigured OpenNebula 6.10 with Sunstone, FireEdge, and OneGate
- Secure non-root user (`oneadmin`) by default
- Persistent storage support via Docker volumes
- Health checks and CI/CD automation
- Security scanning with Trivy

## 🚀 Quick Start

### Prerequisites
- Docker 20.10+ or Docker Compose v2.10+
- Ports `2633`, `9869`, `2474`, `29876`, `2616`, and `2222` available

### Run with Docker

```bash
docker run -d \
  --name opennebula \
  --privileged \
  -p 2633:2633 \
  -p 9869:9869 \
  -p 2474:2474 \
  -p 29876:29876 \
  -p 2616:2616 \
  -p 2222:22 \
  pablodelarco/opennebula-frontend:latest
```

### Default Credentials
- **Username:** `oneadmin`
- **Password:** `oneadmin`

### Exposed Ports

| Port   | Service    | Description           |
|--------|------------|-----------------------|
| 2633   | XML-RPC   | OpenNebula Core API   |
| 9869   | Sunstone  | Web UI                 |
| 2474   | OneGate   | VM Contextualization   |
| 29876  | OneFlow   | Service Management     |
| 2616   | FireEdge  | Modern Web UI          |
| 2222   | SSH       | Remote Access          |

## 🔧 Development

### Build Locally

```bash
docker build -t opennebula-frontend:latest .
```

### Access Services
- **Sunstone Dashboard:** [http://localhost:9869](http://localhost:9869)
- **FireEdge UI:** [http://localhost:2616](http://localhost:2616)
- **SSH Access:** `ssh -p 2222 oneadmin@localhost`

## ⚙️ CI/CD Pipeline
Automated workflow includes:
- Security scanning with Trivy
- Integration testing
- Automated builds and pushes to Docker Hub
- Version tagging support

## 🤝 Contributing
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🐜 License
MIT License. See [LICENSE](LICENSE).

## 🔗 Resources
- 📚 [OpenNebula Documentation](https://docs.opennebula.io)
- 🐳 [Docker Hub Repository](https://hub.docker.com/r/pablodelarco/opennebula-frontend)
