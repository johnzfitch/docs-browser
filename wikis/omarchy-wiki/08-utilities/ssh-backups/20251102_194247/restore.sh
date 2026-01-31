#!/bin/bash
# Restore SSH configuration from this backup

BACKUP_DIR="$(dirname "$0")"

echo "🔄 Restoring SSH configuration from backup..."

# Remove immutable flag if set
sudo chattr -i /etc/ssh/sshd_config.d/50-performance.conf 2>/dev/null

# Restore sshd config
echo "  • Restoring /etc/ssh/sshd_config..."
sudo cp "$BACKUP_DIR/sshd_config.backup" /etc/ssh/sshd_config

echo "  • Restoring /etc/ssh/sshd_config.d/..."
sudo rm -rf /etc/ssh/sshd_config.d
sudo cp -r "$BACKUP_DIR/sshd_config.d.backup" /etc/ssh/sshd_config.d

# Remove performance config
sudo rm -f /etc/ssh/sshd_config.d/50-performance.conf

# Restart SSH
if systemctl is-active --quiet sshd; then
    echo "  • Restarting SSH service..."
    sudo systemctl restart sshd
fi

echo "✅ Restore complete!"
echo ""
echo "NOTE: Network settings require reboot to fully restore"
