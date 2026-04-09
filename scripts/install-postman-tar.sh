#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
# install-postman-tar.sh
# Installs Postman on Linux by downloading the official tar.gz
# Works on Ubuntu / Debian / RHEL / Fedora / CentOS
# ─────────────────────────────────────────────────────────────────
set -euo pipefail

POSTMAN_URL="https://dl.pstmn.io/download/latest/linux64"
INSTALL_DIR="/opt/Postman"
TEMP_DIR="$(mktemp -d)"
DESKTOP_FILE="/usr/share/applications/postman.desktop"

cleanup() {
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

echo "──────────────────────────────────────────"
echo "  Postman Installation Script (tar.gz)    "
echo "──────────────────────────────────────────"

# ── Check dependencies ────────────────────────────────────────────
echo "[1/5] Checking dependencies..."
for cmd in curl tar; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "  '$cmd' not found. Installing..."
    sudo apt-get update -y && sudo apt-get install -y "$cmd"
  fi
done
echo "  Dependencies satisfied."

# ── Download Postman ──────────────────────────────────────────────
echo "[2/5] Downloading Postman..."
curl -L --progress-bar "$POSTMAN_URL" -o "$TEMP_DIR/postman-linux.tar.gz"
echo "  Download complete."

# ── Extract archive ───────────────────────────────────────────────
echo "[3/5] Extracting archive..."
tar -xzf "$TEMP_DIR/postman-linux.tar.gz" -C "$TEMP_DIR"
echo "  Extraction complete."

# ── Install to /opt ───────────────────────────────────────────────
echo "[4/5] Installing to $INSTALL_DIR..."
sudo rm -rf "$INSTALL_DIR"
sudo mv "$TEMP_DIR/Postman" "$INSTALL_DIR"

# Create symlink for CLI access
sudo ln -sf "$INSTALL_DIR/Postman" /usr/local/bin/postman
echo "  Installed to $INSTALL_DIR"
echo "  Symlink created: /usr/local/bin/postman"

# ── Create desktop shortcut ───────────────────────────────────────
echo "[5/5] Creating desktop shortcut..."
sudo bash -c "cat > $DESKTOP_FILE" <<EOF
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=$INSTALL_DIR/Postman
Icon=$INSTALL_DIR/app/icons/icon_128x128.png
Terminal=false
Type=Application
Categories=Development;
EOF

echo "  Desktop shortcut created at $DESKTOP_FILE"

echo ""
echo "──────────────────────────────────────────"
echo "  Postman installed successfully!"
echo "  Run with: postman"
echo "  Or launch from Applications menu."
echo "──────────────────────────────────────────"
