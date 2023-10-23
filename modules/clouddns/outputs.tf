output "domain_host" {
  description = "DNS Host"
  value = "devopsheros.com."
}

output "ip_address"{
  value =  google_compute_address.ingress_ip_address[*].address
}