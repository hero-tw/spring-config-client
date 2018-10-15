variable "access_key" {
  description = "The AWS access key."
}

variable "secret_key" {
  description = "The AWS secret key."
}

variable "region" {
  description = "The AWS region to create resources in."
  default = "us-east-1"
}

variable "availability_zone" {
  description = "The availability zone"
  default = "us-east-1b"
}

variable "run_name" {
  description = "The name for the execution run."
}

variable "amis" {
  description = "AMI Options"
  default = {
    us-east-1 = "ami-0ac019f4fcb7cb7e6"
  }
}

variable "instance_type" {
  default = "t2.micro"
}