resource "aws_ecs_cluster" "app_cluster" {
  name = "devsecops-cluster"
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = "devsecops-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "devsecops-container"
    image     = "nginx:latest" # Placeholder until CI/CD is built
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
    }]
  }])
}

resource "aws_ecs_service" "app_service" {
  name            = "devsecops-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  # Deploying into private subnets and attaching the ECS security group
  network_configuration {
    subnets          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  # Connecting the service to the Application Load Balancer
  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "devsecops-container"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.front_end]
}