# Define Puclic keys of Deployer
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")
  tags       = local.common_tags
}
# This defines default subnets in vpc 
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.all.names[0]
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.all.names[1] 
}
resource "aws_default_subnet" "default_az3" {
  availability_zone = data.aws_availability_zones.all.names[2]
}
# Creating Security Groups
resource "aws_security_group" "quest_sg" {
  name        = "quest-sg"
  description = "Allow TLS inbound traffic"
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "nodejs"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}

# Deploys EC2 Instance
resource "aws_instance" "quest" {
  ami                    = data.aws_ami.amazon.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.quest_sg.id]
  key_name               = aws_key_pair.deployer.key_name
  availability_zone      = data.aws_availability_zones.all.names[0]
  user_data              = file("tools.sh")
  tags                   = local.common_tags
}

resource "null_resource" "commands" {
  depends_on = [aws_instance.quest, aws_security_group.quest_sg]
  triggers = {
    always_run = timestamp()
  }
 
  # Execute linux commands on remote machine to 
  provisioner "remote-exec" {
    connection {
      host        = aws_instance.quest.public_ip
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
    }
    inline = [
      "echo please wait instance userdata still loading",
      "sleep 120",
      "git clone https://github.com/ichumarin/quest.git",
      "cd quest",
      "sudo docker build -t quest:latest .",
      "sudo docker run -d -p:3000:3000 quest:latest"
    ]
 }
}