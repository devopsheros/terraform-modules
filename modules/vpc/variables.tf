//GCP
variable "key_path" {
  type = string
  default = "C:\\Users\\Alon\\PycharmProjects\\project1\\venv\\terraform-modules\\modules\\key.json"
}

// VPC
variable "vpc_name" {
  type = string
}

variable "gcp_project" {
  type = string
}

variable "auto_create_subnetworks" {
  type = bool
}

variable "network_firewall_policy_enforcement_order" {
  type = string
}

// SUBNET
variable "subnet_name" {
  type = string
}

variable "ip_cidr_range" {
  type = string
}

variable "role" {
  type = string
}

variable "subnet_region" {
  type = string
}

variable "stack_type" {
  type = string
}

// ROUTER & NAT
variable "cloud_router_name" {
  type = string
}

variable "cloud_nat_name" {
  type = string
}

variable "nat_ip_allocate_option" {
  type = string
}

variable "source_subnetwork_ip_ranges_to_nat" {
  type = string
}

variable "enable_dynamic_port_allocation" {
  type = bool
}

variable "enable_endpoint_independent_mapping" {
  type = bool
}

variable "min_ports_per_vm" {
  type = number
}

variable "max_ports_per_vm" {
  type = number
}

variable "tcp_established_idle_timeout_sec" {
  type = number
}

variable "tcp_time_wait_timeout_sec" {
  type = number
}

variable "tcp_transitory_idle_timeout_sec" {
  type = number
}

// FIREWALL
variable "firewall_name" {
  type = string
}

variable "ip_address" {
  type = string
}

