variable "tools" {
  default = {
    prometheus = {
      instance_type = "t3.micro"
      policy_resource_list = ["ec2:DescribeInstances"]
    }

    grafana = {
      instance_type = "t3.micro"
      policy_resource_list = ["ec2:DescribeInstances"]
    }
  }
}

variable "zone_id" {
  default = "Z0569018TEBR9GQ8VL2K"
}