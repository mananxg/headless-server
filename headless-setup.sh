#!/bin/bash
# ===========================================
# Headless Proxmox Laptop Setup Script
# - ACPI / lid / suspend / hibernate ignores
# - NIC power persistence
# - Dummy HDMI placeholder setup (if needed)
# ===========================================

# 1️⃣ Backup original logind.conf
cp /etc/systemd/logind.conf /etc/systemd/logind.conf.bak

# 2️⃣ Configure logind for headless operation
cat > /etc/systemd/logind.conf <<EOF
[Login]
# Ignore suspend, hibernate, and lid events
HandleSuspendKey=ignore
HandleHibernateKey=ignore
HandleLidSwitch=ignore
HandleLidSwitchDocked=ignore
IdleAction=ignore

# Keep power button functional for manual reboot
PowerKeyIgnoreInhibited=no
SuspendKeyIgnoreInhibited=no
HibernateKeyIgnoreInhibited=no
LidSwitchIgnoreInhibited=no
EOF

# Apply logind changes
systemctl restart systemd-logind

# Mask sleep/suspend/hibernate targets to prevent accidental sleep
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# 3️⃣ Create NIC power persistence service
cat > /etc/systemd/system/nic-power-fix.service <<EOF
[Unit]
Description=Disable NIC power saving for headless operation
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/ethtool -s enp2s0 wol d
ExecStart=/bin/sh -c 'echo on > /sys/class/net/enp2s0/device/power/control'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable NIC service
systemctl daemon-reload
systemctl enable nic-power-fix.service
systemctl start nic-power-fix.service

# 4️⃣ Dummy HDMI note (physical plug-in required)
echo "✅ If you want fully headless GPU/display, plug in a dummy HDMI adapter now."

# 5️⃣ Optional: verify network and logind
echo "------------------------------------"
echo "Network interfaces:"
ip a
echo "------------------------------------"
echo "Systemd-logind status:"
systemctl status systemd-logind | head -n 10
echo "------------------------------------"
echo "NIC power persistence status:"
systemctl status nic-power-fix.service | head -n 10
echo "------------------------------------"
echo "✅ Headless setup applied! Reboot your laptop to test fully headless operation."
