
#!/bin/bash

set -e

# =====================================
# PATH PROJECT
# =====================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
VENV_DIR="$SCRIPT_DIR/venv"

cd "$PROJECT_DIR"

# Tentukan user pemilik project
if [ -n "$SUDO_USER" ]; then
    APP_USER="$SUDO_USER"
elif [ "$EUID" -eq 0 ]; then
    APP_USER="$(stat -c '%U' "$PROJECT_DIR")"
else
    APP_USER="$USER"
fi

# =====================================
# 1. UPDATE SISTEM
# =====================================
echo "Memperbarui sistem..."

apt update
apt upgrade -y

# =====================================
# 2. INSTAL GIT
# =====================================
echo "Menginstal Git..."

apt install -y git

# =====================================
# 3. INSTAL PYTHON DAN DEPENDENSI
# =====================================
echo "Menginstal Python dan dependensinya..."

apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    python3-setuptools \
    python3-wheel \
    build-essential \
    cmake \
    pkg-config \
    libopenblas-dev \
    liblapack-dev \
    libgl1 \
    libglib2.0-0 \
    ffmpeg

# =====================================
# 4. INSTAL MARIADB
# =====================================
echo "Menginstal MariaDB..."

apt install -y mariadb-server

systemctl enable mariadb
systemctl start mariadb

# =====================================
# 5. INSTAL PHP DAN COMPOSER
# =====================================
echo "Menginstal PHP dan Composer..."

apt install -y \
    php-cli \
    php-mbstring \
    php-xml \
    php-curl \
    php-zip \
    php-mysql \
    php-bcmath \
    php-sqlite3 \
    unzip \
    curl \
    composer

php -v

# =====================================
# 6. SETUP PYTHON
# =====================================
echo "Menyiapkan virtual environment..."

if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"

pip install --upgrade pip

pip install setuptools==80.9.0

# PyTorch versi CPU
pip install torch torchvision \
    --index-url https://download.pytorch.org/whl/cpu

# Instal library Python
pip install --resume-retries 20 --timeout 120 \
    -r "$SCRIPT_DIR/requirements.txt"

# Verifikasi PyTorch
python -c "import torch; print('Torch:', torch.__version__); print('CUDA:', torch.cuda.is_available())"

deactivate

# =====================================
# 7. SETUP LARAVEL
# =====================================
echo "Menyiapkan Laravel..."

cd "$PROJECT_DIR/laravel"

composer install

if [ ! -f .env ]; then
    cp .env.example .env
fi

php artisan key:generate

# Atur permission Laravel
cd laravel
chown -R debian:debian storage bootstrap/cache

chmod -R 775 storage bootstrap/cache
cd ..

# =====================================
# SELESAI
# =====================================
echo "====================================="
echo "Instalasi CCTV Attendance System selesai!"
echo "====================================="
