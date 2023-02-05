# Create an Application Load Balancer
resource "aws_lb" "Demo-load-balancer" {
  name               = "Demo-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Demo-load_balancer_sg.id]
  subnets            = [aws_subnet.Demo-public-subnet1.id, aws_subnet.Demo-public-subnet2.id]
  #enable_cross_zone_load_balancing = true
  enable_deletion_protection = false
  depends_on                 = [aws_instance.Server1, aws_instance.Server2, aws_instance.Server3]
}


# creating target group
resource "aws_lb_target_group" "Demo-target-group" {
  name        = "Demo-target-group"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.demo_vpc.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Create the listener
resource "aws_lb_listener" "Demo-listener" {
  load_balancer_arn = aws_lb.Demo-load-balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Demo-target-group.arn
  }
}
# Create the listener rule
resource "aws_lb_listener_rule" "Demo-listener-rule" {
  listener_arn = aws_lb_listener.Demo-listener.arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Demo-target-group.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

# Attach the target group to the load balancer
resource "aws_lb_target_group_attachment" "Demo-target-group-attachment1" {
  target_group_arn = aws_lb_target_group.Demo-target-group.arn
  target_id        = aws_instance.Server1.id
  port             = 80
}
 
resource "aws_lb_target_group_attachment" "Demo-target-group-attachment2" {
  target_group_arn = aws_lb_target_group.Demo-target-group.arn
  target_id        = aws_instance.Server2.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "Demo-target-group-attachment3" {
  target_group_arn = aws_lb_target_group.Demo-target-group.arn
  target_id        = aws_instance.Server3.id
  port             = 80 
}
