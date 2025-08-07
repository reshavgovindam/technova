# 🚀 TechNova - DevOps Project Pipeline (Terraform + Jenkins + Docker)

TechNova is a fully automated, production-grade DevOps pipeline project designed to showcase end-to-end CI/CD (Continuous Integration and Continuous Deployment) using modern DevOps tools and best practices.

---

## 📁 Project Structure

```bash
technova/
│
├── Dockerfile
├── main.tf
├── variables.tf
├
├── Jenkins file
│   
├──package.json           
├──index.js
│   
└─ README.md
└─ .gitignore


```

## 📊 Architecture Diagram


```bash
Developer --> GitHub --> Jenkins --> Terraform --> AWS EC2
                                   |
                              Docker Image
                                   ↓
                             Deployed Web App
```
---

## 🌐 GitHub Repository

> 🔗 [https://github.com/reshavgovindam/technovaaa](https://github.com/reshavgovindam/technova)

---

## 🛠️ Tech Stack

| Tool        | Purpose                            |
|-------------|-------------------------------------|
| Terraform   | Provision AWS infrastructure        |
| AWS EC2     | Host Jenkins and your app           |
| Jenkins     | Automate CI/CD pipeline             |
| Docker      | Containerize and deploy app         |
|  GitHub     | Version control & repo hosting      | 


---
## ⚠️ Prerequisites

⚙️ Prerequisites
Before running this project, ensure the following tools, software, and cloud infrastructure are ready and properly configured:

✅ Accounts & Cloud Infrastructure
Requirement Description
AWS Account	Must have programmatic access enabled (IAM credentials for AWS CLI)
Ubuntu EC2 Instance	Deployed via Terraform or manually on AWS
Security Group Inbound Rules	- Port 5000: Access the deployed web application
- Port 8080: (Optional) Jenkins Web UI
- Port 22: SSH access for manual setup or troubleshooting

✅ Required Software
Install the following tools either locally (for testing) or on the EC2 instance (for CI/CD pipeline operations):


Docker	>= 20.10	Required to build and run the containerized application
Terraform	>= 1.0.0	Used to provision AWS infrastructure via Infrastructure as Code
Jenkins	Any LTS	Install on EC2 or any host; used for CI/CD pipeline automation
AWS CLI	Latest	Configure with your IAM credentials for infrastructure provisioning
Node.js	Optional	Needed only if your application (frontend/backend) is Node-based

---
## 🛠️ CI/CD Pipeline Overview

### Jenkins Pipeline Stages:

1. **Clone Repository**  
   Clones project from GitHub

2. **Build Docker Image**  
   Builds app image using `Dockerfile`

3. **Terraform Init/Plan/Apply**  
   Provisions EC2 and networking resources

4. **Deploy Docker Container**  
   Runs container on EC2
---
### 🔠 Website Files

The  website is placed under:

```bash
├── main
 ├── index.js
 ├── package-lock.json
 └── package.json
```
---
## 🔧 Setup Instructions

### 1. 📦 Terraform Infrastructure Provisioning

Initialize and apply Terraform:

```bash
INITIALIZE TERRAFORM
terraform init
CREATE AN EXECUTION PLAN(SAVES A FILE NAMED tfplan)
terraform plan -out tfplan
APPLY CHANGES TO THE FILE
terraform apply tfplan
```
### ⚖ Terraform Configuration

Terraform files are in main/main.tf/ and main/variable.tf
```bash
├── main
 ├── main.tf
 ├── variable.tf
```

#### Resources Created:

* *VPC*
* *Subnet* (Private and/or Public)
* *Internet Gateway*
* *Route Table*
* *Security Group* (allowing port 22 and 5000)
* *EC2 Instance* (Ubuntu-based)

#### Terraform Commands Used:
```bash

terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan


```
---
### 🚀 Docker Image Creation

To create the Docker image:

1. Write your Dockerfile (in main/Dockerfile).
 ```bash
main/
│
├── Dockerfile
```

3. Build the image:

   ```bash

   docker build -t my-node-app
   
4. Run the container:

   ```bash

   docker run -d -p 5000:5000 my-node-app
---




### 📈 Jenkins Pipeline Overview

The Jenkins pipeline is defined in main/Jenkinsfile.
```bash
main/
│
├── Jenkinsfile
```
#### Pipeline Stages:

1. *Init* - Initialize Terraform backend
2. *Validate* - Terraform validation
3. *Plan* - Infrastructure planning
4. *Approval* - Manual approval before applying
5. *Apply* - Provision EC2 via Terraform
6. *SSH EC2* - SSH into instance to prepare environment
7. *Docker Build* - Build Docker image
8. *Docker Run* - Run image with exposed port 5000

---
📷 Jenkins Pipeline Screenshots

* Init Stage:
   

* Validate Stage:

  

* Plan Stage:

  

* Apply Stage:

  

* SSH & Docker Deployment:

  

---








### 2. 🔑 Connect to EC2 & Install Jenkins

SSH into your EC2 instance:

```bash
ssh -i technova_key.pem ec2-user@your-ec2-public-ip
```

Install Jenkins using the following:

```bash
sudo yum update -y
sudo yum install java-11-openjdk -y
wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins
```




---

### 🚩 Deployed Output

Access your deployed website at:

[visit this website](http://13.61.18.99:5000)


---
### 📸 Final Deployment Screenshot

![SUCCESS](https://github.com/user-attachments/assets/20671e7f-66a4-4cab-9116-74892ae4a7fd)








---

## 🔮 Future Improvements

- ✅ Slack / Webhook Notifications  
- ✅ Monitoring with Prometheus & Grafana  
- ✅ Push Docker images to DockerHub or ECR  
- ✅ Load Balancer & Auto Scaling via Terraform  
- ✅ Add Unit Testing & Code Coverage



---














