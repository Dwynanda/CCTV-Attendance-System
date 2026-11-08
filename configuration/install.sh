#!/bin/bash

set -e

# =====================================
# KONFIGURASI
# =====================================

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUN_USER="${SUDO_USER:-$(whoami)}"

echo "====================================="
echo "CCTV ATTENDANCE SYSTEM INSTALLATION"
echo "====================================="

echo "Project: $PROJECT_DIR"
echo "User   : $RUN_USER"

# =====================================
# 1. UPDATE SISTEM
# =====================================

echo "Memperbarui sistem..."

sudo apt update
sudo apt upgrade -y

# =====================================
# 2. INSTAL GIT
# =====================================

echo "Menginstal Git..."

sudo apt install -y git

# =====================================
# 3. INSTAL PYTHON DAN DEPENDENSI
# =====================================

echo "Menginstal Python dan tools pendukung..."

sudo apt install -y \
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
    libgtk-3-dev \
    libx11-dev \
    ffmpeg

# =====================================
# 4. INSTAL MARIADB
# =====================================

echo "Menginstal MariaDB..."

sudo apt install -y mariadb-server

sudo systemctl enable mariadb
sudo systemctl start mariadb

# =====================================
# 5. INSTAL PHP 8.4 DAN COMPOSER
# =====================================

echo "Menginstal PHP 8.4 dan Composer..."

sudo apt install -y \
    ca-certificates \
    apt-transport-https \
    curl \
    lsb-release \
    gnupg

# Repository PHP Sury untuk Debian

sudo install -d -m 0755 /usr/share/keyrings

sudo curl -fsSL https://packages.sury.org/php/apt.gpg \
    -o /usr/share/keyrings/sury-php.gpg

echo "deb [signed-by=/usr/share/keyrings/sury-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" \
    | sudo tee /etc/apt/sources.list.d/sury-php.list

sudo apt update

sudo apt install -y \
    php8.4 \
    php8.4-cli \
    php8.4-mbstring \
    php8.4-xml \
    php8.4-curl \
    php8.4-zip \
    php8.4-mysql \
    php8.4-bcmath \
    php8.4-sqlite3 \
    unzip \
    composer

sudo update-alternatives --set php /usr/bin/php8.4

echo "Versi PHP:"
php -v

# =====================================
# 6. SETUP PYTHON VIRTUAL ENVIRONMENT
# =====================================

echo "Menyiapkan Python virtual environment..."

cd "$PROJECT_DIR"

# Pastikan kepemilikan proyek benar
sudo chown -R "$RUN_USER":"$(id -gn "$RUN_USER")" "$PROJECT_DIR"

# Buat virtual environment sebagai user proyek
if [ ! -d "$PROJECT_DIR/venv" ]; then
    sudo -u "$RUN_USER" python3 -m venv "$PROJECT_DIR/venv"
fi

PYTHON="$PROJECT_DIR/venv/bin/python"
PIP="$PROJECT_DIR/venv/bin/pip"

# Upgrade pip dan setuptools
sudo -u "$RUN_USER" "$PYTHON" -m pip install --upgrade pip
sudo -u "$RUN_USER" "$PIP" install setuptools==80.9.0

# Instal PyTorch CPU-only
echo "Menginstal PyTorch CPU-only..."

sudo -u "$RUN_USER" "$PIP" install \
    torch torchvision \
    --index-url https://download.pytorch.org/whl/cpu

# Instal dlib
echo "Menginstal dlib..."

sudo -u "$RUN_USER" "$PIP" install dlib

# Instal library Python proyek
echo "Menginstal requirements Python..."

sudo -u "$RUN_USER" "$PIP" install \
    -r "$PROJECT_DIR/configuration/requirements.txt"

# =====================================
# 7. SETUP LARAVEL
# =====================================

echo "Menyiapkan Laravel..."

cd "$PROJECT_DIR/laravel"

# Install Composer dependencies
sudo -u "$RUN_USER" composer install

# Buat .env jika belum tersedia
if [ ! -f .env ]; then
    sudo -u "$RUN_USER" cp .env.example .env
fi

# Generate APP_KEY hanya jika masih kosong
if ! grep -q '^APP_KEY=base64:' .env; then
    sudo -u "$RUN_USER" php artisan key:generate
fi

# Atur permission Laravel
sudo chown -R "$RUN_USER":"$(id -gn "$RUN_USER")" \
    storage bootstrap/cache

sudo chmod -R 775 storage bootstrap/cache

# =====================================
# 8. SELESAI
# =====================================

echo "====================================="
echo "INSTALASI BERHASIL!"
echo "====================================="

echo "Project : $PROJECT_DIR"
echo "Python  : $PYTHON"
echo "PHP     : $(php -r 'echo PHP_VERSION;')"

