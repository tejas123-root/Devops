#!/usr/bin/env bash
# CKA Practice: etcd Backup and Restore
# This is one of the MOST commonly tested topics in CKA!
# ─────────────────────────────────────────────────────────

# Find etcd certs (usually on control-plane node)
ETCD_CERT="/etc/kubernetes/pki/etcd/server.crt"
ETCD_KEY="/etc/kubernetes/pki/etcd/server.key"
ETCD_CA="/etc/kubernetes/pki/etcd/ca.crt"
ETCD_ENDPOINT="https://127.0.0.1:2379"
BACKUP_FILE="/opt/etcd-backup.db"

# ── Step 1: Take a snapshot backup ────────────────────────
echo "Taking etcd snapshot backup..."
ETCDCTL_API=3 etcdctl snapshot save "$BACKUP_FILE" \
  --endpoints="$ETCD_ENDPOINT" \
  --cacert="$ETCD_CA" \
  --cert="$ETCD_CERT" \
  --key="$ETCD_KEY"

# ── Step 2: Verify snapshot ───────────────────────────────
echo "Verifying snapshot..."
ETCDCTL_API=3 etcdctl snapshot status "$BACKUP_FILE" \
  --write-out=table

# ── Step 3: Restore from snapshot ────────────────────────
# (Run on the control-plane node)
RESTORE_DIR="/var/lib/etcd-restore"

echo "Restoring etcd from snapshot..."
ETCDCTL_API=3 etcdctl snapshot restore "$BACKUP_FILE" \
  --data-dir="$RESTORE_DIR"

# ── Step 4: Update etcd static pod to use new data dir ───
# Edit /etc/kubernetes/manifests/etcd.yaml:
# Change: --data-dir=/var/lib/etcd
# To:     --data-dir=/var/lib/etcd-restore
# Also update volumes and volumeMounts hostPath accordingly

echo "Update /etc/kubernetes/manifests/etcd.yaml:"
echo "  --data-dir=$RESTORE_DIR"
echo "  volumes.hostPath.path=$RESTORE_DIR"
echo ""
echo "etcd pod will restart automatically."
echo "Wait: kubectl get pods -n kube-system | grep etcd"

# ── Quick exam reference ──────────────────────────────────
# Check etcd version:
#   kubectl exec -it etcd-controlplane -n kube-system -- etcdctl version
# Find etcd endpoints from pod:
#   kubectl describe pod etcd-controlplane -n kube-system | grep listen-client
