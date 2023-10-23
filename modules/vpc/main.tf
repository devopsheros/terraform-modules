// providers
#terraform {
#  backend "gcs" {
#    bucket = "terraform-modules-bucket"
#    prefix = "terrafrom"
#    credentials = "C:\\Users\\Alon\\PycharmProjects\\project1\\venv\\terraform-modules\\modules\\key.json"
#  }
#  required_providers {
#    google = {
#      source = "hashicorp/google"
#      version = "4.66.0"
#    }
#  }
#}
#
#provider "google" {
#  credentials = file(var.key_path)
#  project = var.gcp_project
#
#}

// VPC
resource "google_compute_network" "network" {
  name = var.vpc_name
  project = var.gcp_project
  description = "VPC managed by terraform"
  auto_create_subnetworks = var.auto_create_subnetworks
  network_firewall_policy_enforcement_order = var.network_firewall_policy_enforcement_order
}

resource "google_compute_subnetwork" "subnetwork" {
  name = var.subnet_name
  ip_cidr_range = var.ip_cidr_range
  network = google_compute_network.network.name
  description = "Subnet managed by terraform"
  role = var.role
  region = var.subnet_region
  stack_type = var.stack_type
}


// FIREWALL
resource "google_compute_firewall" "default_ingress" {
  name    = var.firewall_name
  network = google_compute_network.network.name
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["30000-32767", "80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
  destination_ranges = ["${var.ip_address}/32"]

}

// NAT
resource "google_compute_router" "router" {
  name                          = var.cloud_router_name
  network                       = google_compute_network.network.name
  region = var.subnet_region
  project = var.gcp_project
}

resource "google_compute_router_nat" "main" {
  project                             = var.gcp_project
  region                              = var.subnet_region
  name                                = var.cloud_nat_name
  router                              = google_compute_router.router.name
  nat_ip_allocate_option              = var.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat  = var.source_subnetwork_ip_ranges_to_nat
  subnetwork {
    name = google_compute_subnetwork.subnetwork.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  enable_endpoint_independent_mapping = var.enable_endpoint_independent_mapping
  enable_dynamic_port_allocation      = var.enable_dynamic_port_allocation
  min_ports_per_vm                    = var.min_ports_per_vm
  max_ports_per_vm                    = var.enable_dynamic_port_allocation == true ? var.max_ports_per_vm : null
  tcp_established_idle_timeout_sec    = var.tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec     = var.tcp_transitory_idle_timeout_sec
  tcp_time_wait_timeout_sec           = var.tcp_time_wait_timeout_sec
}
