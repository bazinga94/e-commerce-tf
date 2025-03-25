resource "aws_instance" "jmeter" {
  ami                    = "ami-04aa00acb1165b32a" # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.jmeter_sg.id]
  key_name               = "efs_ec2_key_pair" # change this to the keys you already have or are going to generate
  subnet_id              = aws_subnet.public-subnet["subnet-az1"].id

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y java-11-amazon-corretto-headless # Install OpenJDK 11
              wget https://dlcdn.apache.org/jmeter/binaries/apache-jmeter-5.6.3.tgz # Download JMeter
              sudo tar -xvzf apache-jmeter-5.6.3.tgz -C /opt/ # Extract JMeter to /opt directory
              sudo mv /opt/apache-jmeter-5.6.3 /opt/jmeter # Rename JMeter directory
              echo 'export PATH=$PATH:/opt/jmeter/bin' >> ~/.bashrc # Add JMeter to PATH
              source ~/.bashrc
              EOF

  tags = {
    Name = "JMeter-Instance"
  }
}

resource "aws_security_group" "jmeter_sg" {
  name        = "jmeter-sg"
  description = "Allow SSH and JMeter traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_rds.id] # RDS
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
