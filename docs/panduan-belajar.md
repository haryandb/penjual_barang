# Flutter Seller Dashboard — Panduan Belajar Dart & Flutter

Selamat datang! Dokumen ini adalah panduan belajar **Dart** dan **Flutter** menggunakan project **Penjual Barang** — aplikasi Flutter untuk manajemen transaksi penjualan.

**Target pembaca:** Mahasiswa baru yang **belum pernah programming**. Tidak butuh pengalaman coding sebelumnya.

**Cara belajar:** Baca kode yang sudah jadi di project ini, pahami konsepnya, lalu kerjakan latihan. Setiap bab memperkenalkan konsep baru sambil merujuk ke file-file nyata di project.

**Repo:** https://github.com/haryandb/penjual_barang

---

## 📋 Daftar Isi

1. [Tahap 0 — Persiapan & "Halo Flutter"](#tahap-0--persiapan--halo-flutter)
2. [Tahap 1 — Model: Belajar Dart Lewat Data Transaksi](#tahap-1--model-belajar-dart-lewat-data-transaksi)
3. [Tahap 2 — StatCard: Widget Flutter Pertama](#tahap-2--statcard-widget-flutter-pertama)
4. [Tahap 3 — Provider & State Management](#tahap-3--provider--state-management)
5. [Tahap 4 — Dashboard: Layout & Grafik](#tahap-4--dashboard-layout--grafik)
6. [Tahap 5 — Form Tambah Transaksi: Input & Validasi](#tahap-5--form-tambah-transaksi-input--validasi)
7. [Tahap 6 — Daftar Transaksi: List & Navigasi](#tahap-6--daftar-transaksi-list--navigasi)
8. [Tahap 7 — Utility: Error Handling & Formatting](#tahap-7--utility-error-handling--formatting)
9. [Tahap 8 — Widget Testing](#tahap-8--widget-testing)
10. [Tahap 9 — CI/CD dengan GitHub Actions](#tahap-9--cicd-dengan-github-actions)
11. [Penutup](#penutup)

---

## Tahap 0 — Persiapan & "Halo Flutter"

Di tahap ini, kamu akan menyiapkan komputer untuk coding Flutter dan menjalankan project ini pertama kali.

### 0.1 Install Flutter SDK

**Flutter SDK** adalah kumpulan alat (compiler, library, command-line tools) yang kamu butuhin untuk bikin aplikasi Flutter.

1. Buka https://docs.flutter.dev/get-started/install
2. Pilih OS kamu (Windows/macOS/Linux)
3. Download Flutter SDK versi **stable** terbaru
4. Extract file yang sudah di-download
5. Tambahkan folder `flutter/bin` ke **PATH** (environment variable) — panduan lengkap ada di website Flutter

> **Apa itu PATH?** PATH adalah daftar folder yang dicari komputer saat kamu ngetik perintah di terminal. Kalo `flutter/bin` udah di PATH, kamu bisa ngetik `flutter` dari mana aja.

Cek kalo instalasi berhasil:
```bash
flutter --version
```
Harusnya muncul info versi Flutter yang terinstall.

### 0.2 Install VS Code & Extensions

**VS Code (Visual Studio Code)** adalah editor kode yang ringan dan populer.

1. Download VS Code dari https://code.visualstudio.com/
2. Install dan buka
3. Buka tab **Extensions** (icon kotak-kotak di kiri, atau tekan `Cmd+Shift+X`)
4. Cari dan install 2 extension ini:
   - **Flutter** (dari Dart Code) — memberikan syntax highlighting, auto-complete, debugger
   - **Dart** (dari Dart Code) — support bahasa Dart

### 0.3 Setup Emulator atau HP Fisik

**Emulator** adalah program yang menjalankan Android di komputer kamu — mirip punya HP Android virtual.

**Opsi A: Android Emulator (rekomendasi)**
1. Download dan install **Android Studio** dari https://developer.android.com/studio
   - Ini aplikasi besar (~2GB), butuh waktu download dan install
2. Buka Android Studio → **More Actions** → **SDK Manager**
   - Pastikan **Android SDK** terinstall
3. Buka **Virtual Device Manager** (icon HP di toolbar kanan)
4. Klik **Create Device** → pilih HP (misal Pixel 6) → download system image (Android 14) → Next → Finish
5. Jalankan emulator dengan klik icon **play**

**Opsi B: HP Fisik (Android)**
1. Aktifkan **Developer Options** di HP:
   - Settings → About Phone → Tap "Build Number" 7 kali
2. Aktifkan **USB Debugging**:
   - Settings → Developer Options → USB Debugging → ON
3. Hubungkan HP ke komputer dengan kabel USB
4. Di terminal, jalankan `flutter devices` — HP kamu harus muncul di daftar

### 0.4 Clone Project

**Clone** artinya download project dari GitHub ke komputer kamu.

```bash
git clone https://github.com/haryandb/penjual_barang.git
cd penjual_barang
```

> **Apa itu Git?** Git adalah alat untuk melacak perubahan kode. Kamu bakal paham lebih dalam nanti. Untuk sekarang, cukup tahu bahwa `git clone` itu mendownload project.

### 0.5 Install Dependencies

Project Flutter bisa pake kode buatan orang lain yang disebut **package** atau **dependency**. Daftar dependency ada di file `pubspec.yaml`.

```bash
flutter pub get
```

Perintah ini mendownload semua package yang dibutuhkan. Kalo berhasil, akan muncul pesan seperti:
```
Resolving dependencies...
Downloading packages...
  provider 6.1.1 (tersedia)
  intl 0.19.0 (tersedia)
  fl_chart 0.68.0 (tersedia)
Got dependencies!
```

### 0.6 Jalankan Aplikasi

Pastikan emulator berjalan atau HP terhubung. Lalu:

```bash
flutter run
```

Flutter akan kompilasi kode dan mengirimnya ke emulator/HP. Proses pertama mungkin agak lama (~1-2 menit). Tunggu sampai aplikasi muncul di layar.

### 0.7 Hot Reload — Keajaiban Flutter

**Hot reload** adalah fitur yang memungkinkan kamu melihat perubahan kode dalam hitungan detik — tanpa nunggu kompilasi ulang penuh.

1. Project lagi berjalan di emulator/HP
2. Buka file `lib/main.dart`
3. Cari teks `Dashboard`
4. Ganti jadi `Halo Flutter` (atau apapun)
5. Simpan file (`Cmd+S`)
6. Lihat layar emulator — teks langsung berubah!

Hot reload hanya untuk perubahan UI. Kalo kamu ubah struktur data atau state, pake **hot restart** (ketik `r` di terminal) atau restart penuh (ketik `R`).

### 0.8 Kenalan dengan Folder Project

Project Flutter punya struktur folder standar. Berikut yang penting:

```
penjual_barang/
├── lib/                          # --- KODE UTAMA ---
│   ├── main.dart                 # Entry point — tempat aplikasi dimulai
│   ├── models/                   # Struktur data
│   ├── providers/                # State management
│   ├── screens/                  # Halaman-halaman aplikasi
│   ├── widgets/                  # Widget reusable
│   └── utils/                    # Fungsi bantuan
├── test/                         # --- FILE TEST ---
│   └── app_test.dart             # Test untuk widget
├── pubspec.yaml                  # --- KONFIGURASI ---
│                                # Daftar dependency, nama project, dll
├── android/                      # File untuk build Android (jangan disentuh)
├── ios/                          # File untuk build iOS (jangan disentuh)
└── .github/workflows/            # CI/CD automation
```

Jelajahi folder-folder ini setelah aplikasi berjalan. Kamu gak perlu hafal semuanya — seiring belajar, kamu bakal paham fungsi masing-masing.

### Istilah Baru di Tahap 0

| Istilah | Arti |
|---------|------|
| **SDK** | Software Development Kit — kumpulan alat untuk bikin aplikasi |
| **Emulator** | Program yang menjalankan OS Android di komputer |
| **Dependency** | Package/kode buatan orang lain yang dipake project kita |
| **pubspec.yaml** | File konfigurasi project Flutter |
| **Hot reload** | Fitur Flutter — lihat perubahan kode instan tanpa kompilasi ulang |
| **Widget** | Komponen UI di Flutter (tombol, teks, card, dll) |

### Latihan Tahap 0

1. **Ganti warna tema:** Buka `lib/main.dart`, cari `colorSchemeSeed: Colors.blue`, ganti `Colors.blue` jadi `Colors.green`. Simpan, lihat perubahannya.
2. **Ganti judul AppBar:** Cari `title: 'Dashboard'`, ganti jadi `title: 'Toko Saya'`. Hot reload untuk lihat hasilnya.
3. **Explore:** Buka file `lib/screens/dashboard_screen.dart`. Coba cari teks yang muncul di layar dashboard. Jangan khawatir kalo belum ngerti — itu tugas kita di tahap-tahap berikutnya.
