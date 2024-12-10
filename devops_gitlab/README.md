# DevOps Project for Trinity
## Overview
This project involves setting up a **DevOps pipeline** for a full-stack application using **Spring Boot** (Backend), **Angular** (Frontend), **PostgreSQL** (Database), **Nginx** (Reverse Proxy), **Docker**, **GitLab CI/CD**, and **Google Cloud**.  
This guide will help you set up the project locally and deploy it on Google Cloud with CI/CD integration.

---

## Project Structure

```
|── devcontainer
│   ├── devocontainer.json
├── backend
│   ├── Dockerfile.zero
|   |── Dockerfile.dev
│   └── src/
├── frontend
│   ├── Dockerfile.zero
|   |── Dockerfile.dev
│   └── src/
├── nginx
│   ├── default.conf
|   |── default.dev.conf
|── .env
|── .gitlab-ci.yml
├── docker-compose.dev.yml
├── deploy.sh
|── .gitignore
|
└── README.md

```

---

## Technologies and Architecture

### **Backend: Spring Boot**  
- **Spring Boot** is used for building the backend API.  
- **Dockerized** for environment consistency.  

### **Frontend: Angular**  
- **Angular** is used for building the dynamic frontend.  
- **Dockerized** for easy deployment.  

### **Database: PostgreSQL**  
- **PostgreSQL** is the relational database for storing application data.  
- **Dockerized** for consistency across all environments.  

### **Reverse Proxy: Nginx**  
- **Nginx** is used as a reverse proxy to route traffic between the frontend and backend.  

### **CI/CD: GitLab CI/CD**  
- **GitLab CI/CD** automates the build, test, and deployment pipelines.  

### **Containerization: Docker**  
- **Docker** is used to containerize both frontend and backend for consistency between environments.  

---

## Differences Between Development and Production Configurations

### **Development Configuration**
- **Backend**: Uses `spring-boot:run` with live-reload enabled.
- **Frontend**: Uses Node.js for serving the app with hot-reload functionality.
- **PostgreSQL**: Running locally with default configurations.
- **Nginx**: Serves as a basic proxy for development purposes.

### **Production Configuration**
- **Backend**: Uses a multi-stage Docker build for creating an optimized JAR file.
- **Frontend**: Angular app is built into static files and served by Nginx.
- **PostgreSQL**: Running in a production-ready configuration with optimized performance.
- **Nginx**: Configured to handle HTTPS and production routing.

# when you develop on Java, you can use the following command to run the container
```
CMD ["mvn", "spring-boot:run"]
```

# when you develop on Frontend, you can use the following command to run the container
```
ENTRYPOINT [ "tail", "-f", "/dev/null" ]
```

---

## CI/CD Pipeline Architecture

The CI/CD pipeline involves automating the following steps:

1. **Trigger**: Code pushed to the GitLab repository.
2. **Build**: Docker images for the frontend and backend are built.
3. **Test**: Unit tests for both backend and frontend are executed.
4. **Deploy**: The built Docker images are pushed to a registry and deployed to a Google Cloud VM using SSH.

[CI/CD Pipeline Diagram]

---

## Instructions for GitLab Runner Setup

### **Step 1: Install GitLab Runner on Google Cloud VM**
1. Install GitLab Runner
a. Download the GitLab Runner .deb package:
```
curl -L --output /tmp/gitlab-runner.deb https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb
```
b. Install the package using dpkg:
```
sudo dpkg -i /tmp/gitlab-runner.deb
```

2. Verify the Installation
Check if the GitLab Runner is installed correctly:
```
gitlab-runner --version
```
### **Step 2: Register GitLab Runner**

1. After installation, register the GitLab Runner using the following command:
   ```
   sudo gitlab-runner register
   ```
2. During the registration, you will need to enter:
   - **GitLab Instance URL**: The URL of your GitLab instance (`https://t-dev.epitest.eu`).
   - **Registration Token**: Available in the GitLab project’s settings under CI/CD.
   - **Description**: A description of your runner (`Google Cloud VM Runner, dev docker...`).
   - **Tags**: Optional tags to identify the runner (`trinity`).
   - **Executor**: Choose `docker` for this setup.

3. Ensure that your GitLab Runner configuration is correct and the runner is running:
   ```
   sudo gitlab-runner verify
   ```
---

## Local Setup Instructions

1. **Install Docker**: Follow the official guide to install Docker.
2. **Install Docker Compose**: For managing multi-container applications.
3. **Clone the Repository**:
   ```
   git clone https://t-dev.epitest.eu/PAR_22/T-DEV-701-Devops.git
   cd T-DEV-701-DEVOPS
   ```
4. **Build & Start the Docker Containers**:
   ```
   docker-compose -f docker-compose.dev.yml up --build
   ```
5. **Access the Application**:
   - Frontend: `http://localhost:4200/` and because of Nginx you can acess it on: `http://localhost`
   - Backend: `http://localhost:8080`
---

## Deployment with GitLab CI/CD on Google Cloud Platform (GCP)

### **Step 1: Create a Google Cloud VM Instance**

1. **Create a VM instance**:
   - Navigate to the **Google Cloud Console**.
   - Go to **Compute Engine** and click on **Create Instance**.
   - Choose a **Linux-based** image (**Ubuntu**).
   - Select the **machine type** based on your needs.
   - Under **Firewall**, check **Allow HTTP traffic** and **Allow HTTPS traffic**.
   - Click **Create** to launch the VM instance.

2. **Open necessary ports**:
   - Make sure ports `80` (HTTP), `443` (HTTPS), and `8080` (backend) are open in your Google Cloud firewall settings. 
   - This allows your application to be accessed via the web.
---

### **Step 2: Set Up GitLab CI/CD Pipeline**

1. **Set up `.gitlab-ci.yml` for pipeline**:
   In the root of your repository, create a `.gitlab-ci.yml` file to define the CI/CD pipeline. (stages: build, test, deploy)

2. **SSH Key Setup**:
   - Add the **private SSH key** to your GitLab repository’s CI/CD settings. Go to **Settings** > **CI / CD** > **Variables** and add the private key (e.g., `CI_SSH_PRIVATE_KEY`).
   - Ensure you have the corresponding **public SSH key** added to the **VM instance** for access.

3. **Deploy to Google Cloud VM**:
   - After the GitLab Runner finishes the **build** and **test** stages, the **deploy** stage will SSH into the VM.
   - It will run `docker-compose up -d` to deploy your containers to the Google Cloud VM.

---

### **Step 3: Configure Google Cloud for SSH Access**

1. **Generate SSH Key Pair (if not already done)**:
   - On your local machine (or the machine used for GitLab CI/CD), generate an SSH key pair:
     ```bash
     ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
     ```
   - Add the **public key** to the **Google Cloud VM** instance’s metadata:
     - Go to **VM Instances** in the Google Cloud Console.
     - Click on your VM, then go to the **Metadata** section and add the SSH public key to the **SSH Keys** tab.

2. **Configure SSH in your .ssh/config**:
   - Store the **private SSH key** 
   - Use this key to SSH into the GCP VM during the pipeline.


## Conclusion

This guide outlines the steps required to deploy a full-stack application with Docker and Google Cloud Platform, integrating a GitLab CI/CD pipeline for automation. With this setup, you can easily deploy your application to the cloud, run tests, and ensure your app is continuously integrated and deployed.


## Contact

**Maia Bazerji**  
Email: maia.bazerji@epitech.eu

**Fatimatou Zahra Tall**  
Email: fatimatou-zahra.tall@epitech.eu

**Rayane Siphax Ziouane**  
Email: rayane-siphax.ziouane@epitech.eu

**Fakher Karouida**  
Email: fakher.karouida@epitech.eu