resource "google_compute_network" "vpc" {
  name                    = random_string.vpc_id.result
  auto_create_subnetworks = true
}

