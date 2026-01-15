# ☸️ Kubernetes Multi-Cluster GitOps

![Kubernetes Multi-Cluster GitOps Banner](./tooling_architecture.png)

> **Automated management of multiple Kubernetes clusters using ArgoCD and Crossplane.**

This project demonstrates a robust **GitOps** platform capable of provisioning, managing, and healing Kubernetes clusters and workloads. It leverages **Crossplane** for declarative infrastructure-as-code (IoC) from within Kubernetes, and **ArgoCD** for continuous delivery and drift detection.

## 🚀 Project Goals

1.  **Centralized Management**: A single "Management Cluster" that oversees the lifecycle of other "Workload Clusters".
2.  **GitOps Principle**: The entire state of the infrastructure is defined in Git. Changes are applied automatically via ArgoCD.
3.  **Self-Healing**: If a cluster or resource is manually deleted or modified, the system automatically restores it to the desired state.
4.  **No Cloud Costs Required**: Uses **Kind** and **vCluster** to simulate a multi-cluster environment locally on your machine.

---

## 🏗️ Architecture

```mermaid
graph TD
    User([👷 DevOps Engineer]) -->|Push Code| Git[📂 Git Repository]
    Git -->|Sync| ArgoCD[🐙 ArgoCD]
    
    subgraph "Management Cluster (Kind)"
        ArgoCD -->|Applies Manifests| K8sAPI[K8s API]
        K8sAPI -->|Manage Resources| XP[✈️ Crossplane]
    end
    
    XP -->|Provisions| VC1[Cluster A (vCluster)]
    XP -->|Provisions| VC2[Cluster B (vCluster)]
    
    classDef tool fill:#f9f,stroke:#333,stroke-width:2px;
    class ArgoCD,XP tool
```

---

## 🛠️ Tech Stack

-   **Kubernetes (Kind)**: Local cluster runtime.
-   **ArgoCD**: GitOps continuous delivery tool.
-   **Crossplane**: Universal control plane for infrastructure.
-   **Terraform**: Initial bootstrap (optional, can be fully Helm-based).
-   **vCluster**: Virtual Kubernetes clusters for simulating multi-cluster topology.

---


![Tooling Architecture](./tooling_architecture.png)

## 📂 Directory Structure

| Path | Description |
| :--- | :--- |
| `bootstrap/` | Terraform & Scripts to spin up the Management Cluster. |
| `infrastructure/` | Crossplane definitions (XRDs) and Compositions. |
| `clusters/` | ArgoCD Application manifests (Cluster configuration). |
| `apps/` | Sample workloads deployed to the clusters. |

---

## 👣 Step-by-Step Setup

### Prerequisites
-   [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Running)
-   [Kind](https://kind.sigs.k8s.io/)
-   [Terraform](https://www.terraform.io/)
-   [Helm](https://helm.sh/)
-   [kubectl](https://kubernetes.io/docs/tasks/tools/)

### 1. Bootstrap Management Cluster
We start by creating the main control plane cluster.

```bash
# Enter bootstrap directory
cd bootstrap

# Initialize and Apply Terraform (or run script)
terraform init
terraform apply
```

*This will create a Kind cluster named `management-cluster` and install ArgoCD + Crossplane.*

### 2. Configure GitOps
Once the cluster is ready, we apply the "App of Apps" pattern to let ArgoCD take over.

kubectl apply -f clusters/management/app-of-apps.yaml
```

### 3. Access ArgoCD UI
To access the ArgoCD dashboard:

1.  **Port-forward the service**:
    ```bash
    kubectl port-forward svc/argocd-server -n argocd 8080:443
    ```
    Open [https://localhost:8080](https://localhost:8080) in your browser.

2.  **Login Credentials**:
    -   **Username**: `admin`
    -   **Password**:
        ```bash
        kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
        ```

### 5. Provision a New Cluster
To create a new workload cluster, apply a claim file:

```yaml
# infrastructure/claim.yaml
apiVersion: infrastructure.example.org/v1alpha1
kind: KubernetesCluster
metadata:
  name: dev-cluster-1
  namespace: default
spec:
  parameters:
    nodeCount: 1
    version: "v1.27.3"
```

Run the command:
```bash
kubectl apply -f infrastructure/claim.yaml
```

Check the status:
```bash
kubectl get kubernetescluster
```
Crossplane will now spin up a vCluster automatically!

---

## 🧪 Verification

-   **Check Clusters**: `kubectl get kubernetescluster`
-   **Check ArgoCD**: Port-forward to access UI: `kubectl port-forward svc/argocd-server -n argocd 8080:443`
-   **Test Auto-healing**: Try deleting a vCluster pod manually and watch it come back!

---

## 🤝 Contributing
Issues and Pull Requests are welcome!
