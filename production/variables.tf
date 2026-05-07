variable "aws_region" {
  description = "my aws region"
  type        = string
}

variable "project_name" {
  description = "my project name"
  type        = string
}

variable "project_environment" {
  description = "my project environment"
  type        = string
}

variable "instance_type" {
  description = "instance type"
  type        = string
}

variable "instance_ami" {
  description = "my instance ami id"
  type        = string
}

variable "domain_name" {
  description = "my domain name"
  type        = string
}

variable "hostname" {
  description = "my hostname"
  type        = string
}

variable "webserver_ingress_ports" {
  description = "webserver ingress ports"
  type        = list(any)
}

variable "enable_elastic_eip" {
  description = "enable elastic eip"
  type        = bool
}

