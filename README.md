# Trivy GCP-0061 on a GKE cluster with IP endpoints disabled

Minimal reproduction for a false positive in Trivy's check
[AVD-GCP-0061](https://avd.aquasec.com/misconfig/google/gke/avd-gcp-0061/) ("Master authorized
networks should be configured on GKE clusters").

`dns-endpoint-only/main.tf` is a GKE cluster whose control plane is reachable only through the
DNS-based endpoint (`ip_endpoints_config.enabled = false`). Master authorized networks restrict IP
endpoints only, and Google documents the DNS-based endpoint, authorized by IAM, as the alternative:

- [About network isolation in GKE](https://cloud.google.com/kubernetes-engine/docs/concepts/network-isolation):
  "Enable authorized networks when using IP-based endpoints"
- [A new DNS-based endpoint for the GKE control plane](https://cloud.google.com/blog/products/containers-kubernetes/new-dns-based-endpoint-for-the-gke-control-plane/)

Trivy reports GCP-0061 for it. `with-empty-block/main.tf` adds an empty
`master_authorized_networks_config {}`, which makes the check pass, although the google provider
does not send that block to GKE while IP endpoints are disabled.

## Run

Requires Docker.

```sh
./repro.sh
```

Output with Trivy 0.76.2:

```
== dns-endpoint-only
Failures: 5 (UNKNOWN: 0, LOW: 2, MEDIUM: 2, HIGH: 1, CRITICAL: 0)
GCP-0061 (HIGH): Cluster does not have master authorized networks enabled.
== with-empty-block
Failures: 4 (UNKNOWN: 0, LOW: 2, MEDIUM: 2, HIGH: 0, CRITICAL: 0)
```
