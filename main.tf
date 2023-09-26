provider "aws" {
  region = "ap-southeast-2"
  profile = "event-calendar"
}

// For CRON Job
resource "aws_ecr_repository" "cron-job" {
  name = "cron-job"
}

resource "aws_ecs_task_definition" "cron-job-task" {
  family                   = "cron-job-task"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "cron-job-task",
      "image": "${aws_ecr_repository.cron-job.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 5000,
          "hostPort": 5000
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # use Fargate as the launch type
  network_mode             = "awsvpc"    # add the AWS VPN network mode as this is required for Fargate
  memory                   = 512         # Specify the memory the container requires
  cpu                      = 256         # Specify the CPU the container requires
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

// For RDS DB
resource "aws_db_instance" "event-calendar-db" {
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  username = "admin"
  password = "password"
  parameter_group_name = "default.mysql5.7"
}

// For React EC2 instance
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow inbound SSH traffic"

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

resource "aws_instance" "react-app" {
  ami = "ami-00f3471feb1f3897e" // Default AMI from AWS
  instance_type = "t2.micro"
  key_name = "event-calendar"

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

#  provisioner "local-exec" {
#    command = "ansible-playbook -i '${aws_instance.react-app.public_ip},' --private-key ~/.ssh/id_rsa -u admin playbook.yml"
#  }
}

output "react-app-public-ip" {
  value = aws_instance.react-app.public_ip
}