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
# CEK PERMISSION
# =====================================
if [ "$EUID" -ne 0 ]; then
    echo "Jalankan script menggunakan sudo!"
    echo "Contoh: sudo bash configuration/create-service.sh"
    exit 1
fi

# =====================================
# CEK FILE DAN DIRECTORY
# =====================================
if [ ! -x "$VENV_DIR/bin/python" ]; then
    echo "Python virtual environment tidak ditemukan!"
    echo "Periksa: $VENV_DIR/bin/python"
    exit 1
fi

if [ ! -f "$PYTHON_FILE" ]; then
    echo "File realtime.py tidak ditemukan!"
    exit 1
fi

if [ ! -f "$LARAVEL_DIR/artisan" ]; then
    echo "File Laravel artisan tidak ditemukan!"
    exit 1
fi

echo "Membuat Python Service..."

# =====================================
# PYTHON SERVICE
# =====================================
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

ExecStart=$VENV_DIR/bin/python $PYTHON_FILE

Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "Membuat Laravel Service..."

# =====================================
# LARAVEL SERVICE
# =====================================
cat > /etc/systemd/system/cctv-laravel.service <<EOF
[Unit]
Description=CCTV Attendance Laravel
After=network.target mariadb.service
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

systemctl enable --now cctv-python.service
systemctl enable --now cctv-laravel.service

echo ""
echo "Python dan Laravel service berhasil dibuat!"
echo ""
echo "Status service:"
systemctl --no-pager --full status cctv-python.service || true
systemctl --no-pager --full status cctv-laravel.service || true
