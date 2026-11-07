
#!/bin/bash

set -e

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
# 3. INSTAL PYTHON DAN TOOLS PENDUKUNG
# =====================================
echo "Menginstal Python dan dependensinya..."

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
# 5. INSTAL PHP DAN COMPOSER
# =====================================
echo "Menginstal PHP 8.4 dan Composer..."

sudo apt install -y software-properties-common

sudo add-apt-repository -y ppa:ondrej/php

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
    curl \
    composer

# Mengatur PHP 8.4 sebagai default
sudo update-alternatives --set php /usr/bin/php8.4

echo "Versi PHP yang digunakan:"
php -v

# Atur permission folder
cd laravel
sudo chown -R ubuntu:ubuntu storage bootstrap/cache
sudo chmod -R 775 storage bootstrap/cache
cd ..

# =====================================
# 6. SETUP PYTHON
# =====================================
echo "Menyiapkan virtual environment..."

python3 -m venv venv

source venv/bin/activate

pip install --upgrade pip

# Setuptools versi khusus untuk menghindari error pkg_resources
pip install setuptools==80.9.0

# Instal dlib
pip install dlib

# Instal library Python lainnya
pip install -r configuration/requirements.txt

deactivate

# =====================================
# 7. SETUP LARAVEL
# =====================================
echo "Menyiapkan Laravel..."

cd laravel

composer install

if [ ! -f .env ]; then
    cp .env.example .env
fi

php artisan key:generate

cd ..

# =====================================
# SELESAI
# =====================================
echo "====================================="
echo "Instalasi CCTV Attendance System selesai!"
echo "====================================="
