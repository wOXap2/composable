resource "google_service_account" "sa" {
  account_id   = "${random_string.sa_id.result}-sa"
  display_name = "Service Account - ${random_string.sa_id.result}"
  project      = "woxap2"
}

output "service_account_info" {
  value = {
    account_id   = google_service_account.sa.account_id
    email        = google_service_account.sa.email
    display_name = google_service_account.sa.display_name
  }
}
