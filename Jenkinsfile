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
                    def rawOutput = bat(
                        script: 'terraform output -raw instance_public_ip',
                        returnStdout: true
                    )
                    env.EC2_PUBLIC_IP = rawOutput.trim()
                    echo "Fetched EC2 IP: ${env.EC2_PUBLIC_IP}"
                }
            }
        }

        stage('Create Deployment Script') {
            steps {
                writeFile file: 'setup.sh', text: '''
#!/bin/bash
sudo yum install -y docker
sudo systemctl start docker
sudo docker pull sakshi1285/my-node-app:latest
sudo docker stop app || true
sudo docker rm app || true
sudo docker run -d --name app -p 5000:5000 sakshi1285/my-node-app:latest
'''
            }
        }

        stage('Deploy Docker App via SSH') {
            steps {
                powershell """
                    \$ip = '${env.EC2_PUBLIC_IP}'

                    scp -i "C:/Users/Suhani/.ssh/technova_key" -o StrictHostKeyChecking=no setup.sh ec2-user@\${ip}:/home/ec2-user/

                    ssh -i "C:/Users/Suhani/.ssh/technova_key" -o StrictHostKeyChecking=no ec2-user@\${ip} "chmod +x setup.sh && ./setup.sh"
                """
            }
        }

        stage('Destroy Infrastructure') {
            steps {
                input(message: "⚠️ Do you want to destroy the infrastructure and stop billing?")
                bat 'terraform destroy -auto-approve'
            }
        }
    }
}
