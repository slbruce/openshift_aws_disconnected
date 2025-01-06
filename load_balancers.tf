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

