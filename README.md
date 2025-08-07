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
technovaaa/
│
├── Dockerfile
├── main.tf
├── variables.tf
├
├── jenkins/
│   └── Jenkinsfile
├── app/              
│   ├── index.js
│   └── package.json
└── README.md
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
| Trivy       | Scan Docker image for vulnerabilities |
| GitHub      | Version control & repo hosting      |

---
## ⚠️ Prerequisites

Before running this project, make sure you have:

- AWS account with IAM user and key pair
- AWS CLI configured on your local machine
- Jenkins installed on EC2 (via Terraform or manually)
- Docker installed on EC2
- Trivy installed on EC2 (optional)
- GitHub repo set up with Dockerfile and app code
- SSH key configured for EC2 access

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
## 🔧 Setup Instructions

### 1. 📦 Terraform Infrastructure Provisioning

Initialize and apply Terraform:

```bash
terraform init
terraform plan -out tfplan
terraform apply tfplan
```
## 🧱 Terraform Files
### `main.tf`
```hcl
provider "aws" {
  region = "eu-north-1"

}


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}


resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}


resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_key_pair" "generated_key" {
  key_name   = "tech-key"
  public_key = file("C:/Users/Suhani/.ssh/technova_key.pub")

}


resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Allow SSH and Docker port"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  ingress {
    description = "Docker App Port 5000"
    from_port   = 5000 
    to_port     = 5000 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-sg"
  }
}


resource "aws_instance" "web" {
  ami                         = "ami-0989fb15ce71ba39e" 
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  key_name                    = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true

  
  
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ec2-user
              docker run -d -p 5000:5000 nginx    
              EOF

  tags = {
    Name = "docker-app-on-5000"
  }
}


output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
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
        AWS_ACCESS_KEY_ID     = credentials('aws_access')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret')

        TF_VAR_aws_access_key = "${AWS_ACCESS_KEY_ID}"
        TF_VAR_aws_secret_key = "${AWS_SECRET_ACCESS_KEY}"
    }

    options {
        timestamps()
    }

    stages {

        stage('Terraform Init') {
            steps {
                bat 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                bat 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                bat 'terraform plan -out=tfplan'
            }
        }

        stage('Manual Approval') {
            steps {
                input(message: "✅ Approve to apply Terraform changes?")
            }
        }

        stage('Terraform Apply') {
            steps {
             bat 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Fetch EC2 Public IP') {
            steps {
                script {
                    env.EC2_PUBLIC_IP = bat(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
                    echo "Fetched EC2 IP: ${env.EC2_PUBLIC_IP}"
                }
            }
        }

        stage('Deploy Docker App via SSH') {
            steps {
                sshagent(['tech_key']) {
                    bat """
                        ssh -o StrictHostKeyChecking=no ec2-user@${env.EC2_PUBLIC_IP} << EOF
                            sudo yum install -y docker
                            sudo systemctl start docker
                            sudo docker pull sakshi1285/my-node-app:latest
                            sudo docker stop app || true
                            sudo docker rm app || true
                            sudo docker run -d --name app -p 5000:5000 sakshi1285/my-node-app:latest
                        EOF
                    """
                }
            }
        }
    }

    post {
        failure {
            mail to: 'r89510562@gmail.com',
                 subject: "❌ Jenkins Pipeline Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "❗Build failed in stage: ${env.STAGE_NAME}\n\n🔗 Jenkins link: ${env.BUILD_URL}"
        }
    }
}
```

---

## 🐳 Dockerfile

```Dockerfile

FROM node:18

WORKDIR /app

COPY package*.json ./


RUN npm install

COPY . .


EXPOSE 3000

CMD ["node", "index.js"]
```
---

## 🧪 Run Locally

You can run the app on your local Docker using:

docker build -t technova .
docker run -p 5000:5000 technova





---

## 🔮 Future Improvements

✅ Slack / Webhook Notifications
✅ Monitoring with Prometheus & Grafana
✅ Push Docker images to DockerHub/ECR
✅ Load Balancer & Auto Scaling via Terraform
✅ Add Unit Testing & Code Coverage


---
## 🧪 Testing
Once deployed, visit your app at:
🔗 http://<EC2_PUBLIC_IP>:3000

---














