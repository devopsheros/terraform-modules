// CLOUD DNS
variable "domain_name" {
  type = string
}

variable "domain_host" {
  type = string
  default = "devopsheros.com."
}

variable "domain_env_name" {
  type = list(string)
}

variable "subnet_region" {
  type = string
}
