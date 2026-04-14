locals {
  prefix = "tf-${var.student_name}-dev"
  common_tags = {
    course  = "TF-2026-04"
    env     = var.environment
    managed = "terraform"
    owner   = var.student_name
  }
  root_volume_tags = {
    course  = "TF-2026-04"
    env     = var.environment
    managed = "terraform"
  }
}
