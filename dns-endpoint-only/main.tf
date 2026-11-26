resource "google_container_cluster" "example" {
  name     = "example-cluster"
  project  = "example-project"
  location = "europe-west1"

  initial_node_count = 1
  node_config {
    service_account = "nodes@example-project.iam.gserviceaccount.com"
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
  datapath_provider = "ADVANCED_DATAPATH"
  resource_labels = {
    env = "example"
  }
  ip_allocation_policy {}
  private_cluster_config {
    enable_private_nodes = true
  }

  control_plane_endpoints_config {
    dns_endpoint_config {
      allow_external_traffic = true
    }
    ip_endpoints_config {
      enabled = false
    }
  }
}
