# Trivy GCP-0061 on a GKE cluster with IP endpoints disabled

Trivy's check [AVD-GCP-0061](https://avd.aquasec.com/misconfig/google/gke/avd-gcp-0061/)
("Master authorized networks should be configured on GKE clusters") fails on a GKE cluster whose
control plane is reachable only through the DNS-based endpoint (`ip_endpoints_config.enabled =
false`). Master authorized networks restrict IP endpoints only, and Google documents the
DNS-based endpoint, authorized by IAM, as the alternative:

- [About network isolation in GKE](https://cloud.google.com/kubernetes-engine/docs/concepts/network-isolation):
  "Enable authorized networks when using IP-based endpoints"
- [A new DNS-based endpoint for the GKE control plane](https://cloud.google.com/blog/products/containers-kubernetes/new-dns-based-endpoint-for-the-gke-control-plane/)

The two examples differ in one line. Both are written so that GCP-0061 is the only check that can
fail. Requires Docker. Trivy 0.76.2, the official image pinned by digest.

## 1. DNS endpoint only: GCP-0061 fails

[`dns-endpoint-only/main.tf`](dns-endpoint-only/main.tf)

```sh
docker run --rm -v "$PWD/dns-endpoint-only:/src:ro" aquasec/trivy@sha256:8f6bb947dbc528902e11f2f5be52f7b519f6a39d5d148f41166f2040499768fb config /src
```

```
main.tf (terraform)
===================
Tests: 1 (SUCCESSES: 0, FAILURES: 1)
Failures: 1 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 1, CRITICAL: 0)

GCP-0061 (HIGH): Cluster does not have master authorized networks enabled.
```

## 2. Same cluster with an empty `master_authorized_networks_config {}`: GCP-0061 passes

[`with-empty-block/main.tf`](with-empty-block/main.tf)

```sh
docker run --rm -v "$PWD/with-empty-block:/src:ro" aquasec/trivy@sha256:8f6bb947dbc528902e11f2f5be52f7b519f6a39d5d148f41166f2040499768fb config /src
```

```
┌────────┬───────────┬───────────────────┐
│ Target │   Type    │ Misconfigurations │
├────────┼───────────┼───────────────────┤
│ .      │ terraform │         0         │
└────────┴───────────┴───────────────────┘
```

The empty block changes nothing on the cluster: the google provider does not send it to GKE while
IP endpoints are disabled
([GoogleCloudPlatform/magic-modules#20134](https://github.com/GoogleCloudPlatform/magic-modules/pull/20134)).
