resource "aws_security_group" "ac_inst_1_sg" {
  name        = "ac-inst-1-sg"
  description = "inst_1 security group"
  vpc_id      = aws_vpc.ac_vpc.id

  ingress {
    description = ""
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ac-inst1-sg"
  }
}

resource "aws_network_interface" "ac_inst_ni" {
  subnet_id   = aws_subnet.ac_public_subnet.id
  private_ips = ["10.0.100.10"]

  tags = {
    Name = "ac-inst-ni"
  }
}

resource "aws_instance" "ac_inst_1" {
  ami                    = data.aws_ami.ac_server_ami.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ac_simple_public_key.key_name
  vpc_security_group_ids = [aws_security_group.ac_inst_1_sg.id]
  subnet_id              = aws_subnet.ac_public_subnet.id

  user_data = file("userdata.tpl")

  provisioner "local-exec" {
    command = templatefile("${path.module}/ssh-config.tpl", { 
      hostname = self.public_ip,
      user = "ubuntu",
      identityfile = var.ac_simple_private_key
    })
  }

  tags = {
    Name = "ac-inst-1"
  }
}