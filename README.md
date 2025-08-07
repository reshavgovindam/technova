# 🚀 TechNova - DevOps Project Pipeline (Terraform + Jenkins + Docker)

Welcome to **TechNova**, a professional DevOps pipeline project demonstrating a full CI/CD automation using:

- ✅ Terraform for infrastructure provisioning
- ✅ AWS EC2 for hosting
- ✅ Jenkins for CI/CD
- ✅ Docker for containerization
- ✅ GitHub for version control
- ✅ Trivy for image vulnerability scanning

---

## 📁 Project Structure

```bash
technovaaa/
│
├── Dockerfile
├── main.tf
├── variables.tf
├── outputs.tf
├── jenkins/
│   └── Jenkinsfile
├── app/              # Your Node.js or Python app
│   ├── index.js
│   └── package.json
└── README.md
```

---

## 🌐 GitHub Repository

> 🔗 [https://github.com/reshavgovindam/technovaaa](https://github.com/reshavgovindam/technovaaa)

---

## 🛠️ Tech Stack

| Tool        | Purpose                            |
|-------------|-------------------------------------|
| Terraform   | Provision AWS infrastructure        |
| AWS EC2     | Host Jenkins and your app           |
| Jenkins     | Automate CI/CD pipeline             |
| Docker      | Containerize and deploy app         |
| Trivy       | Scan Docker image for vulnerabilities |
| GitHub      | Version control & repo hosting      |

---

## 🔧 Setup Instructions

### 1. 📦 Terraform Infrastructure Provisioning

Initialize and apply Terraform:

```bash
terraform init
terraform plan -out tfplan
terraform apply tfplan
```

This provisions:

- VPC
- Internet Gateway
- EC2 instance with SSH access
- Security Groups

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

Access Jenkins UI at:  
`http://<your-ec2-public-ip>:8080`

---

### 3. 🤖 Jenkins Pipeline Overview

**Jenkinsfile** sample:

```groovy
pipeline {
    agent any

    environment {
        IMAGE_NAME = 'technovaaa'
        CONTAINER_NAME = 'technova-container'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/reshavgovindam/technovaaa.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Trivy Security Scan') {
            steps {
                sh '''
                    echo "Running Trivy scan..."
                    trivy image --severity HIGH,CRITICAL --no-progress -f table -o trivy-report.txt $IMAGE_NAME || true
                    cat trivy-report.txt
                '''
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker run -d -p 3000:3000 --name $CONTAINER_NAME $IMAGE_NAME'
            }
        }
    }
}
```

---

## 🐳 Dockerfile

```Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY . .
RUN npm install
EXPOSE 3000
CMD ["node", "index.js"]
```

---

## 🛡️ Security (Trivy)

We’ve added **Trivy vulnerability scanning** directly in the Jenkins pipeline:

```bash
trivy image technovaaa
```

You’ll get a detailed report in `trivy-report.txt`.

---

## ✉️ Contact

For any queries or suggestions:

📧 reshavgovindam@example.com  
🌐 [LinkedIn](https://linkedin.com/in/reshavgovindam)

---

## 📌 License

This project is licensed under the [MIT License](LICENSE).

---














