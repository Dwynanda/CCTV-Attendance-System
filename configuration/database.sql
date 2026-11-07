-- =====================================
-- 1. MEMBUAT DATABASE
-- =====================================

CREATE DATABASE IF NOT EXISTS attendance_cctv;

USE attendance_cctv;


-- =====================================
-- 2. MEMBUAT TABEL DATA WAJAH
-- =====================================

CREATE TABLE IF NOT EXISTS encoding_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    encoded LONGBLOB NOT NULL
);


-- =====================================
-- 3. MEMBUAT TABEL ABSENSI
-- =====================================

CREATE TABLE IF NOT EXISTS absensi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    person INT NOT NULL,
    img_masuk LONGBLOB,
    absen_masuk DATETIME,
    img_pulang LONGBLOB,
    absen_pulang DATETIME,

    FOREIGN KEY (person)
        REFERENCES encoding_data(id)
);


-- =====================================
-- 4. MEMBUAT USER DATABASE
-- =====================================

ALTER 'python'@'localhost'
IDENTIFIED BY 'python';


-- =====================================
-- 5. MEMBERIKAN HAK AKSES
-- =====================================

GRANT ALL PRIVILEGES ON attendance_cctv.*
TO 'python'@'localhost';

FLUSH PRIVILEGES;
