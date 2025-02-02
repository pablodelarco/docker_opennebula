# OpenNebula Front-End on Docker

Welcome to the **OpenNebula Docker** repository! This project provides a streamlined way to build, run, and test an OpenNebula Front-End container so that anyone can quickly try OpenNebula without installing from source.

---

## Table of Contents

1. [Overview](#overview)  
2. [Repository Structure](#repository-structure)  
3. [Prerequisites](#prerequisites)  
4. [Build the Docker Image](#build-the-docker-image)  
5. [Run the Docker Container](#run-the-docker-container)  
6. [Exposed Ports](#exposed-ports)  
7. [CI/CD Pipeline](#cicd-pipeline)  
8. [Contributing](#contributing)  
9. [License](#license)  

---

## Overview

[OpenNebula](https://opennebula.io/) is a powerful open source platform for building and managing private, hybrid, and edge clouds. This repository provides:

- A **Dockerfile** to containerize OpenNebula’s Front-End (oned, Sunstone, FireEdge, OneFlow, OneGate, etc.).  
- A **CI/CD workflow** to automate building, testing, and publishing the Docker image.

---

## Repository Structure

```bash
.
├── .github/
│   └── workflows/
│       └── opennebula-ci.yml     # GitHub Actions workflow
├── Dockerfile                    # Dockerfile for building the OpenNebula Front-End image
├── README.md                     # Project documentation
└── .gitignore                    # Optional .gitignore file
