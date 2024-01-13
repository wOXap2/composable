provider "google" {
  project = "woxap2"
  region  = "us-east"
  zone    = "us-east1-b"
}

resource "random_string" "vpc_id" {
  length  = 8
  special = false
  upper   = false
  number  = false
}

resource "random_string" "sa_id" {
  length  = 8
  special = false
  upper   = false
  number  = false
}
