import cv2
import face_recognition
import mysql.connector
import pickle

### TRAINING FACES FOR DATABASE

database = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="attendance_cctv"
)

cursor = database.cursor()
nama = input("Masukkan nama karyawan: ")

namafile = "dw.jpeg" # < --- nama file untuk ditraining

gambar = cv2.imread(f"./training/{namafile}")
if gambar is None:
    print("Foto tidak ditemukan!")
    exit()

encodings = face_recognition.face_encodings(gambar)
if len(encodings) == 0:
    print("Wajah tidak terdeteksi!")
    exit()

encoding = pickle.dumps(encodings[0])

command = """
INSERT INTO encoding_data (name, encode)
VALUES (%s, %s)
"""

cursor.execute(command, (nama, encoding))

database.commit()

print("Data berhasil disimpan!")

cursor.close()
database.close()

