# CKA Exam Preparation Guide

## Exam Overview
- **Duration**: 2 hours
- **Format**: Performance-based (hands-on terminal tasks)
- **Passing Score**: 66%
- **Cost**: $395 USD
- **Kubernetes Version**: Check https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/
- **Allowed**: One tab open to https://kubernetes.io/docs during exam

---

## Exam Domain Weights (2024)

| Domain                              | Weight |
|-------------------------------------|--------|
| Cluster Architecture, Installation & Configuration | 25% |
| Workloads & Scheduling              | 15%    |
| Services & Networking               | 20%    |
| Storage                             | 10%    |
| Troubleshooting                     | 30%    |

---

## Study Path (8-Week Plan)

### Week 1-2: Core Concepts
- Kubernetes architecture (API server, etcd, scheduler, controller-manager, kubelet, kube-proxy)
- Pods, ReplicaSets, Deployments
- Namespaces, Labels, Selectors
- kubectl basics

### Week 3: Workloads & Scheduling
- DaemonSets, StatefulSets, Jobs, CronJobs
- Resource requests & limits
- Node affinity, taints & tolerations
- Pod priority & preemption

### Week 4: Services & Networking
- ClusterIP, NodePort, LoadBalancer, ExternalName
- Ingress & IngressController
- CoreDNS
- Network Policies

### Week 5: Storage
- PersistentVolumes (PV) & PersistentVolumeClaims (PVC)
- StorageClasses
- ConfigMaps & Secrets
- Volume types (emptyDir, hostPath, NFS)

### Week 6: Security
- RBAC (Roles, ClusterRoles, Bindings)
- ServiceAccounts
- NetworkPolicies
- Pod Security Admission
- TLS certificates

### Week 7: Cluster Maintenance & Installation
- kubeadm cluster setup
- etcd backup & restore
- Cluster upgrade
- Node drain/cordon

### Week 8: Troubleshooting + Mock Exams
- Application failures
- Control plane failures
- Worker node failures
- Network troubleshooting

---

## Essential kubectl Commands

```bash
# Shortcuts - set these at exam start!
alias k=kubectl
export do="--dry-run=client -o yaml"
export now="--force --grace-period=0"

# Generate YAML without applying
k run nginx --image=nginx $do > pod.yaml
k create deployment myapp --image=nginx --replicas=3 $do > deploy.yaml
k create service clusterip mysvc --tcp=80:80 $do > svc.yaml

# Quick resource operations
k get all -n <namespace>
k describe pod <name>
k logs <pod> -c <container>
k exec -it <pod> -- /bin/bash
k top nodes / k top pods

# Apply changes
k apply -f file.yaml
k replace --force -f file.yaml   # recreate

# Scale & rollout
k scale deployment myapp --replicas=5
k rollout status deployment/myapp
k rollout undo deployment/myapp
k rollout history deployment/myapp

# Config
k config get-contexts
k config use-context <name>
k config set-context --current --namespace=<ns>
```

---

## Free Resources

| Resource | Link |
|----------|------|
| Official Docs | https://kubernetes.io/docs |
| Killer.sh (2 mock exams included with registration) | https://killer.sh |
| KodeKloud CKA Course | https://kodekloud.com |
| Mumshad Mannambeth Udemy Course | Search "CKA Udemy" |
| CKA GitHub Study Guide | https://github.com/walidshaari/Kubernetes-Certified-Administrator |

---

## Exam Tips
1. **Speed matters** - practice until `kubectl` commands are muscle memory
2. **Use imperative commands** to generate YAML, edit, then apply
3. **Read questions carefully** - check namespace, context switches
4. **Set context at start of each question**: `kubectl config use-context <ctx>`
5. **Use `--help`** liberally: `k run --help`, `k create --help`
6. **Bookmark key docs pages** before the exam
7. **etcd backup** - always a question: practice `etcdctl snapshot save`
8. **Don't get stuck** - flag hard questions, move on, come back
