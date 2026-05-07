resource "aws_key_pair" "auth_key" {
  key_name   = "${var.project_name}-${var.project_environment}"
  public_key = file("mykey.pub")

  tags = {
    Name = "${var.project_name}-${var.project_environment}"
  }
}

resource "aws_security_group" "webserver" {

  name        = "${var.project_name}-${var.project_environment}-webserver"
  description = "${var.project_name}-${var.project_environment}-webserver"

  tags = {
    Name = "${var.project_name}-${var.project_environment}-webserver"

  }
}


resource "aws_security_group_rule" "webserver_egress" {

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.webserver.id
}


resource "aws_security_group_rule" "webserver_ingress" {

  for_each = toset(var.webserver_ingress_ports)

  type              = "ingress"
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.webserver.id
}


resource "aws_instance" "webserver" {

  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.auth_key.key_name
  vpc_security_group_ids = [aws_security_group.webserver.id]
  user_data              = file("setup.sh")
  tags = {
    "Name" = "${var.project_name}-${var.project_environment}-webserver"
  }
}


resource "aws_eip" "webserver" {
  count  = var.enable_elastic_eip ? 1 : 0
  domain = "vpc"
}

resource "aws_eip_association" "webserver" {
  count = var.enable_elastic_eip ? 1 : 0

  instance_id   = aws_instance.webserver.id
  allocation_id = aws_eip.webserver[0].id
}

resource "aws_route53_record" "webserver_eip_enabled" {
  count = var.enable_elastic_eip ? 1 : 0

  zone_id = data.aws_route53_zone.domain.zone_id
  name    = var.hostname
  type    = "A"
  ttl     = 5
  records = [aws_eip.webserver[0].public_ip]
}

resource "aws_route53_record" "webserver_eip_disabled" {
  count = var.enable_elastic_eip == false ? 1 : 0

  zone_id = data.aws_route53_zone.domain.zone_id
  name    = var.hostname
  type    = "A"
  ttl     = 5
  records = [aws_instance.webserver.public_ip]
}
