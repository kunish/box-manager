variable "pm_api_url" {
  type      = string
  sensitive = true
}

variable "pm_user" {
  type      = string
  sensitive = true
}

variable "pm_password" {
  type      = string
  sensitive = true
}

variable "vm_password" {
  type      = string
  sensitive = true
}

variable "ssh_public_key_path" {
  type      = string
  sensitive = true
}
