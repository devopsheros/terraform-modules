// providers
terraform {
  backend "gcs" {
    bucket = "terraform-modules-bucket"
    prefix = "terrafrom"
    credentials = "C:\\Users\\Alon\\PycharmProjects\\project1\\venv\\terraform-modules\\modules\\key.json"
  }
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.66.0"
    }
  }
}

provider "google" {
  credentials = file(var.key_path)
  project = var.gcp_project

}

module "cloudDNS" {
  source = "../../modules/clouddns"
  domain_name = "dns-zone"
  domain_host = module.cloudDNS.domain_host
  domain_env_name = var.clouddns.domain_env_name[*]
  subnet_region = "us-central1"
  #ip_address = module.cloudDNS.ip_address[count.index]
}