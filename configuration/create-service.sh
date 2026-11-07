#!/bin/bash

set -e

# =====================================
# PATH PROJECT
# =====================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
VENV_DIR="$SCRIPT_DIR/venv"
APP_USER="debian"

echo "Membuat Python Service..."

cat > /etc/systemd/system/cctv-python.service <<EOF
[Unit]
Description=CCTV Attendance Python
After=network.target mariadb.service
Requires=mariadb.service

[Service]
Type=simple
User=$APP_USER
Group=$APP_USER
WorkingDirectory=$PROJECT_DIR

ExecStart=$VENV_DIR/bin/python $PROJECT_DIR/python/realtime.py

Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "Membuat Laravel Service..."

cat > /etc/systemd/system/cctv-laravel.service <<EOF
[Unit]
Description=CCTV Attendance Laravel
After=network.target mariadb.service

[Service]
Type=simple
User=$APP_USER
Group=$APP_USER
WorkingDirectory=$PROJECT_DIR/laravel

ExecStart=/usr/bin/php artisan serve --host=0.0.0.0 --port=8000

Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# =====================================
# RELOAD DAN ENABLE SERVICE
# =====================================
systemctl daemon-reload

systemctl enable cctv-python.service
systemctl enable cctv-laravel.service

systemctl restart cctv-python.service
systemctl restart cctv-laravel.service

echo "Python dan Laravel service berhasil dibuat!"
