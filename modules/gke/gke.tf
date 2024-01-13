resource "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  remove_default_node_pool = true
  deletion_protection      = false
  initial_node_count       = var.initial_node_count
}

resource "google_container_node_pool" "gke_node_pool" {
  name       = var.node_pool_name
  location   = var.region
  cluster    = google_container_cluster.gke_cluster.name
  node_count = var.node_pool_node_count

  node_config {
    preemptible  = false
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
