// providers
#terraform {
#  backend "gcs" {
#    bucket = "terraform-modules-bucket"
#    prefix = "gke"
#    credentials = "C:\\Users\\Alon\\PycharmProjects\\project1\\venv\\terraform-modules\\modules\\key.json"
#  }
#  required_providers {
#    google = {
#      source = "hashicorp/google"
#      version = "4.74.0"
#    }
#  }
#}
#
#provider "google" {
#  credentials = file(var.key_path)
#  project = var.gcp_project
#}

// KMS
resource "google_kms_key_ring" "keyring" {
  name     = var.kms_key_ring_name
  location = "us-central1"
}

resource "google_kms_crypto_key" "key" {
  name            = var.kms_key_name
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "100000s"

}

resource "google_kms_crypto_key" "disk_key" {
  name            = var.kms_disk_key_name
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "100000s"
}

resource "google_project_iam_binding" "gke_sa_decrypt_encrypt" {
  project = var.gcp_project
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:service-227913253615@container-engine-robot.iam.gserviceaccount.com"
  ]
}


// GKE
resource "google_container_cluster" "primary" {
  name = var.cluster_name
  location = var.cluster_location
  project = var.gcp_project
  subnetwork = var.subnetwork
  network = var.network


  remove_default_node_pool = true
  initial_node_count = var.initial_node_count
  private_cluster_config {
    enable_private_endpoint = var.private_cluster_config["enable_private_endpoint"]
    enable_private_nodes = var.private_cluster_config["enable_private_nodes"]
    master_ipv4_cidr_block = var.private_cluster_config["master_ipv4_cidr_block"]
    master_global_access_config {
      enabled = var.private_cluster_config["master_global_access_config"]
    }
  }
  database_encryption {
    state = var.database_encryption_state
    key_name = google_kms_crypto_key.key.id
  }
  networking_mode = var.networking_mode
  ip_allocation_policy {
    cluster_ipv4_cidr_block = "198.16.0.0/16"
    services_ipv4_cidr_block = "192.10.0.0/16"
  }
  enable_tpu = var.enable_tpu

  cluster_autoscaling {
    enabled = var.cluster_autoscaler["enabled"]
    resource_limits {
      resource_type = "cpu"
      maximum = var.cluster_autoscaler["max_cpu"]
      minimum = var.cluster_autoscaler["min_cpu"]
    }
    resource_limits {
      resource_type = "memory"
      maximum = var.cluster_autoscaler["max_mem"]
      minimum = var.cluster_autoscaler["min_mem"]
    }
  }
  dns_config {
    cluster_dns = var.dns_config["cluster_dns"]
    cluster_dns_scope = var.dns_config["cluster_dns_scope"]
    cluster_dns_domain = var.dns_config["cluster_dns_domain"]
  }


  maintenance_policy {
    recurring_window {
      end_time = "2023-07-13T06:00:00Z"
      recurrence = "FREQ=DAILY"
      start_time = "2023-07-13T02:00:00Z"
    }
  }
}

resource "google_container_node_pool" "node_pool" {
  name = var.node_pool_name
  cluster = google_container_cluster.primary.name
  location = var.cluster_location
  autoscaling {
    max_node_count = var.node_autoscaler["enabled"] == true ? var.node_autoscaler["max_count"] : null
    min_node_count = var.node_autoscaler["enabled"] == true ? var.node_autoscaler["min_count"] : null
  }
  management {
    auto_repair = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }
  node_config {
    machine_type = var.node_config["machine_type"]
    image_type = var.node_config["image_type"]
    disk_size_gb = var.node_config["disk_size_gb"]
    disk_type = var.node_config["disk_type"]


    kubelet_config {
      cpu_manager_policy = var.kubelet_config["cpu_manager_policy"]
      cpu_cfs_quota = var.kubelet_config["cpu_cfs_quota"]
      cpu_cfs_quota_period = var.kubelet_config["cpu_cfs_quota_period"]
      pod_pids_limit = var.kubelet_config["pod_pids_limit"]
    }

    linux_node_config {
      sysctls = {
        "net.core.netdev_max_backlog" = "4096"
        "net.core.somaxconn"          = "4096"
        "net.core.rmem_max"           = "16777216"
        "net.core.wmem_max"           = "16777216"
        "net.ipv4.tcp_tw_reuse"       = "1"
        "net.ipv4.tcp_rmem"           = "4096 87380 16777216"
        "net.ipv4.tcp_wmem"           = "4096 65536 16777216"
      }
    }
    boot_disk_kms_key = google_kms_crypto_key.disk_key.id
  }

  upgrade_settings {
    max_surge = var.max_surge
    max_unavailable = var.max_unavailable
  }
}