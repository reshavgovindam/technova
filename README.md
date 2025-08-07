# 🚀 TechNova - DevOps Project Pipeline (Terraform + Jenkins + Docker)

Welcome to **TechNova**, a professional DevOps pipeline project demonstrating a full CI/CD automation using:

- ✅ Terraform for infrastructure provisioning
- ✅ AWS EC2 for hosting
- ✅ Jenkins for CI/CD
- ✅ Docker for containerization
- ✅ GitHub for version control

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

✅ Accounts & Infrastructure
AWS Account (with programmatic access enabled)

Ubuntu EC2 Instance

Inbound rule allowing port 5000 (for website access)

Optional: Allow port 8080 (for Jenkins), and port 22 (for SSH)

✅ Required Software (Installed on Local or EC2)
Tool	Version	Notes
Docker	>= 20.10	Required to build and run containerized web app
Node.js	Optional	Only if your static site or app needs Node
Terraform	>= 1.0.0	For provisioning AWS infrastructure
Jenkins	Any stable LTS	Installed on EC2 or accessible environment
AWS CLI	Latest	Must be configured with IAM credentials

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
├── website/
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
technova/
│
├── Dockerfile
```

3. Build the image:

   ```bash

   docker build -t technonova-image.
   
4. Run the container:

   ```bash

   docker run -d -p 5000:5000 technonovaa-image
---




### 📈 Jenkins Pipeline Overview

The Jenkins pipeline is defined in main/Jenkinsfile.

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
ssh -i your-key.pem ec2-user@your-ec2-public-ip
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

✅ Slack / Webhook Notifications
✅ Monitoring with Prometheus & Grafana
✅ Push Docker images to DockerHub/ECR
✅ Load Balancer & Auto Scaling via Terraform
✅ Add Unit Testing & Code Coverage


---














