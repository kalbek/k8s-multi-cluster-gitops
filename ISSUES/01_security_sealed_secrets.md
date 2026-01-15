---
title: "Security: Implement Sealed Secrets or External Secrets"
labels: ["security", "enhancement"]
assignees: []
---

## Problem
Currently, our GitOps repository stores raw Kubernetes Secrets (or relies on them being manually created). This is a security risk if the repo is public or accessible to non-admins.

## Proposed Solution
Implement **Bitnami Sealed Secrets** or **External Secrets Operator**.

### Tasks
- [ ] Install Sealed Secrets Controller in `management-cluster`.
- [ ] Install `kubeseal` CLI locally.
- [ ] Encrypt the `argocd-initial-admin-secret` and `repo-creds` as a test.
- [ ] Update documentation on how to seal new secrets.
