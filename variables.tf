## 
## This defaults generates a 4096 bit RSA key
## for SSH
##

variable "bits" {
  type        = number
  default     = 4096
  description = "The number of bits to use for the SSH key"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "name" {
  type        = string
  description = "default servername"
  default     = "ghidra-server"
}

variable "tags" {
  type        = map(any)
  description = "tags for EC2 instance"
  default = {
    Name = "ghidra-server"
  }
}

variable "instance_type" {
  type        = string
  description = "AWS EC2 instance type"
  default     = "t2.large"
}

variable "prevent_destroy" {
  type        = bool
  description = "prevent api destroy of the instance once up"
  default     = true
}

variable "access_list" {
  type        = list(any)
  description = "list of CIDRs allowed access to the EC2 instance"
}

variable "docker_image_version" {
  type        = string
  description = "The image version of docker.io/retornam/ghidra-server"
  default     = "10.1.3"
}

variable "ghidra_users" {
  type        = string
  description = "space separated string with usernames"
  default     = "admin"
}
