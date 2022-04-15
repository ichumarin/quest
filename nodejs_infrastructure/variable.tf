variable "region" {
  type        = string
  description = "Please provide a region for instances"
  default     = "us-east-1"
}
variable "instance_type" {
    type        = string
    description = "Please provide an instance type"
   default = "t2.micro" 
}
