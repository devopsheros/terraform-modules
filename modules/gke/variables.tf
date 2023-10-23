// GKE
variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "gcp_project" {
 type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_location" {
  type = string
}

variable "initial_node_count" {
  type = number
  default = 1
}

variable "cluster_autoscaler" {
  type = object({
    enabled = bool
    max_cpu = number
    min_cpu = number
    max_mem = number
    min_mem = number
  })
}

variable "kms_key_ring_name"{
  type = string
}

variable "kms_key_name" {
  type = string
}

variable "kms_disk_key_name" {
  type = string
}

variable "database_encryption_state" {
  type = string
}

variable "private_cluster_config" {
  type = object({
    enable_private_endpoint = bool
    enable_private_nodes = bool
    master_global_access_config = bool
    master_ipv4_cidr_block = string
  })
}

variable "enable_tpu" {
  type = bool
}

variable "kubelet_config" {
  type = object({
    cpu_cfs_quota = bool
    cpu_cfs_quota_period = string
    cpu_manager_policy = string
    pod_pids_limit = number
  })
}

variable "dns_config" {
  type = object({
    cluster_dns = string
    cluster_dns_scope = string
    cluster_dns_domain = string
  })
}

variable "master_authorized_networks_config" {
  type = object({
    cidr_blocks = string
  })
}

variable "networking_mode" {
  type = string
  default = "VPC_NATIVE"
}

// NODE POOL
variable "node_pool_name" {
  type = string
}

variable "node_autoscaler" {
  type = object({
    enabled = bool
    max_count = number
    min_count = number
  })
}

variable "auto_repair" {
  type = bool
}

variable "auto_upgrade" {
  type = bool
}

variable "node_config" {
  type = object({
    machine_type = string
    image_type = string
    disk_size_gb = number
    disk_type = string
  })
}

variable "max_surge" {
  type = number
}

variable "max_unavailable" {
  type = number
}
