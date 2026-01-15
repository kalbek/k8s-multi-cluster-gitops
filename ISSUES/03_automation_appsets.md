---
title: "Automation: Implement ArgoCD ApplicationSets"
labels: ["automation", "argocd"]
assignees: []
---

## Problem
Currently, we manually create ArgoCD Applications or rely on the static `app-of-apps`. When a new cluster is added, we have to manually ensure workloads are targeted to it.

## Proposed Solution
Use **ArgoCD ApplicationSets** with the *Cluster Generator* or *Git Generator*.

### Tasks
- [ ] Define an ApplicationSet that watches for new clusters labeled `env=prod`.
- [ ] Automatically deploy a "Base Baseline" (Monitoring, Ingress, Security) to every new cluster.
- [ ] Verify that creating a new `KubernetesCluster` claim triggers this automation.
