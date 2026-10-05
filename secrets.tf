resource "aws_secretsmanager_secret" "app_secret" {
  name        = "devsecops-app-secret"
  description = "Application configuration secrets for the DevSecOps platform"
}

# A placeholder secret to demonstrate the functionality
resource "aws_secretsmanager_secret_version" "app_secret_version" {
  secret_id     = aws_secretsmanager_secret.app_secret.id
  secret_string = jsonencode({
    "DATABASE_PASSWORD" = "placeholder-password-123",
    "API_KEY"           = "placeholder-api-key"
  })
}