variable "ips" {
  type = map
  default = {
    "kube-1-m" = "192.168.0.1"
    "kube-2-w" = "192.168.0.2"
  }
}

variable "hostname" {
  type =  string
  default = "kube-"
  sensitive = false
}

variable "ssh_username" {
  type =  string
  default = "k3s"
  sensitive = false
}

variable "ssh_password" {
  type =  string
  default = "k3s"
  sensitive = false
}