variable "enable" {
  default = true
}
variable "function_name" {}
variable "source_files" {}
variable "runtime" {
  default = python2.7
}
variable "timeout" {
  default = 30
}
variable "memory_size" {
  default = 128
}
variable "tags" {}
variable "environment_variables" {}
