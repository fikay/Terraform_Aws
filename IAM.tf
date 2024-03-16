resource "aws_iam_role" "Jenkins-Service-Role" {
  name = "Service_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}



resource "aws_iam_role_policy" "Jenkins-Service-Role-policy" {
  name        = "Jenkins-Service-Role-policy"
  role = aws_iam_role.Jenkins-Service-Role.id
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = [
          "ecs:CreateService",
          "ecs:UpdateService",
          "ecs:DeleteService",
          "ecs:RegisterTaskDefinition",
          "ecs:DeregisterTaskDefinition",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:UpdateAutoScalingGroup",
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters",
          "rds:DescribeDBClusterSnapshots",
          "rds:CreateDBSnapshot",
          "rds:DeleteDBSnapshot",
          "rds:ModifyDBSnapshot",
          "rds:RestoreDBClusterFromSnapshot",
          "rds:RestoreDBInstanceFromDBSnapshot"
        ]
        Resource  = "*"
      }
    ]
  })
}


# resource "aws_iam_role_policy_attachment" "Jenkins-Service-Role-policy" {
#   role       = aws_iam_role.Jenkins-Service-Role.name
#   policy_arn = aws_iam_role_policy.Jenkins-Service-Role-policy.arn
# }