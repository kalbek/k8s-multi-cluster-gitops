# Implementation Plan - K8s Multi-Cluster GitOps

## Goal Description
Build an automated management system for multiple Kubernetes clusters using GitOps principles. The system will utilize **Terraform** for base infrastructure, **Crossplane** for declarative infrastructure management from within K8s, and **ArgoCD** for continuous delivery and GitOps.

The setup will demonstrate:
1.  **Management Cluster**: A central K8s cluster running ArgoCD and Crossplane.
2.  **Workload Clusters**: Provisioned and managed by Crossplane (initially using Kind/vCluster for local simulation, or Cloud if credentials provided).
3.  **GitOps Workflow**: ArgoCD watching the repo to sync change to clusters.
4.  **Drift Detection & Auto-healing**: Native capabilities of ArgoCD and Crossplane.

## User Review Required
> [!IMPORTANT]
> **Cloud Provider vs Local Simulation**:
> Do you want to provision REAL cloud clusters (AWS EKS, GKE, etc.) which requires credentials and incurs cost, OR simulate multi-cluster locally using **Kind** (Kubernetes in Docker) or **vCluster**?
> *Defaulting to **Local Simulation (Kind + vCluster)** for this plan to ensure it's runnable without external dependencies.*

## Proposed Architecture

```mermaid
graph TD
    User[DevOps Engineer] -->|Push Code| Git[Git Repository]
    Git -->|Sync| ArgoCD[ArgoCD (Mgmt Cluster)]
    ArgoCD -->|Applies Manifests| MgmtCluster[Management Cluster]
    MgmtCluster -->|Crossplane| Infrastructure[Infrastructure / Clusters]
    
    subgraph Management_Cluster
        ArgoCD
        Crossplane
    end
    
    subgraph Infrastructure
        Cluster1[Workload Cluster 1]
        Cluster2[Workload Cluster 2]
    end
```

## Directory Structure
```
.
├── bootstrap/           # Initial setup scripts/Terraform
├── clusters/            # ArgoCD Application manifests per cluster
├── infrastructure/      # Crossplane XRDs and Compositions
└── apps/                # Workload application manifests
```

## Proposed Changes

### Bootstrap (Terraform)
#### [NEW] `bootstrap/main.tf`
- Provision the Management Cluster (using Kind provider or Cloud).
- Helm install ArgoCD and Crossplane.

### Infrastructure (Crossplane)
#### [NEW] `infrastructure/definition.yaml` (XRD)
- Define a custom API for `KubernetesCluster`.

#### [NEW] `infrastructure/composition.yaml`
- Define how `KubernetesCluster` translates to actual resources (e.g., Helm release of vCluster, or CAPI, or Cloud K8s).

### GitOps (ArgoCD)
#### [NEW] `clusters/management/app-of-apps.yaml`
- The Root ArgoCD application pattern to manage everything else.

## Verification Plan

### Automated Tests
- `kubectl get clusters` - verify Crossplane provisioned clusters.
- `argocd app list` - verify sync status.

### Manual Verification
- **Drift Detection**: Manually delete a resource in a workload cluster, watch Crossplane/ArgoCD recreate it.
- **Auto-healing**: Kill a node or pod (simulated) and observe recovery.
