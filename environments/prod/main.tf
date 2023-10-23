// providers
terraform {
  backend "gcs" {
    bucket = "terraform-modules-bucket"
    prefix = "prod"
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
module "vpc" {
  source = "../../modules/vpc"
  // VPC
  vpc_name = "${var.env_name}-vpc"
  gcp_project = var.gcp_project
  auto_create_subnetworks = var.vpc["auto_create_subnetworks"]
  network_firewall_policy_enforcement_order = var.vpc["network_firewall_policy_enforcement_order"]
  // SUBNET
  subnet_name = "${var.env_name}-subnet"
  ip_cidr_range = var.subnet["ip_cidr_range"]
  role = var.subnet["role"]
  stack_type = var.subnet["stack_type"]
  subnet_region = var.subnet["subnet_region"]
  // ROUTER & NAT
  cloud_router_name = "${var.env_name}-router"
  cloud_nat_name = "${var.env_name}-nat"
  nat_ip_allocate_option = var.nat["nat_ip_allocate_option"]
  source_subnetwork_ip_ranges_to_nat = var.nat["source_subnetwork_ip_ranges_to_nat"]
  enable_dynamic_port_allocation = var.nat["enable_dynamic_port_allocation"]
  enable_endpoint_independent_mapping = var.nat["enable_endpoint_independent_mapping"]
  min_ports_per_vm = var.nat["min_ports_per_vm"]
  max_ports_per_vm = var.nat["max_ports_per_vm"]
  tcp_established_idle_timeout_sec = var.nat["tcp_established_idle_timeout_sec"]
  tcp_time_wait_timeout_sec = var.nat["tcp_time_wait_timeout_sec"]
  tcp_transitory_idle_timeout_sec = var.nat["tcp_transitory_idle_timeout_sec"]
  // FIREWALL
  firewall_name = "${var.env_name}-firewall"
  ip_address = "34.70.12.107"
}

module "gke" {
  depends_on = [module.vpc]
  // CLUSTER
  source = "../../modules/gke"
  network = module.vpc.network
  subnetwork = module.vpc.subnetwork
  cluster_name = "${var.env_name}-cluster"
  cluster_location = var.cluster["cluster_location"]
  gcp_project = var.gcp_project
  cluster_autoscaler = {
    enabled = var.cluster["cluster_autoscaler"]["enabled"]
    max_cpu = var.cluster["cluster_autoscaler"]["max_cpu"]
    min_cpu = var.cluster["cluster_autoscaler"]["min_cpu"]
    max_mem = var.cluster["cluster_autoscaler"]["max_mem"]
    min_mem = var.cluster["cluster_autoscaler"]["min_mem"]
  }
  kms_key_ring_name = "${var.env_name}-cluster-kms"
  kms_key_name = "${var.env_name}-etcd"
  kms_disk_key_name = "${var.env_name}-disk"
  database_encryption_state = var.cluster["database_encryption_state"]
  private_cluster_config = {
    enable_private_endpoint = var.cluster["private_cluster_config"]["enable_private_endpoint"]
    enable_private_nodes = var.cluster["private_cluster_config"]["enable_private_nodes"]
    master_global_access_config = var.cluster["private_cluster_config"]["master_global_access_config"]
    master_ipv4_cidr_block = var.cluster["private_cluster_config"]["master_ipv4_cidr_block"]
  }
  master_authorized_networks_config = var.cluster["master_authorized_networks_config"]
  enable_tpu = var.cluster["enable_tpu"]
  // NODE POOL
  node_pool_name = "${var.env_name}-node-pool"
  node_autoscaler = {
    enabled = var.node_pool["node_autoscaler"]["enabled"]
    max_count = var.node_pool["node_autoscaler"]["max_count"]
    min_count = var.node_pool["node_autoscaler"]["min_count"]
  }
  kubelet_config = module.gke.kubelet_config
  dns_config = module.gke.dns_config
  node_config = module.gke.node_config

  max_surge = 1
  max_unavailable = 1

  auto_repair = var.node_pool["auto_repair"]
  auto_upgrade = var.node_pool["auto_upgrade"]
}