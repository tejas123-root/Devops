#!/usr/bin/env bash
# CKA Practice: Cluster Upgrade with kubeadm
# Upgrade path: one minor version at a time (e.g., 1.27 → 1.28)
# ─────────────────────────────────────────────────────────────

TARGET_VERSION="1.29.0-00"   # change to target version

# ════════════════════════════════════════════════════════════
# CONTROL PLANE NODE
# ════════════════════════════════════════════════════════════

echo "=== STEP 1: Upgrade kubeadm on control plane ==="
apt-mark unhold kubeadm
apt-get update -y
apt-get install -y kubeadm="$TARGET_VERSION"
apt-mark hold kubeadm
kubeadm version

echo "=== STEP 2: Verify upgrade plan ==="
kubeadm upgrade plan

echo "=== STEP 3: Apply upgrade ==="
kubeadm upgrade apply v${TARGET_VERSION%-*}  # strips the '-00' suffix

echo "=== STEP 4: Drain control plane node ==="
kubectl drain controlplane --ignore-daemonsets --delete-emptydir-data

echo "=== STEP 5: Upgrade kubelet and kubectl on control plane ==="
apt-mark unhold kubelet kubectl
apt-get install -y kubelet="$TARGET_VERSION" kubectl="$TARGET_VERSION"
apt-mark hold kubelet kubectl

echo "=== STEP 6: Restart kubelet ==="
systemctl daemon-reload
systemctl restart kubelet

echo "=== STEP 7: Uncordon control plane ==="
kubectl uncordon controlplane

# ════════════════════════════════════════════════════════════
# WORKER NODE (run steps below ON THE WORKER NODE)
# ════════════════════════════════════════════════════════════

echo ""
echo "=== On control plane: Drain worker node ==="
echo "kubectl drain node01 --ignore-daemonsets --delete-emptydir-data"

echo ""
echo "=== SSH to worker node, then run: ==="
cat <<'WORKER'
apt-mark unhold kubeadm kubelet kubectl
apt-get update -y
apt-get install -y kubeadm=<TARGET_VERSION> kubelet=<TARGET_VERSION> kubectl=<TARGET_VERSION>
apt-mark hold kubeadm kubelet kubectl
kubeadm upgrade node
systemctl daemon-reload
systemctl restart kubelet
WORKER

echo ""
echo "=== Back on control plane: Uncordon worker ==="
echo "kubectl uncordon node01"

echo ""
echo "=== Verify cluster ==="
echo "kubectl get nodes"
