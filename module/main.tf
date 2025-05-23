resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.ec2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.selected.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name


  instance_market_options {
    market_type = "spot"
    spot_options {
      instance_interruption_behavior = "stop"
      spot_instance_type              = "persistent"
    }
  }

  tags = {
    Name    = var.tool_name
  }
}

resource "aws_route53_record" "route" {
  name    = var.tool_name
  type    = "A"
  zone_id = var.zone_id
  records = [aws_instance.ec2.public_ip]
  ttl     = 30

}

resource "aws_route53_record" "route-internal" {
  name    ="${var.tool_name}-internal"
  type    = "A"
  zone_id = var.zone_id
  records = [aws_instance.ec2.private_ip]
  ttl     = 30

}

resource "aws_iam_role" "role" {
  name = "${var.tool_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "${var.tool_name}-policy_resource_list"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = var.policy_resource_list
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }


  tags = {
    Name = "${var.tool_name}-role"
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.tool_name}-role"
  role = aws_iam_role.role.name
}
