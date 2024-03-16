resource "aws_ecs_cluster" "makinates-cluster" {
  name = "makinates-cluster"
  tags = {
    Name = "my-ecs-cluster"
  }
  setting {
    name = "containerInsights"
    value = "enabled"
  }
}


# resource "aws_ecs_cluster_capacity_providers" "cluster-system" {
#   cluster_name = aws_ecs_cluster.makinates-cluster.name

#   capacity_providers = ["Ec2"]

#   default_capacity_provider_strategy {
#     base              = 1
#     weight            = 100
#     capacity_provider = "Ec2"
#   }
# }
resource "aws_ecs_task_definition" "Makinates-task" {
  family                = "service"
  container_definitions = file("task-definitions/service.json")

  # volume {
  #   name = "service-storage"

  #   docker_volume_configuration {
  #     scope         = "shared"
  #     autoprovision = true
  #     driver        = "local"

  #     driver_opts = {
  #       "type"   = "nfs"
  #       "device" = "${aws_efs_file_system.fs.dns_name}:/"
  #       "o"      = "addr=${aws_efs_file_system.fs.dns_name},rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport"
  #     }
  #   }
  # }
}

resource "aws_ecs_service" "Jenkins-Service" {
  name            = "Jenkins"
  cluster         = aws_ecs_cluster.makinates-cluster.id
  task_definition = aws_ecs_task_definition.Makinates-task.arn
  desired_count   = 2
  iam_role        = aws_iam_role.Jenkins-Service-Role.arn
  depends_on      = [aws_iam_role_policy.Jenkins-Service-Role-policy]

  # ordered_placement_strategy {
  #   type  = "binpack"
  #   field = "cpu"
  # }

  load_balancer {
    target_group_arn = aws_lb_target_group.Ecs-target-group.arn
     container_name   = "jenkins"
    container_port   = 8080
  }

  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  # }
}


