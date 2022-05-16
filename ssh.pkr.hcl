variable "ssh_username" {
  type    = string
  default = "deploy"
}

variable "ssh_password" {
  type    = string
  default = "MySecretPassword"
  sensitive = true
}