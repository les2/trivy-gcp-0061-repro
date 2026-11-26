resource "google_container_cluster" "example" {
  name     = "example-cluster"
  project  = "example-project"
  location = "europe-west1"

  enable_autopilot = true

  control_plane_endpoints_config {
    dns_endpoint_config {
      allow_external_traffic = true
    }
    ip_endpoints_config {
      enabled = false
    }
  }

  master_authorized_networks_config {}
}
