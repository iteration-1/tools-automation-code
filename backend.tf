terraform {
  backend "s3" {
    bucket = "yopappiyo"
    key    = "tools/state"
    region = "us-east-1"
  }
}
