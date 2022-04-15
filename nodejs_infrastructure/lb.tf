# Create a new load balancer and Target Groups
resource "aws_lb" "quest" {
  name               = "quest-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.quest_sg.id]
  subnets            = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id, aws_default_subnet.default_az3.id]
  
  tags = local.common_tags
}
resource "aws_lb_target_group" "quest_3000" {
  depends_on = [ aws_lb.quest ]
  name     = "quest-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  health_check {
    path = "/"
    port = 3000
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 15
    interval = 30
    matcher = "200"  # has to be HTTP 200 or fails
  }

  tags = local.common_tags
}

resource "aws_lb_target_group_attachment" "quest_attachemnt" {
  target_group_arn = aws_lb_target_group.quest_3000.arn
  target_id        = aws_instance.quest.id
  port             = 3000
}

resource "aws_lb_listener" "quest_3000" {
  load_balancer_arn = aws_lb.quest.arn
  port              = "80"
  protocol          = "HTTP"
  #certificate_arn   = "${var.elk_cert_arn}"

  default_action {
    target_group_arn = aws_lb_target_group.quest_3000.arn
    type             = "forward"
  }
  tags = local.common_tags
}