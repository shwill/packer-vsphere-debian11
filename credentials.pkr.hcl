variable "credentials_vsphere_username" {
  type    = string
  default = "deploy"
}

variable "credentials_vsphere_password" {
  type    = string
  default = "MySecretPassword"
  sensitive = true
}

variable "credentials_ssh_username" {
  type    = string
  default = "deploy"
}

variable "credentials_ssh_password" {
  type    = string
  default = "MySecretPassword"
  sensitive = true
}