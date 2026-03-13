variable "key_name" {
  description = "Name of your AWS EC2 Key Pair"
  type        = string
}

variable "my_ip" {
  description = "IP address allowed to SSH into the instance"
  type        = string
}
