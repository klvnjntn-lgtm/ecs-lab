resource "aws_ecr_repository" "app_repo" {
  name                 = lower("${var.project_name}-repo")
  image_tag_mutability = "MUTABLE"
  force_delete = true 

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "app_repo_policy" {
  repository = aws_ecr_repository.app_repo.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep only the last 5 images to save costs"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 5
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

output "repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}