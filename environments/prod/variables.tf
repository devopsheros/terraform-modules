//GCP
variable "key_path" {
  type = string
  default = "C:\\Users\\Alon\\PycharmProjects\\project1\\venv\\terraform-modules\\modules\\key.json"
}

variable "gcp_project_number" {
  type = string
  default = "227913253615"
}

variable "gcp_project" {
  type = string
  default = "devops-project-387209"
}

variable "env_name" {
  type = string
}

variable "vpc" {
  type = object({
    auto_create_subnetworks = bool
    network_firewall_policy_enforcement_order = string
  })
}

variable "subnet" {
  type = object({
    ip_cidr_range = string
    role = string
    stack_type = string
    subnet_region = string
  })
}

variable "nat" {
  type = object({
    nat_ip_allocate_option = string
    source_subnetwork_ip_ranges_to_nat = string
    enable_dynamic_port_allocation = bool
    enable_endpoint_independent_mapping = bool
    min_ports_per_vm = number
    max_ports_per_vm = number
    tcp_established_idle_timeout_sec = number
    tcp_time_wait_timeout_sec = number
    tcp_transitory_idle_timeout_sec = number
  })
}

variable "cluster" {
  type = object({
    cluster_location = string
    cluster_autoscaler = object({
      enabled = bool
      max_cpu = number
      min_cpu = number
      max_mem = number
      min_mem = number
    })
    database_encryption_state = string
    private_cluster_config = object({
       enable_private_endpoint = bool
       enable_private_nodes = bool
       master_global_access_config = bool
       master_ipv4_cidr_block = string
    })
    enable_tpu = bool
    master_authorized_networks_config = object({
      cidr_blocks = string
    })
  })
}

variable "node_pool" {
  type = object({
    node_autoscaler = object({
      enabled = bool
      max_count = number
      min_count = number
    })
    auto_repair = bool
    auto_upgrade = bool
  })
}