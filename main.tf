provider "aws" {
  region = "eu-north-1"

}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Route Table for Public Subnet
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

# Associate Route Table with Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# Key Pair (Make sure ~/.ssh/id_rsa.pub exists)
resource "aws_key_pair" "generated_key" {
  key_name   = "my-key"
  public_key = file("C:/Users/Suhani/.ssh/id_rsa.pub")
 # 🔁 Change path if your key is elsewhere
}

# Security Group - Allow SSH and custom Docker port
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

  # 🔁 CHANGE THIS BLOCK to allow port 5000
  ingress {
    description = "Docker App Port 5000"
    from_port   = 5000 # 🔁 Change from 80 to 5000
    to_port     = 5000 # 🔁 Change from 80 to 5000
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

# EC2 Instance
resource "aws_instance" "web" {
  ami                         = "ami-0989fb15ce71ba39e" # ✅ Amazon Linux 2023 (Docker ready)
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  key_name                    = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true

  # 🔁 UPDATE THIS: Port 5000 instead of 80
  # You can also replace 'nginx' with your custom Docker image
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ec2-user
              docker run -d -p 5000:5000 nginx    # 🔁 Change 80:80 to 5000:5000
              EOF

  tags = {
    Name = "docker-app-on-5000"
  }
}

# ✅ OPTIONAL: Output public IP after apply
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
