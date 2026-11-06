#!/bin/bash

set -e

PROJECT_DIR="/root/CCTV_Attendance_System"

echo "Membuat service CCTV Attendance..."

sudo tee /etc/systemd/system/cctv-attendance.service > /dev/null <<EOF
[Unit]
Description=CCTV Attendance System
After=network.target mariadb.service
Requires=mariadb.service

[Service]
Type=simple
User=root
WorkingDirectory=$PROJECT_DIR

ExecStart=/bin/bash -c 'cd laravel && php artisan serve --host=0.0.0.0 --port=8000 & cd $PROJECT_DIR && venv/bin/python python/realtime.py & wait'

Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

sudo systemctl enable cctv-attendance.service

echo "Service CCTV Attendance berhasil dibuat!"
