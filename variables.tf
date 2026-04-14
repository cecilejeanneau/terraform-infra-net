
variable "student_name" {
  type        = string
  description = "Nom de l'étudiant"
  default     = "cecile"
}

variable "promo_name" {
  type        = string
  description = "Nom de la promo"
  default     = "READL_006"
}

variable "environment" {
  type        = string
  description = "Environnement de déploiement (dev, test, prod)"
  default     = "dev"
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "L'environnement doit être 'dev', 'test' ou 'prod'."
  }
}

variable "region" {
  type        = string
  description = "Région AWS (seulement us-east-1 autorisée)"
  default     = "us-east-1"
  validation {
    condition     = var.region == "us-east-1"
    error_message = "Seule la région 'us-east-1' est autorisée."
  }
}

variable "key_pair_name" {
  type        = string
  description = "Nom de la key pair SSH à utiliser pour l'accès EC2"
  default     = null
}

variable "key_name" {
  type        = string
  description = "Nom de la key pair SSH (variable standard TP3)"
  default     = "tf-cecile-dev-key"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR du VPC principal"
  default     = "10.10.0.0/16"
}

variable "subnets" {
  description = "Définition des subnets (public/private)"
  type = map(object({
    cidr_block = string
    az         = string
    public     = bool
  }))
  default = {
    public = {
      cidr_block = "10.10.1.0/24"
      az         = "us-east-1a"
      public     = true
    }
    private = {
      cidr_block = "10.10.2.0/24"
      az         = "us-east-1a"
      public     = false
    }
  }
}

variable "ami_owner" {
  type        = string
  description = "Owner AWS de l'AMI Ubuntu"
  default     = "099720109477"
}

variable "ami_name_pattern" {
  type        = string
  description = "Pattern de nom pour sélectionner l'AMI Ubuntu"
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}
