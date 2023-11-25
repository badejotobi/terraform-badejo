#CREATE LOAD BALANCER for our app server ........load balancer
resource "aws_lb" "loading" {
  name               = "twotier"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.Alb]
  subnets            = [var.public1, var.public2]

  tags = {
    Environment = "loading"
  }
}

resource "aws_lb_target_group" "load-target" {
  name     = "loading-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}
resource "aws_lb_listener" "loading-listener" {
  load_balancer_arn = aws_lb.loading.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.load-target.arn
  }
}

##CREATE LOADBALANCER FOR WEBSERVER
resource "aws_lb" "webload" {
  name               = "webload"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.Wlb]
  subnets            = [var.public3, var.public4]

  tags = {
    Environment = "webload"
  }
}

resource "aws_lb_target_group" "web-load-target" {
  name     = "web-loading-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}
resource "aws_lb_listener" "web-loading-listener" {
  load_balancer_arn = aws_lb.webload.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-load-target.arn
  }
}