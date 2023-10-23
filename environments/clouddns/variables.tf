variable "key_path" {
  type = string
  default = "C:\\Users\\Alon\\PycharmProjects\\project1\\venv\\terraform-modules\\modules\\key.json"
}

variable "gcp_project" {
  type = string
  default = "devops-project-387209"
}

variable "clouddns" {
  type = object({
    domain_env_name = list(string)
    domain_host = string
  })
}