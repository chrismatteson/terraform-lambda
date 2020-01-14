variable "enable" {
  default = true
}
variable "function_name" {}
variable "source_files" {
  type = list(map(string))
}
variable "runtime" {
  default = "python2.7"
}
variable "timeout" {
  default = 30
}
variable "memory_size" {
  default = 128
}
variable "tags" {
  default = {}
}
variable "environment_variables" {
  type    = map(string)
  default = {}
}
variable "handler" {
  type = string
  default = "lambda_function.lambda_handler"
}
