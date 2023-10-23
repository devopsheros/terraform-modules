// CLOUD DNS
resource "google_dns_managed_zone" "my_dns_zone" {
  name        = var.domain_name
  description = "Terraform DNS Zone"
  dns_name    = var.domain_host
}

resource "google_dns_record_set" "a_record_subdomain" {
  count = length(var.domain_env_name)
  name    = "${var.domain_env_name[count.index]}.devopsheros.com."
  type    = "A"
  ttl     = 300
  managed_zone = google_dns_managed_zone.my_dns_zone.name
  rrdatas = [
    google_compute_address.ingress_ip_address[count.index].address
  ]
}

resource "google_dns_record_set" "cname_record_subdomain" {
  count = length(var.domain_env_name)
  name = "www.${var.domain_env_name[count.index]}.devopsheros.com."
  type = "CNAME"
  ttl = 300
  managed_zone = google_dns_managed_zone.my_dns_zone.name
  rrdatas = [
    "${var.domain_env_name[count.index]}.devopsheros.com."
  ]
}


# Static IP
resource "google_compute_address" "ingress_ip_address" {
  count = length(var.domain_env_name)
  name = "nginx-controller-${var.domain_env_name[count.index]}"
  address_type = "EXTERNAL"
  region = var.subnet_region
}
