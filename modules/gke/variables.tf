variable "project_id" {
  description = "The GCP project ID"
}

variable "region" {
  description = "The GCP region for the GKE cluster"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
}

variable "subnet_name" {
  description = "The name of the subnet within the VPC"
}

variable "service_account_email" {
  description = "The email address of the Service Account used for GKE nodes"
}

variable "node_pool_name" {
  description = "The name of the node pool"
  default     = "default-pool"
}

variable "machine_type" {
  description = "The machine type for nodes in the node pool"
  default     = "n1-standard-2"
}

variable "disk_size_gb" {
  description = "The disk size for nodes in the node pool"
  default     = 100
}

variable "initial_node_count" {
  description = "The initial number of nodes in the node pool"
  default     = 1
}

variable "node_pool_node_count" {
  description = "The number of nodes in the node pool"
  default     = 1
}
