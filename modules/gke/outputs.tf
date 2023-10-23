output "node_config" {
  description = "Node configuration"
  value = {
    machine_type = "e2-medium"
    image_type = "cos_containerd"
    disk_size_gb = 100
    disk_type = "pd-standard"
  }
}


output "kubelet_config" {
  description = "Kubelet config"
  value = {
    cpu_cfs_quota = true
    cpu_cfs_quota_period = "100us"
    cpu_manager_policy = "static"
    pod_pids_limit = 10000
  }
}

output "dns_config" {
  description = "DNS config"
  value = {
    cluster_dns = "CLOUD_DNS"
    cluster_dns_scope = "CLUSTER_SCOPE"
    cluster_dns_domain = "cluster.local"
  }
}