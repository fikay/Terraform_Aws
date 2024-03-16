resource "aws_lb" "Ecs-Cluster" {
  name               = "cluster"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_tls.id]
  subnets            = [aws_subnet.public.id, aws_subnet.public2.id]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "Ecs-target-group" {
  name     = "targetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

