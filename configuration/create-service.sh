#!/bin/bash

set -e

PROJECT_DIR="/home/ubuntu/CCTV-Attendance-System"

echo "Membuat Python Service..."

cat > /etc/systemd/system/cctv-python.service <<EOF
[Unit]
Description=CCTV Attendance Python
After=network.target mariadb.service
Requires=mariadb.service

[Service]
Type=simple
User=ubuntu
WorkingDirectory=$PROJECT_DIR

ExecStart=$PROJECT_DIR/venv/bin/python python/realtime.py

Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "Membuat Laravel Service..."

cat > /etc/systemd/system/cctv-laravel.service <<EOF
[Unit]
Description=CCTV Attendance Laravel
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=$PROJECT_DIR/laravel

ExecStart=/usr/bin/php8.4 artisan serve --host=0.0.0.0 --port=8000

Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

systemctl enable cctv-python.service
systemctl enable cctv-laravel.service

echo "Python dan Laravel service berhasil dibuat!"
