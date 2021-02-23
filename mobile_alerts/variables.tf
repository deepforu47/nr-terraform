variable "account_id" {
  type    = number
  default = 102
  sensitive = true
}
variable "api_key" {
  type = string
  default = "api_key"
  sensitive = true
}
variable "region" {
  type = string
  default = "US"
}
