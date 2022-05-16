
variable "vsphere_deployment_username" {
  type    = string 
  default = "deploy@vsphere.local"
}

variable "vsphere_deployment_password" {
  type    = string
  default = "C0mplex!" 
  sensitive = true
}

variable "vsphere_vcenter"  {
  type    = string
  default = "vi.infra.risewi.de"
}

variable "vsphere_cluster" {
  type    = string
  default = "dc-01"
}

variable "vsphere_target_esx_host" {
  type    = string
  default = "esx-01.infra.risewi.de"
}

// In a lab environment, insecure connections with self-signed certs
// are okay; in production you should do it right
variable "vsphere_allow_insecure_connection" {
  type    = bool
  default = false
}