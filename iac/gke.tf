module "gke_cluster" {
  source = "../modules/gke"

  project_id            = var.project_id
  region                = var.region
  cluster_name          = var.cluster_name
  subnet_name           = google_compute_network.vpc.name
  service_account_email = google_service_account.sa.email

  initial_node_count   = var.initial_node_count
  node_pool_name       = var.node_pool_name
  node_pool_node_count = var.node_pool_node_count
  machine_type         = var.machine_type
  disk_size_gb         = var.disk_size_gb
}
