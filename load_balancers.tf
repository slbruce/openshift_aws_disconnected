resource "aws_lb" "api_lb" {
  name = "api-lb"

  internal           = true
  load_balancer_type = "network"
  subnets            = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]
  security_groups    = [aws_security_group.api_lg_sg.id]
}

resource "aws_lb_target_group" "api_lb_tg_6443" {
  name        = "api-lg-tg-6443"
  port        = 6443
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = aws_vpc.installation_vpc.id

  health_check {
    enabled = true
    healthy_threshold = 2
    unhealthy_threshold = 3
    interval = 10
    path = "/readyz"
    protocol = "HTTPS"
    matcher = 200
  }
}

resource "aws_lb_target_group_attachment" "api_lb_tg_6443_to_master0_attachment" {
  target_group_arn  = aws_lb_target_group.api_lb_tg_6443.arn
  target_id         = var.master0_ip
  port              = 6443
  availability_zone = aws_subnet.private_subnet_1.availability_zone
}

resource "aws_lb_target_group_attachment" "api_lb_tg_6443_to_master1_attachment" {
  target_group_arn  = aws_lb_target_group.api_lb_tg_6443.arn
  target_id         = var.master1_ip
  port              = 6443
  availability_zone = aws_subnet.private_subnet_2.availability_zone
}

resource "aws_lb_target_group_attachment" "api_lb_tg_6443_to_master2_attachment" {
  target_group_arn  = aws_lb_target_group.api_lb_tg_6443.arn
  target_id         = var.master2_ip
  port              = 6443
  availability_zone = aws_subnet.private_subnet_3.availability_zone
}

resource "aws_lb_listener" "api_lb_listener_6443" {
  load_balancer_arn = aws_lb.api_lb.arn
  port              = 6443
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_lb_tg_6443.arn
  }
}

resource "aws_lb_target_group" "api_lb_tg_22623" {
  name        = "api-lb-tg-22623"
  port        = 22623
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = aws_vpc.installation_vpc.id
}

resource "aws_lb_target_group_attachment" "api_lb_tg_22623_to_master0_attachment" {
  target_group_arn  = aws_lb_target_group.api_lb_tg_22623.arn
  target_id         = var.master0_ip
  port              = 22623
  availability_zone = aws_subnet.private_subnet_1.availability_zone
}

resource "aws_lb_target_group_attachment" "api_lb_tg_22623_to_master1_attachment" {
  target_group_arn  = aws_lb_target_group.api_lb_tg_22623.arn
  target_id         = var.master1_ip
  port              = 22623
  availability_zone = aws_subnet.private_subnet_2.availability_zone
}

resource "aws_lb_target_group_attachment" "api_lb_tg_22623_to_master2_attachment" {
  target_group_arn  = aws_lb_target_group.api_lb_tg_22623.arn
  target_id         = var.master2_ip
  port              = 22623
  availability_zone = aws_subnet.private_subnet_3.availability_zone
}

resource "aws_lb_listener" "api_lb_listener_22623" {
  load_balancer_arn = aws_lb.api_lb.arn
  port              = 22623
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_lb_tg_22623.arn
  }
}

resource "aws_lb" "apps_ingress_lb" {
  name = "apps-ingress-lb"

  internal           = true
  load_balancer_type = "network"
  subnets            = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_3.id]
  security_groups    = [aws_security_group.apps_lb_sg.id]
}

resource "aws_lb_target_group" "apps_ingress_lb_tg_443" {
  name        = "app-ingress-nlb-443-lb"
  port        = 443
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = aws_vpc.installation_vpc.id
  stickiness {
    enabled = true
    type = "source_ip"
  }
}

resource "aws_lb_target_group_attachment" "apps_ingress_lb_tg_443_to_worker0_attachment" {
  target_group_arn  = aws_lb_target_group.apps_ingress_lb_tg_443.arn
  target_id         = var.worker0_ip
  port              = 443
  availability_zone = aws_subnet.private_subnet_1.availability_zone
}

resource "aws_lb_target_group_attachment" "apps_ingress_lb_tg_443_to_worker1_attachment" {
  target_group_arn  = aws_lb_target_group.apps_ingress_lb_tg_443.arn
  target_id         = var.worker1_ip
  port              = 443
  availability_zone = aws_subnet.private_subnet_3.availability_zone
}

resource "aws_lb_listener" "apps_ingress_lb_listener_443" {
  load_balancer_arn = aws_lb.apps_ingress_lb.arn
  port              = 443
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apps_ingress_lb_tg_443.arn
  }
}

resource "aws_lb_target_group" "apps_ingress_lb_tg_80" {
  name        = "app-ingress-nlb-80-lb"
  port        = 80
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = aws_vpc.installation_vpc.id
}

resource "aws_lb_target_group_attachment" "apps_ingress_lb_tg_80_to_worker0_attachment" {
  target_group_arn  = aws_lb_target_group.apps_ingress_lb_tg_80.arn
  target_id         = var.worker0_ip
  port              = 80
  availability_zone = aws_subnet.private_subnet_1.availability_zone
}

resource "aws_lb_target_group_attachment" "apps_ingress_lb_tg_80_to_worker1_attachment" {
  target_group_arn  = aws_lb_target_group.apps_ingress_lb_tg_80.arn
  target_id         = var.worker1_ip
  port              = 80
  availability_zone = aws_subnet.private_subnet_3.availability_zone
}

resource "aws_lb_listener" "apps_ingress_lb_listener_80" {
  load_balancer_arn = aws_lb.apps_ingress_lb.arn
  port              = 80
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apps_ingress_lb_tg_80.arn
  }
}