pipeline {
    agent any

    environment {
        // 🔁 Replace with your actual Jenkins credentials IDs
        AWS_ACCESS_KEY_ID     = credentials('aws_access')         // or aws_access
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret')         // or aws_secret

        TF_VAR_aws_access_key = "${AWS_ACCESS_KEY_ID}"
        TF_VAR_aws_secret_key = "${AWS_SECRET_ACCESS_KEY}"
    }

    options {
        timestamps()
    }

    stages {

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    bat 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    bat 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Manual Approval') {
            steps {
                input(message: "✅ Approve to apply Terraform changes?")
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    bat 'terraform apply -auto-approve tfplan'
                }
            }
        }

        // ✅ NEW: Stage to Get EC2 Public IP from Terraform output
        stage('Fetch EC2 Public IP') {
            steps {
                dir('terraform') {
                    script {
                        env.EC2_PUBLIC_IP = sh(script: "terraform output -raw public_ip", returnStdout: true).trim()
                        echo "Fetched EC2 IP: ${env.EC2_PUBLIC_IP}"
                    }
                }
            }
        }

        // ✅ NEW: SSH to EC2 and Deploy Docker App
        stage('Deploy Docker App via SSH') {
            steps {
                sshagent(['tech_key']) {  // 🔁 Replace with your actual SSH private key ID in Jenkins
                    bat '''
                        ssh -o StrictHostKeyChecking=no ec2-user@$EC2_PUBLIC_IP << EOF
                            docker pull sakshi1285/my-node-app:latest    # 🔁 Replace with your Docker image
                            docker stop app || true
                            docker rm app || true
                            docker run -d --name app -p 5000:5000 sakshi1285/my-node-app:latest
                        EOF
                    '''
                }
            }
        }
    }

    post {
        failure {
            mail to: 'r89510562@gmail.com',
                 subject: "❌ Jenkins Pipeline Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "❗️Build failed in stage: ${env.STAGE_NAME}\n\n🔗 Jenkins link: ${env.BUILD_URL}"
        }
    }
}
