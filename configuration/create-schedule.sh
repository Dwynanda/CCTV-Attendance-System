
#!/bin/bash

set -e

echo "Membuat jadwal otomatis CCTV Attendance..."

# Service untuk menjalankan CCTV Attendance
sudo tee /etc/systemd/system/cctv-start.service > /dev/null <<'EOF'
[Unit]
Description=Start CCTV Attendance

[Service]
Type=oneshot
ExecStart=/bin/systemctl start cctv-python.service cctv-laravel.service
EOF

# Service untuk menghentikan CCTV Attendance
sudo tee /etc/systemd/system/cctv-stop.service > /dev/null <<'EOF'
[Unit]
Description=Stop CCTV Attendance

[Service]
Type=oneshot
ExecStart=/bin/systemctl stop cctv-python.service cctv-laravel.service
EOF

# Timer mulai pukul 08.00
sudo tee /etc/systemd/system/cctv-start.timer > /dev/null <<'EOF'
[Unit]
Description=Schedule CCTV Attendance Start

[Timer]
OnCalendar=Mon..Fri *-*-* 08:00:00 # <-- Mulai sistem
Unit=cctv-start.service

[Install]
WantedBy=timers.target
EOF

# Timer berhenti pukul 19.00
sudo tee /etc/systemd/system/cctv-stop.timer > /dev/null <<'EOF'
[Unit]
Description=Schedule CCTV Attendance Stop

[Timer]
OnCalendar=Mon..Fri *-*-* 19:00:00 # <-- Matikan Sistem
Unit=cctv-stop.service

[Install]
WantedBy=timers.target
EOF

# Aktifkan timer
sudo systemctl daemon-reload
sudo systemctl enable --now cctv-start.timer
sudo systemctl enable --now cctv-stop.timer

echo "Otomatisasi CCTV Attendance berhasil dibuat!"
