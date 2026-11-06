import cv2
import face_recognition
import mysql.connector
import pickle
import sys

### TRAINING FACES FOR DATABASE

foto = sys.argv[1]
nama = sys.argv[2]

database = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="attendance_cctv"
)

cursor = database.cursor()
# nama = input("Masukkan nama karyawan: ")

namafile = "dw.jpeg" # < --- nama file untuk ditraining

# gambar = cv2.imread(f"./training/{namafile}")
# if gambar is None:
#     print("Foto tidak ditemukan!")
#     exit()

load_foto = face_recognition.load_image_file(foto)
encodings = face_recognition.face_encodings(load_foto)
# if len(encodings) > 0:
#     print("Wajah terdeteksi!")
#     exit()
# else:
#     print("wajah tidak ada")

encoding = pickle.dumps(encodings[0])

command = """
INSERT INTO encoding_data (name, encoded)
VALUES (%s, %s)
"""

cursor.execute(command, (nama, encoding))

database.commit()

print("Data berhasil disimpan!")

cursor.close()
database.close()

