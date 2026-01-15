---
title: "Observability: Add Prometheus/Grafana Stack"
labels: ["observability", "enhancement"]
assignees: []
---

## Problem
We have no visibility into the health or performance of our clusters or the applications running on them.

## Proposed Solution
Deploy the **Kube Prometheus Stack** to the Management Cluster and potentially to Child Clusters (using the Automation from Issue #3).

### Tasks
- [ ] Install `kube-prometheus-stack` via Helm.
- [ ] Configure Grafana Dashboards for ArgoCD and Crossplane metrics.
- [ ] (Advanced) Configure Thanos for multi-cluster metrics aggregation.
