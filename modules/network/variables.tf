variable "student_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnets" {
  type = map(object({
    cidr_block = string
    az         = string
    public     = bool
  }))
}

variable "common_tags" {
  type = map(string)
}
