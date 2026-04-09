#!/usr/bin/env bash
# CKA Practice: Troubleshooting Cheatsheet
# 30% of the exam — most important section!
# ─────────────────────────────────────────────────────────

# ════════════════════════════════════════════════════════════
# 1. APPLICATION FAILURES
# ════════════════════════════════════════════════════════════
echo "--- Pod not starting ---"
kubectl get pods -A                            # find the troubled pod
kubectl describe pod <pod> -n <ns>             # check Events section
kubectl logs <pod> -n <ns>                     # check logs
kubectl logs <pod> -n <ns> --previous          # logs from crashed container
kubectl logs <pod> -n <ns> -c <container>      # multi-container pod
kubectl get events -n <ns> --sort-by=.lastTimestamp

echo "--- Pod stuck in Pending ---"
# Check: resource limits, node affinity, taints, PVC pending

echo "--- Pod CrashLoopBackOff ---"
# Check: app error in logs, wrong command/args, missing configmap/secret

echo "--- Service not reachable ---"
kubectl get svc <svc>                          # check port/targetPort
kubectl get endpoints <svc>                    # must show pod IPs; empty = selector mismatch
kubectl describe svc <svc>                     # check selector labels
kubectl get pods --show-labels                 # verify pod labels match selector

# Test connectivity from inside cluster:
kubectl run test --image=busybox --rm -it -- wget -qO- http://<svc>.<ns>.svc.cluster.local:<port>

# ════════════════════════════════════════════════════════════
# 2. CONTROL PLANE FAILURES
# ════════════════════════════════════════════════════════════
echo "--- Control plane down ---"
kubectl get componentstatuses               # deprecated but useful
kubectl get pods -n kube-system            # check api-server, etcd, scheduler, controller-manager
kubectl describe pod kube-apiserver-controlplane -n kube-system

# Static pods live here — edit to fix:
ls /etc/kubernetes/manifests/
# kube-apiserver.yaml  kube-controller-manager.yaml  kube-scheduler.yaml  etcd.yaml

# Check service logs (if not static pod):
journalctl -u kube-apiserver -n 50
journalctl -u kube-scheduler -n 50

# ════════════════════════════════════════════════════════════
# 3. WORKER NODE FAILURES
# ════════════════════════════════════════════════════════════
echo "--- Node NotReady ---"
kubectl get nodes
kubectl describe node <node>               # check Conditions section

# SSH to the worker node:
systemctl status kubelet
journalctl -u kubelet -n 100              # check kubelet logs
systemctl restart kubelet                 # try restarting
systemctl enable kubelet

# Common causes:
# - kubelet service stopped
# - Wrong --config or --kubeconfig path
# - Certificate expired
# - Disk/memory pressure

# ════════════════════════════════════════════════════════════
# 4. NETWORK TROUBLESHOOTING
# ════════════════════════════════════════════════════════════
echo "--- DNS not resolving ---"
kubectl run dns-test --image=busybox --rm -it -- nslookup kubernetes
kubectl get pods -n kube-system | grep coredns
kubectl logs -n kube-system -l k8s-app=kube-dns

echo "--- Network policy blocking traffic ---"
kubectl get networkpolicies -A
kubectl describe networkpolicy <name> -n <ns>

# ════════════════════════════════════════════════════════════
# 5. USEFUL QUICK COMMANDS
# ════════════════════════════════════════════════════════════
# Check all failing pods across cluster:
kubectl get pods -A --field-selector=status.phase!=Running

# Edit a running resource:
kubectl edit pod <pod>
kubectl edit deployment <deploy>

# Force delete a stuck pod:
kubectl delete pod <pod> --force --grace-period=0

# Copy files to/from pod:
kubectl cp <pod>:/path/to/file ./local-file
kubectl cp ./local-file <pod>:/path/to/file

# Port-forward for testing:
kubectl port-forward pod/<pod> 8080:80
kubectl port-forward svc/<svc> 8080:80
