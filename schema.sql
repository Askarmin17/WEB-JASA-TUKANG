-- schema.sql: create database & tables (MySQL)
CREATE DATABASE IF NOT EXISTS tukang_db DEFAULT CHARACTER SET utf8mb4;
USE tukang_db;

CREATE TABLE pelanggan (
  pelanggan_id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  alamat TEXT,
  no_telefon VARCHAR(20),
  password VARCHAR(255) NOT NULL
);

CREATE TABLE tukang (
  tukang_id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  alamat TEXT,
  no_telepon VARCHAR(20),
  spesialisasi VARCHAR(100),
  rating_avg DECIMAL(3,2) DEFAULT 0
);

CREATE TABLE admin (
  admin_id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(255),
  role VARCHAR(50)
);

CREATE TABLE kategori_tukang (
  kategori_id INT AUTO_INCREMENT PRIMARY KEY,
  nama_kategori VARCHAR(100) NOT NULL
);

CREATE TABLE tukang_kategori (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tukang_id INT,
  kategori_id INT,
  FOREIGN KEY (tukang_id) REFERENCES tukang(tukang_id) ON DELETE CASCADE,
  FOREIGN KEY (kategori_id) REFERENCES kategori_tukang(kategori_id) ON DELETE CASCADE
);

CREATE TABLE permintaan (
  permintaan_id INT AUTO_INCREMENT PRIMARY KEY,
  pelanggan_id INT,
  tukang_id INT,
  tanggal_permintaan DATETIME DEFAULT CURRENT_TIMESTAMP,
  alamat_pekerjaan TEXT,
  status_permintaan ENUM('Menunggu','Diterima','Selesai','Dibatalkan') DEFAULT 'Menunggu',
  keterangan TEXT,
  FOREIGN KEY (pelanggan_id) REFERENCES pelanggan(pelanggan_id),
  FOREIGN KEY (tukang_id) REFERENCES tukang(tukang_id)
);

CREATE TABLE pemesanan (
  pemesanan_id INT AUTO_INCREMENT PRIMARY KEY,
  permintaan_id INT,
  tanggal_mulai DATE,
  tanggal_selesai DATE,
  status ENUM('Proses','Selesai','Dibatalkan') DEFAULT 'Proses',
  FOREIGN KEY (permintaan_id) REFERENCES permintaan(permintaan_id)
);

CREATE TABLE rating (
  rating_id INT AUTO_INCREMENT PRIMARY KEY,
  pelanggan_id INT,
  tukang_id INT,
  skor TINYINT,
  ulasan TEXT,
  FOREIGN KEY (pelanggan_id) REFERENCES pelanggan(pelanggan_id),
  FOREIGN KEY (tukang_id) REFERENCES tukang(tukang_id)
);

CREATE TABLE chat (
  chat_id INT AUTO_INCREMENT PRIMARY KEY,
  pengirim ENUM('Pelanggan','Tukang','Admin'),
  pelanggan_id INT,
  tukang_id INT,
  admin_id INT,
  isi_pesan TEXT,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (pelanggan_id) REFERENCES pelanggan(pelanggan_id),
  FOREIGN KEY (tukang_id) REFERENCES tukang(tukang_id),
  FOREIGN KEY (admin_id) REFERENCES admin(admin_id)
);
