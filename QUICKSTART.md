# ⚡ Quick Start Guide

Get the K8s Multi-Cluster GitOps platform running in under 10 minutes.

## Prerequisites
Ensure you have these installed:
- Docker Desktop (running)
- kubectl
- Helm
- Terraform

## 1. Bootstrap the Management Cluster

```bash
cd bootstrap
terraform init
terraform apply -auto-approve
```

This creates a Kind cluster and installs ArgoCD + Crossplane.

## 2. Apply Crossplane Configuration

```bash
cd ..
kubectl apply -f infrastructure/providers.yaml
kubectl apply -f infrastructure/definition.yaml
kubectl apply -f infrastructure/composition.yaml
```

## 3. Configure GitOps

Update `clusters/management/app-of-apps.yaml` with your GitHub repo URL, then:

```bash
kubectl apply -f clusters/management/app-of-apps.yaml
```

## 4. Access ArgoCD

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

**Login**: https://localhost:8080
- Username: `admin`
- Password: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

## 5. Deploy a Test Cluster

```bash
kubectl apply -f infrastructure/claim.yaml
kubectl get kubernetescluster -w
```

## 🎯 Next Steps
- See [README.md](./README.md) for full documentation
- Check [walkthrough.md](./walkthrough.md) for the Mission Pack
- Review [ISSUES/](./ISSUES/) for Day 2 operations roadmap
