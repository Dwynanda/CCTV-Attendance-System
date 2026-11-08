#!/bin/bash

set -e

# =====================================
# PATH PROJECT
# =====================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
VENV_DIR="$PROJECT_DIR/venv"
APP_USER="debian"

PYTHON_FILE="$PROJECT_DIR/python/realtime.py"
LARAVEL_DIR="$PROJECT_DIR/laravel"

# =====================================
# CEK ROOT
# =====================================
if [ "$EUID" -ne 0 ]; then
    echo "Jalankan menggunakan sudo!"
    echo "Contoh: sudo bash configuration/create-service.sh"
    exit 1
fi

# =====================================
# CEK FILE
# =====================================
if [ ! -x "$VENV_DIR/bin/python" ]; then
    echo "Python virtual environment tidak ditemukan!"
    exit 1
fi

if [ ! -f "$PYTHON_FILE" ]; then
    echo "realtime.py tidak ditemukan!"
    exit 1
fi

if [ ! -f "$LARAVEL_DIR/artisan" ]; then
    echo "Laravel artisan tidak ditemukan!"
    exit 1
fi

# =====================================
# PYTHON SERVICE
# =====================================
echo "Membuat Python Service..."

cat > /etc/systemd/system/cctv-python.service <<EOF
[Unit]
Description=CCTV Attendance Python
After=network-online.target mariadb.service
Wants=network-online.target
Requires=mariadb.service

[Service]
Type=simple
User=$APP_USER
Group=$APP_USER
WorkingDirectory=$PROJECT_DIR

ExecStart=$VENV_DIR/bin/python $PYTHON_FILE

Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# =====================================
# LARAVEL SERVICE
# =====================================
echo "Membuat Laravel Service..."

cat > /etc/systemd/system/cctv-laravel.service <<EOF
[Unit]
Description=CCTV Attendance Laravel
After=network-online.target mariadb.service
Wants=network-online.target
Requires=mariadb.service

[Service]
Type=simple
User=$APP_USER
Group=$APP_USER
WorkingDirectory=$LARAVEL_DIR

ExecStart=/usr/bin/php8.4 artisan serve --host=0.0.0.0 --port=8000

Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# =====================================
# RELOAD DAN ENABLE SERVICE
# =====================================
systemctl daemon-reload

systemctl enable --now cctv-laravel.service

echo ""
echo "Python dan Laravel service berhasil dibuat!"