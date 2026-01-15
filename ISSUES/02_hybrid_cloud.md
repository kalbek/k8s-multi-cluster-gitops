---
title: "Hybrid Cloud: Add AWS/GCP Cluster Support"
labels: ["enhancement", "cloud"]
assignees: []
---

## Problem
Our platform only supports `vCluster` (simulated clusters). To be production-ready, we need to support provisioning real infrastructure on Cloud Providers.

## Proposed Solution
Create a new Crossplane Composition for AWS EKS or GCP GKE.

### Tasks
- [ ] Install `provider-aws` or `provider-gcp` in Crossplane.
- [ ] Configure ProviderConfig with Cloud Credentials.
- [ ] Create a new Composition `eks-cluster` that satisfies the `xkubernetesclusters` XRD.
- [ ] Verify provisioning of a real cloud cluster.
