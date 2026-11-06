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

sudo apt install git -y

# =====================================
# 3. INSTAL PYTHON
# =====================================
echo "Menginstal Python dan dependensinya..."

sudo apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    build-essential \
    cmake \
    libopenblas-dev \
    liblapack-dev

# =====================================
# 4. INSTAL MARIADB
# =====================================
echo "Menginstal MariaDB..."

sudo apt install mariadb-server -y

sudo systemctl enable mariadb
sudo systemctl start mariadb


-- Membuat user database
CREATE USER IF NOT EXISTS 'python'@'localhost'
IDENTIFIED BY 'python';

-- Memberikan hak akses ke database
GRANT ALL PRIVILEGES ON attendance_cctv.*
TO 'python'@'localhost';

FLUSH PRIVILEGES;

# =====================================
# 5. INSTAL PHP DAN DEPENDENSI LARAVEL
# =====================================
echo "Menginstal PHP dan Composer..."

sudo apt install -y \
    php \
    php-cli \
    php-mbstring \
    php-xml \
    php-curl \
    php-zip \
    php-mysql \
    php-bcmath \
    unzip \
    curl \
    composer

# =====================================
# 6. SETUP PYTHON
# =====================================
echo "Menyiapkan virtual environment..."

python3 -m venv venv

source venv/bin/activate

pip install --upgrade pip
pip install -r requirements.txt

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
