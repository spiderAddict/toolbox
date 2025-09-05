#!/bin/bash
# Script d'installation d'un watchdog + alertes mail pour NFS sur OMV
#
# pour tester en simulant une panne :
# sudo systemctl stop nfs-kernel-server
# 
# On doit recevoir deux mails :
# ⚠️ NFS down (alerte du timer)
# ✅ NFS redémarré (ExecStartPost de systemd)

# ==============================
# CONFIG : modifie ton adresse mail ici
EMAIL="ton@email.com"
# ==============================

SERVICE="nfs-kernel-server"
SCRIPT="/usr/local/bin/nfs-alert.sh"
SERVICE_FILE="/etc/systemd/system/nfs-alert.service"
TIMER_FILE="/etc/systemd/system/nfs-alert.timer"
OVERRIDE_DIR="/etc/systemd/system/${SERVICE}.service.d"
OVERRIDE_FILE="$OVERRIDE_DIR/override.conf"

echo "👉 Configuration de la relance automatique du service $SERVICE"
sudo mkdir -p $OVERRIDE_DIR
sudo bash -c "cat > $OVERRIDE_FILE" <<EOF
[Service]
Restart=always
RestartSec=5
ExecStartPost=/bin/bash -c 'echo \"✅ Info : Le service $SERVICE a été redémarré automatiquement sur \$(hostname).\" | mail -s \"[OMV] NFS redémarré sur \$(hostname)\" $EMAIL'
EOF

echo "👉 Création du script d’alerte $SCRIPT"
sudo bash -c "cat > $SCRIPT" <<EOF
#!/bin/bash
SERVICE="$SERVICE"
if ! systemctl is-active --quiet \$SERVICE; then
    echo "⚠️ Alerte : Le service \$SERVICE est tombé sur \$(hostname) !" \
    | mail -s "[OMV] NFS down sur \$(hostname)" $EMAIL
fi
EOF
sudo chmod +x $SCRIPT

echo "👉 Création du service $SERVICE_FILE"
sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Alerte si NFS est down

[Service]
Type=oneshot
ExecStart=$SCRIPT
EOF

echo "👉 Création du timer $TIMER_FILE"
sudo bash -c "cat > $TIMER_FILE" <<EOF
[Unit]
Description=Vérifie régulièrement l’état de NFS

[Timer]
OnBootSec=2min
OnUnitActiveSec=5min
Unit=nfs-alert.service

[Install]
WantedBy=timers.target
EOF

echo "👉 Recharge systemd et active tout"
sudo systemctl daemon-reload
sudo systemctl enable --now nfs-alert.timer
sudo systemctl enable --now $SERVICE

echo "✅ Installation terminée."
echo "ℹ️ Vérifie ton timer avec : systemctl list-timers | grep nfs-alert"
echo "ℹ️ Teste en arrêtant le service avec : sudo systemctl stop $SERVICE"
