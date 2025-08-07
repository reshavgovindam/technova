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
         //   mail to: 'r89510562@gmail.com',
                 subject: "❌ Jenkins Pipeline Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "❗Build failed in stage: ${env.STAGE_NAME}\n\n🔗 Jenkins link: ${env.BUILD_URL}"
        }
    }

