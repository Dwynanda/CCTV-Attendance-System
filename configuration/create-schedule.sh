#!/bin/bash
set -e

echo "Membuat jadwal otomatis CCTV Attendance..."

# Service untuk menjalankan CCTV Attendance
sudo tee /etc/systemd/system/cctv-start.service > /dev/null <<'EOF'
[Unit]
Description=Start CCTV Attendance

[Service]
Type=oneshot
ExecStart=/bin/systemctl start cctv-attendance.service
EOF

# Service untuk menghentikan CCTV Attendance
sudo tee /etc/systemd/system/cctv-stop.service > /dev/null <<'EOF'
[Unit]
Description=Stop CCTV Attendance

[Service]
Type=oneshot
ExecStart=/bin/systemctl stop cctv-attendance.service
EOF

# Timer mulai
sudo tee /etc/systemd/system/cctv-start.timer > /dev/null <<'EOF'
[Unit]
Description=Schedule CCTV Attendance Start

[Timer]
OnCalendar=Mon..Fri *-*-* 09:00:00
OnCalendar=Mon..Fri *-*-* 17:00:00
Unit=cctv-start.service

[Install]
WantedBy=timers.target
EOF

# Timer berhenti
sudo tee /etc/systemd/system/cctv-stop.timer > /dev/null <<'EOF'
[Unit]
Description=Schedule CCTV Attendance Stop

[Timer]
OnCalendar=Mon..Fri *-*-* 12:00:00
OnCalendar=Mon..Fri *-*-* 19:00:00
Unit=cctv-stop.service

[Install]
WantedBy=timers.target
EOF

# Aktifkan timer
sudo systemctl daemon-reload
sudo systemctl enable --now cctv-start.timer
sudo systemctl enable --now cctv-stop.timer

echo "Otomatisasi CCTV Attendance berhasil dibuat!"