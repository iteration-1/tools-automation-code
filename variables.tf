variable "tools" {
  default = {
    prometheus = {
      instance_type = "t3.micro"
    }
  }
}

variable "zone_id" {
  default = "Z0569018TEBR9GQ8VL2K"
}