variable "vms" {
  type = list(string)
}

variable "memory" {
  type = number
}

variable "diskSizeInGB" {
  type = number
}

variable "ostemplate" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
}

variable "ssh_public_key_path" {
  type      = string
  sensitive = true
}
