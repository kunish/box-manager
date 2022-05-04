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
