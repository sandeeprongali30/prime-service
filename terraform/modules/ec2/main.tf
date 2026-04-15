# Security Group (VPN only)
resource "aws_security_group" "vpn_sg" {
  name        = "${var.name}-sg"
  description = "Allow VPN access only"

  ingress {
    description = "WireGuard VPN"
    from_port   = var.vpn_port
    to_port     = var.vpn_port
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = "${var.name}-sg"
    },
    var.tags
  )
}

# IAM Role for SSM
resource "aws_iam_role" "ssm_role" {
  name = "${var.name}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

# Attach AWS managed SSM policy
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance Profile
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.name}-ssm-profile"
  role = aws_iam_role.ssm_role.name
}

# EC2 Instance
resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.vpn_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name
  user_data              = file(var.user_data_path)
  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}