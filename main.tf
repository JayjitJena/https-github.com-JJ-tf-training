resource "aws_vpc" "accent" {
  cidr_block           = var.address_space
  enable_dns_hostnames = true

  tags = {
    name = "${var.prefix}-vpc-${var.region}"
    environment = "Production"
  }
}

resource "aws_subnet" "accent" {
  vpc_id     = aws_vpc.accent.id
  cidr_block = var.subnet_prefix

  tags = {
    name = "${var.prefix}-subnet"
  }
}

resource "aws_security_group" "accent" {
  name = "${var.prefix}-security-group"

  vpc_id = aws_vpc.accent.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.prefix}-security-group"
  }
}

resource "aws_internet_gateway" "accent" {
  vpc_id = aws_vpc.accent.id

  tags = {
    Name = "${var.prefix}-internet-gateway"
  }
}

resource "aws_route_table" "accent" {
  vpc_id = aws_vpc.accent.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.accent.id
  }
}

resource "aws_route_table_association" "accent" {
  subnet_id      = aws_subnet.accent.id
  route_table_id = aws_route_table.accent.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    #values = ["ubuntu/images/hvm-ssd/ubuntu-disco-19.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_eip" "accent" {
  instance = aws_instance.accent.id
  vpc      = true
}

resource "aws_eip_association" "accent" {
  instance_id   = aws_instance.accent.id
  allocation_id = aws_eip.accent.id
}

resource "aws_instance" "accent" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.accent.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.accent.id
  vpc_security_group_ids      = [aws_security_group.accent.id]

  tags = {
    Name = "${var.prefix}-accent-instance"
  }
}
