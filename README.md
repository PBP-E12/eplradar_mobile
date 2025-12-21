# ⚽ EPLRadar (Kelompok E12)

## 👥 Nama-Nama Anggota
| No | Nama Lengkap | NPM |
|----|---------------|------|
| 1 | **Omar Suyuf Wicaksono** | 2406421200 |
| 2 | **Oscar Glad Winfi Simanullang** | 2406411906 |
| 3 | **Raihan Maulana Heriandry** | 2406351024 |
| 4 | **Ahmad Zein Rasyid Siregar** | 2406408395 |
| 5 | **Antonius Daniel Maruli Nainggolan** | 2406496012 |


## 📝 Deskripsi Aplikasi
**EPLRadar** adalah aplikasi web berbasis Django yang menyajikan berbagai informasi terkini mengenai **English Premier League (EPL)**.  
meliputi berita, profil klub dan pemain, statistik, serta match dan klasemen. Berita yang disajikan dapat berupa perubahan anggota klub/transfer pemain, pengunduran match (jika ada), dll. Aplikasi ini bertujuan untuk memudahkan penggemar EPL dalam menemukan segala informasi terkait liga favorit mereka.


## 🧩 Modul Aplikasi

| Modul | Deskripsi |
|--------|------------|
| **Profile Club** |  menampilkan nama-nama klub dalam satu musim, jumlah win, draw, lose, dan list pemain di klub tersebut. |
| **Profile Pemain** | menampilkan informasi sederhana seperti nama dan klub bermain, serta statistik pemain tersebut di musim ini. |
| **Statistik** | menampilkan statistik musim ini (gol, assist, cleansheet) yg dapat dilihat berdasarkan klub atau pemain. |
| **Match & Klasemen** | menampilkan klasemen serta informasi match selama satu musim. |
| **Berita** | menampilkan berita terkini tentang EPL, meliputi transfer pemain, update club atau pemain, dll. |
| **Autentikasi & Home Page** | autentikasi user (login & register) dan halaman utama yg menampilkan preview seluruh page serta quick akses ke seluruh page. |
| **Admin Dashboard** | dashboard yg memungkinkan admin untuk melakukan CRUD terhadap klub, pemain, statistik, match, dan klasemen. |

---

## 👨‍💻 Pembagian Modul

| Modul | Penanggung Jawab |
|--------|------------------|
| **Profil Pemain** | Ahmad Zein Rasyid Siregar |
| **Berita EPL** | Antonius Daniel Maruli Nainggolan |
| **Statistik** | Raihan Maulana Heriandry |
| **Profil Club** | Omar Suyuf Wicaksono |
| **Match & Klasemen** | Oscar Glad Winfi Simanullang |
| **Main & Autentikasi** | Semua anggota |
| **Admin dashboard** | Oscar Glad Winfi Simanullang |

---

## 📊 Sumber Dataset Awal
Dataset yang digunakan berasal dari Kaggle:  
🔗 [Daily Football Stats 2025/26 (EPL, LaLiga, Serie A)](https://www.kaggle.com/datasets/mohulaprasath/daily-football-stats-202526-epl-laligaserie-a)

---

## 🔐 Role Pengguna

| Role | Deskripsi |
|------|------------|
| **Reguler User** | Dapat mengakses seluruh informasi publik seperti profil klub & pemain, statistik, klasemen, serta berita terkini. |
| **Login User** | Memiliki akses tambahan untuk menambahkan, mengedit, dan menghapus Berita. |
| **Admin User** | Dapat melakukan CRUD terhadap klub, pemain, statistik, match, dan klasemen. |

## Alur Integrasi dengan Proyek Django

Membuat endpoint di proyek django, lalu ambil data nya dan parsing ke JSON. Setelah itu, JSON dikirim ke flutter dan akan di-parsing ke model yg ada di flutter agar data bisa diproses dan ditampilkan di aplikasi. Apabila user menambahkan sesuatu melalui aplikasi, data akan di-parsing ke JSON, lalu dikirimkan ke django dan disimpan ke models.py.


---

## 🎨 Link Figma (Prototype Desain)
🔗 [Figma Prototype - EPLRadar](https://www.figma.com/design/B5YHzIHcIlUCL9HPCaezqr/TK-PAS-PBP?node-id=0-1&t=RcLJKwgde4rSV4Mg-1)

## Badge Bitrise: 
 [![Build Status](https://app.bitrise.io/app/b24f41de-ef08-4119-ba0a-6e750a1e4982/status.svg?token=kWuT8dPNoPVGrqg_ukqzQA&branch=master)](https://app.bitrise.io/app/b24f41de-ef08-4119-ba0a-6e750a1e4982)

## Download
Download aplikasi versi terbaru: [Download APK]()