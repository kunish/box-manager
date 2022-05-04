variable "qemus" {
  type = list(string)
}

variable "target_node" {
  type = string
}

variable "clone" {
  type = string
}

variable "cores" {
  type = number
}

variable "memory" {
  type = number
}

variable "diskSizeInGB" {
  type = number
}
