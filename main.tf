provider "aws" {
  region = "ap-southeast-2"
  profile = "event-calendar"
}

// For RDS DB
variable "db_username" {}
variable "db_password" {}

resource "aws_db_instance" "event-calendar-db" {
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  username = var.db_username
  password = var.db_password
  parameter_group_name = "default.mysql5.7"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_security_group"  "express_sg" {
  name = "express_sg"

  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name = "rds_sg"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.express_sg.id, aws_security_group.ec2_sg.id]
  }
  depends_on = [aws_security_group.express_sg, aws_security_group.ec2_sg]
}

// For CRON Job
resource "aws_instance" "cron-job" {
  ami = "ami-00f3471feb1f3897e" // Default AMI from AWS
  instance_type = "t2.micro"
  key_name = "event-calendar"

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "cron-job"
  }
}

resource "aws_security_group" "ec2_sg" {
  description = "Allow inbound SSH traffic"

  tags = {
    Name = "ec2_sg"
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// For React EC2 instance

resource "aws_instance" "react-app" {
  ami = "ami-00f3471feb1f3897e" // Default AMI from AWS
  instance_type = "t3.micro" # Hopefully builds my react app in under 5 minutes (!!)
  key_name = "event-calendar"

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "react-app"
  }
}

output "react-app-public-dns" {
  value = aws_instance.react-app.public_dns
}

output "cron-job-public-dns" {
  value = aws_instance.cron-job.public_dns
}

output "db-endpoint" {
  value = aws_db_instance.event-calendar-db.endpoint
}