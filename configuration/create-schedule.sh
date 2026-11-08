
#!/bin/bash

set -e

echo "Membuat jadwal otomatis Python CCTV..."

# Timer mulai pukul 08.00
sudo tee /etc/systemd/system/cctv_python-start.timer > /dev/null <<'EOF'
[Unit]
Description=Schedule Python CCTV Start

[Timer]
OnCalendar=Mon..Fri *-*-* 08:00:00
Unit=cctv-python.service

[Install]
WantedBy=timers.target
EOF

# Timer berhenti pukul 19.00
sudo tee /etc/systemd/system/cctv_python-stop.timer > /dev/null <<'EOF'
[Unit]
Description=Schedule Python CCTV Stop

[Timer]
OnCalendar=Mon..Fri *-*-* 19:00:05 
Unit=cctv-python.service

[Install]
WantedBy=timers.target
EOF

# Aktifkan timer
sudo systemctl daemon-reload
sudo systemctl enable --now cctv-start.timer
sudo systemctl enable --now cctv-stop.timer

echo "Otomatisasi Python CCTV berhasil dibuat!"
