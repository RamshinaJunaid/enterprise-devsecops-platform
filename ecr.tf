resource "aws_ecr_repository" "app_repo" {
  name                 = "devsecops-app-repo"
  image_tag_mutability = "MUTABLE"

  # Enables vulnerability assessment for container images
  image_scanning_configuration {
    scan_on_push = true
  }
}