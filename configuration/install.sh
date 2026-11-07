
#!/bin/bash

set -e

# =====================================
# PERSIAPAN
# =====================================
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

APP_USER="${SUDO_USER:-$USER}"

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
echo "Menginstal Python dan dependensinya..."

sudo apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    python3-full \
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

sudo apt install -y mariadb-server

sudo systemctl enable --now mariadb

# =====================================
# 5. INSTAL PHP DAN COMPOSER
# =====================================
echo "Menginstal PHP dan Composer..."

# Menggunakan repository resmi Debian.
# Tidak menggunakan PPA Ubuntu.

sudo apt install -y \
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

echo "Versi PHP yang digunakan:"
php -v

# =====================================
# 6. SETUP PYTHON
# =====================================
echo "Menyiapkan virtual environment..."

python3 -m venv venv

source venv/bin/activate

pip install --upgrade pip

# Setuptools versi khusus
pip install setuptools==80.9.0

# Instal PyTorch versi CPU (tanpa CUDA/NVIDIA)
pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu

# Instal library Python lainnya
pip install --resume-retries 20 --timeout 120 -r configuration/requirements.txt

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
sudo chown -R "$APP_USER:$APP_USER" storage bootstrap/cache
sudo chmod -R 775 storage bootstrap/cache

cd "$PROJECT_DIR"

# =====================================
# SELESAI
# =====================================
echo "====================================="
echo "Instalasi CCTV Attendance System selesai!"
echo "====================================="
