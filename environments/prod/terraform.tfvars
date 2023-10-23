env_name = "prod"
// VPC
vpc = {
  auto_create_subnetworks = false
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
}
// SUBNET
subnet = {
  ip_cidr_range = "172.16.0.0/12"
  role = "ACTIVE"
  stack_type = "IPV4_ONLY"
  subnet_region = "us-central1"
}
// NAT
nat = {
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  enable_dynamic_port_allocation = true
  enable_endpoint_independent_mapping = false
  min_ports_per_vm = 32
  max_ports_per_vm = 64
  tcp_established_idle_timeout_sec = 1200
  tcp_time_wait_timeout_sec = 120
  tcp_transitory_idle_timeout_sec = 45
}

// CLUSTER
cluster = {
  cluster_location = "us-central1"
  cluster_autoscaler = {
    enabled = true
    max_cpu = 24
    min_cpu = 1
    max_mem = 24
    min_mem = 1
  }
  database_encryption_state = "ENCRYPTED"
  private_cluster_config = {
       enable_private_endpoint = false
       enable_private_nodes = true
       master_global_access_config = true
       master_ipv4_cidr_block = "170.16.0.32/28"
  }
  enable_tpu = true
  master_authorized_networks_config = {
    cidr_blocks = "172.16.0.0/12"
  }
}

// NODE POOL
node_pool = {
  node_autoscaler = {
    enabled = true
    max_count = 5
    min_count = 1
  }
  auto_repair = true
  auto_upgrade = true
}