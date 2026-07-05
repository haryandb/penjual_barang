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

---

## Tahap 1 — Model: Belajar Dart Lewat Data Transaksi

Di tahap ini, kamu akan belajar **dasar-dasar bahasa Dart** sambil membaca file `lib/models/transaction.dart`. Model adalah struktur data — cara kita menyimpan informasi di memori komputer.

Buka file `lib/models/transaction.dart` di VS Code dan ikuti penjelasan di bawah.

### 1.1 Variable & Tipe Data

Lihat baris pertama di dalam class `TransactionItem`:

```dart
class TransactionItem {
  String name;       // Nama barang — teks
  int quantity;      // Jumlah — angka bulat
  double price;      // Harga satuan — angka desimal
```

Di Dart, setiap **variable** punya **tipe data** — yaitu jenis nilai yang bisa disimpan.

| Tipe | Contoh Nilai | Kegunaan |
|------|-------------|----------|
| `String` | `"Beras 5kg"`, `"Budi"` | Teks |
| `int` | `1`, `42`, `-5` | Bilangan bulat (tidak ada koma) |
| `double` | `3.14`, `65000.0` | Bilangan desimal (boleh berkoma) |
| `bool` | `true`, `false` | Benar/salah |

**Kenapa harga pake `double` bukan `int`?** Harga di project ini memang bilangan bulat (65000), tapi secara konsep harga bisa saja berkoma (misal diskon 0.5%). Makanya pake `double`.

### 1.2 `final` — Nilai yang Tidak Bisa Diubah

Sekarang lihat class `Transaction`:

```dart
class Transaction {
  final String id;
  final String customerName;
  final List<TransactionItem> items;
  final DateTime date;
  final String paymentMethod;
```

Keyword `final` artinya: **setelah diisi, nilai gak bisa diubah lagi**. Ini disebut **immutable** (tidak bisa dimutasi/diubah).

Kenapa transaksi pake `final`? Konsepnya: setelah transaksi terjadi, datanya sudah tetap. Kamu gak akan mengubah nama pelanggan atau barang setelah transaksi selesai — kalo ada kesalahan, lebih baik hapus transaksi dan buat ulang.

Bandingkan dengan `TransactionItem` yang **tidak** pake `final`:
```dart
class TransactionItem {
  String name;       // ← TIDAK final — bisa diubah
  int quantity;
  double price;
```

Item barang mungkin perlu diubah (misal koreksi jumlah). Makanya gak dikasih `final`.

> **Ingat:** Pada dasarnya, gunakan `final` sebisa mungkin. Hanya lepas `final` kalo kamu yakin nilai itu perlu diubah setelah object dibuat.

### 1.3 Class & Constructor

**Class** adalah cetakan untuk membuat **object**. Class `TransactionItem` adalah cetakan, dan setiap transaksi item yang spesifik (misal "Beras 5kg" untuk transaksi #1) adalah sebuah object.

**Constructor** adalah method khusus yang dijalankan saat object dibuat.

```dart
TransactionItem({
  required this.name,
  required this.quantity,
  required this.price,
});
```

Ini disebut **constructor with named parameters** — parameter dipanggil dengan nama, bukan urutan.

```dart
// Pake urutan (positional) — harus hafal urutannya:
TransactionItem('Beras 5kg', 2, 65000);

// Pake nama (named) — lebih jelas:
TransactionItem(name: 'Beras 5kg', quantity: 2, price: 65000);
```

Named parameters lebih mudah dibaca dan gak rentan salah urut.

### 1.4 Keyword `required` & `this.`

- `required` — parameter **wajib** diisi saat membuat object. Kalo lupa, error.
- `this.name` — `this` merujuk ke **object saat ini**. `this.name` artinya "field `name` milik object ini, diisi dari parameter `name`".

```dart
TransactionItem({required this.name, ...});
//                      ^^^^^^^^^^^^
//  Artinya: parameter name → field this.name
```

### 1.5 Object Literal — Cara Bikin Object

```dart
TransactionItem(name: 'Beras 5kg', quantity: 2, price: 65000)
```

Ini adalah object literal: kita "panggil" nama class seperti fungsi, dan isi parameter-parameternya.

Contoh bikin object transaksi:
```dart
Transaction(
  id: '1',
  customerName: 'Budi Santoso',
  items: [
    TransactionItem(name: 'Beras 5kg', quantity: 2, price: 65000),
    TransactionItem(name: 'Minyak Goreng 1L', quantity: 3, price: 18000),
  ],
  date: DateTime.now(),
  paymentMethod: 'cash',
);
```

### 1.6 Getter — Properti yang Dihitung

Lihat baris ini:

```dart
/// Getter: subtotal = quantity × price
double get subtotal => quantity * price;
```

**Getter** adalah properti yang nilainya **dihitung** dari properti lain, bukan disimpan sebagai field.

- `double` = tipe kembalian
- `get` = keyword getter
- `subtotal` = nama getter
- `=>` = arrow syntax, artinya "return (nilai berikut)"
- `quantity * price` = rumusnya

**Kenapa pake getter, bukan field biasa?**

Karena `subtotal` selalu bisa dihitung dari `quantity * price`. Kalo disimpan sebagai field, kita harus ingat meng-update nilai `subtotal` setiap kali `quantity` atau `price` berubah. Dengan getter, nilainya otomatis selalu benar.

**Getter vs Method biasa:**
```dart
// ❌ Kalo pake method: panggil dengan ()
item.subtotal()

// ✅ Kalo pake getter: panggil tanpa ()
item.subtotal
```

Gunakan getter untuk properti yang ringan dihitung (seperti perkalian/penjumlahan). Kalo kalkulasinya berat (misal baca file), pake method.

### 1.7 String Interpolation

```dart
return '${date.day} ${months[date.month - 1]} ${date.year}';
```

**String interpolation** adalah cara memasukkan nilai variable ke dalam string. Gunakan `${expression}`:

```dart
'Namaku ${nama} dan umurku ${umur} tahun'
// Hasil: "Namaku Budi dan umurku 20 tahun"
```

Kalo expressionnya cuma satu variable, boleh tanpa kurung kurawal:
```dart
'Namaku $nama dan umurku $umur tahun'  // Sama aja
```

### 1.8 List, fold, dan Akumulasi

```dart
double get total =>
    items.fold(0, (sum, item) => sum + item.subtotal);
```

**`fold`** adalah method untuk **mengakumulasi** (menjumlahkan) nilai-nilai dalam list.

Cara kerja `fold`:
```
       (0)           ← nilai awal
         ↓
item[0] → sum=0,  ditambah item.subtotal → sum baru
         ↓
item[1] → sum=baru, ditambah item.subtotal → sum baru
         ↓
  ... dan seterusnya sampai list habis
         ↓
      return sum akhir
```

Contoh lebih sederhana:
```dart
final numbers = [1, 2, 3, 4, 5];
final total = numbers.fold(0, (sum, n) => sum + n);
// total = 15
```

**`fold` vs `reduce`:**

| Method | Bisa list kosong? | Return type |
|--------|------------------|-------------|
| `fold` | ✅ Ya (return nilai awal) | Bisa beda dengan tipe element |
| `reduce` | ❌ Minimal 1 element | Sama dengan tipe element |

### 1.9 Switch-Case

```dart
String get paymentLabel {
  switch (paymentMethod) {
    case 'cash':     return 'Tunai';
    case 'transfer': return 'Transfer';
    case 'qris':     return 'QRIS';
    default:         return paymentMethod;
  }
}
```

**Switch-case** adalah cara memilih satu nilai dari banyak kemungkinan. Lebih rapi daripada `if-else` bersusun.

Cara kerja:
1. Lihat nilai `paymentMethod`
2. Cocokkan dengan setiap `case`
3. Kalo cocok, return nilai yang sesuai
4. Kalo gak ada yang cocok, jalankan `default`

### 1.10 Index Offset — Kenapa `date.month - 1`?

```dart
final months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
];
return '${date.day} ${months[date.month - 1]} ${date.year}';
```

Array/list di Dart (dan kebanyakan bahasa) menggunakan **index 0-based** — artinya index pertama adalah 0, bukan 1.

```
Index:    0      1      2      3    ...   11
Array:  ['Jan', 'Feb', 'Mar', 'Apr', ..., 'Des']
```

Tapi `date.month` mengembalikan **1-based**: Januari = 1, Februari = 2, ... Desember = 12.

Jadi untuk mengambil `months[date.month]` dengan `date.month = 1` akan mengambil `months[1]` = 'Februari' — **salah**.

Solusi: kurangi 1: `months[date.month - 1]`.

### Istilah Baru di Tahap 1

| Istilah | Arti |
|---------|------|
| **Variable** | Tempat menyimpan nilai di memori |
| **Tipe data** | Jenis nilai (`String`, `int`, `double`) |
| **Class** | Cetakan untuk membuat object |
| **Object** | Instance/contoh nyata dari class |
| **Constructor** | Method khusus untuk membuat object |
| **Named parameter** | Parameter yang dipanggil dengan nama |
| **`final`** | Keyword — nilai tidak bisa diubah setelah diisi |
| **Immutable** | Tidak bisa diubah setelah dibuat |
| **Getter** | Properti yang nilainya dihitung otomatis |
| **String interpolation** | Memasukkan nilai variable ke string |
| **`fold`** | Method untuk mengakumulasi list |
| **Index 0-based** | Index dimulai dari 0, bukan 1 |

### Latihan Tahap 1

1. **Tambah diskon:** Di class `TransactionItem`, tambah field baru `double discount = 0` (default 0). Lalu buat getter `double get totalAfterDiscount => subtotal - (subtotal * discount / 100)`.
2. **Buat model baru:** Buat file baru `lib/models/customer.dart`. Definisikan class `Customer` dengan field: `String name`, `String phone`, `DateTime memberSince` (pake `final`). Gunakan named constructor dengan required parameter.
3. **Eksperimen fold:** Di penjelasan, kita pake `fold` untuk jumlahin subtotal. Coba hitung total **quantity** semua item pake `fold`. Petunjuk: `items.fold(0, (sum, item) => sum + item.quantity)`.

---

## Tahap 2 — StatCard: Widget Flutter Pertama

Di tahap ini, kamu akan belajar **Flutter widget** pertama kamu dengan membaca `lib/widgets/stat_card.dart`. Widget adalah komponen UI — tombol, teks, card, semuanya adalah widget.

Buka file `lib/widgets/stat_card.dart`.

### 2.1 StatelessWidget — Widget Tanpa State

```dart
class StatCard extends StatelessWidget {
```

**`StatelessWidget`** adalah jenis widget yang **tidak punya state yang berubah**. Tampilannya ditentukan dari awal dan tidak akan berubah selama widget ada.

Contoh widget stateless: teks, icon, card — semua yang tampilannya tetap.

Nanti di Tahap 5 kamu akan lihat **`StatefulWidget`** — widget yang punya state yang bisa berubah (misal form input).

### 2.2 `build(BuildContext context)` — Method Utama

```dart
@override
Widget build(BuildContext context) {
  return Card(...);
}
```

Method `build` adalah **otak** dari setiap widget. Method ini:
1. Dijalankan saat widget pertama kali ditampilkan
2. **Mengembalikan** widget tree (susunan widget)
3. Parameter `context` berisi informasi posisi widget di dalam tree

### 2.3 Widget Tree

Setiap widget Flutter bisa berisi widget lain di dalamnya — ini disebut **widget tree** (pohon widget).

StatCard punya widget tree seperti ini:

```
Card
  └── Padding
        └── Column
              ├── Container (icon)
              ├── SizedBox (jarak)
              ├── Text (value)
              ├── Text (title)
              └── Text? (subtitle — opsional)
```

Kode yang menghasilkan tree di atas:

```dart
return Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon container
        Container(...),
        SizedBox(height: 12),
        // Value
        Text(value, style: ...),
        // Title
        Text(title, style: ...),
        // Optional subtitle
        if (subtitle != null) Text(subtitle!, style: ...),
      ],
    ),
  ),
);
```

**Widget tree = nesting.** Widget di luar "membungkus" widget di dalam. Setiap widget di Flutter bekerja seperti ini — kamu menggabungkan widget kecil untuk membuat UI yang kompleks.

### 2.4 Constructor Widget — Parameter

```dart
const StatCard({
  required this.title,
  required this.value,
  required this.icon,
  required this.color,
  this.subtitle,           // Optional — bisa diisi atau tidak
});
```

Sama seperti model di Tahap 1, widget juga punya constructor dengan parameter. Bedanya, widget ini punya parameter yang **required** dan yang **optional**.

Kalo ada parameter yang gak selalu diisi, gunakan **nullable** (`String?`):

```dart
final String? subtitle;   // Boleh null
```

### 2.5 Widget Dasar yang Dipake

| Widget | Fungsi |
|--------|--------|
| `Card` | Kotak dengan bayangan, untuk mengelompokkan konten |
| `Padding` | Memberi jarak di sekeliling widget anak |
| `Column` | Menata widget anak secara vertikal (ke bawah) |
| `Container` | Kotak serbaguna — bisa dikasih warna, border, padding |
| `Text` | Menampilkan teks |
| `Icon` | Menampilkan icon (dari Material Design icons) |
| `SizedBox` | Kotak transparan — biasa dipake untuk spasi |

### 2.6 `EdgeInsets` & `BorderRadius` — Jarak & Sudut

```dart
padding: const EdgeInsets.all(16),           // Jarak 16px di semua sisi
borderRadius: BorderRadius.circular(10),     // Sudut 10px melengkung
```

- `EdgeInsets.all(16)` — jarak 16 pixel di semua sisi (atas, kanan, bawah, kiri)
- `EdgeInsets.symmetric(horizontal: 12)` — jarak kiri+kanan saja
- `EdgeInsets.only(top: 8)` — jarak atas saja
- `BorderRadius.circular(10)` — semua sudut melengkung 10px
- `BorderRadius.only(topLeft: Radius.circular(4))` — sudut tertentu saja

### 2.7 Conditional Widget — Widget yang Muncul Bersyarat

```dart
Column(
  children: [
    Text('Title'),
    if (subtitle != null) Text(subtitle!),
    // ↑↑ Kalo subtitle null, widget ini gak dirender
  ],
)
```

Flutter mengizinkan `if` di dalam list `children:`. Ini sangat berguna untuk menampilkan widget hanya saat kondisi terpenuhi.

### 2.8 Null Assertion `!`

```dart
Text(subtitle!)
```

Tanda `!` disebut **null assertion** — artinya "saya jamin variable ini gak null". Ini perlu karena Dart marah kalo kita pake variable nullable tanpa memastikan dulu.

Sebelum pake `!`, kita udah ngecek `if (subtitle != null)`. Setelah cek itu, Dart seharusnya tahu bahwa subtitle gak null. Tapi kadang Dart tetap perlu dikasih tahu pake `!`.

### 2.9 `copyWith` — Modifikasi Style

```dart
Theme.of(context).textTheme.headlineSmall
    ?.copyWith(fontWeight: FontWeight.bold)
```

`copyWith` adalah method yang mengembalikan **salinan** dari style/style dengan beberapa properti diubah. Ini berguna untuk mengambil theme yang sudah ada dan memodifikasinya sedikit.

### Istilah Baru di Tahap 2

| Istilah | Arti |
|---------|------|
| **StatelessWidget** | Widget yang tampilannya tetap, tidak bisa berubah |
| **Widget tree** | Susunan widget (parent-child) |
| **Nullable** | Bisa bernilai null (ditandai `?`) |
| **Null assertion (`!`)** | "Saya yakin ini gak null" |
| **`EdgeInsets`** | Mengatur jarak/spasi |
| **`BorderRadius`** | Mengatur kelengkungan sudut |
| **Conditional widget** | Widget yang muncul hanya jika kondisi terpenuhi |
| **`copyWith`** | Method untuk membuat salinan dengan modifikasi |

### Latihan Tahap 2

1. **Buat widget `StatusBadge`:** Buat file baru `lib/widgets/status_badge.dart`. Widget ini menerima parameter `String label` dan `Color color`. Tampilkan teks dalam Container dengan background color dan border-radius 8.
2. **Tambah `onTap` di StatCard:** Jadikan `VoidCallback? onTap` sebagai parameter optional. Kalo diisi, bungkus Card dengan `GestureDetector` atau `InkWell`. Kalo null, tampilkan Card biasa.
3. **Eksperimen:** Ganti nilai `EdgeInsets.all(16)` jadi `EdgeInsets.all(8)` di StatCard. Hot reload dan lihat perubahannya.

---

## Tahap 3 — Provider & State Management

Di tahap ini, kamu akan belajar **state management** — cara Flutter mengelola data yang bisa berubah dan mengupdate UI secara otomatis.

Buka dua file:
- `lib/providers/transaction_provider.dart` — tempat state management
- `lib/main.dart` — tempat provider dipasang ke aplikasi

### 3.1 Apa Itu State?

**State** adalah data yang bisa berubah dan mempengaruhi tampilan.

Contoh state di aplikasi ini:
- Daftar transaksi (bertambah saat user tambah transaksi)
- Total penjualan hari ini (berubah saat ada transaksi baru)
- Halaman yang aktif di bottom nav

Di Flutter, ada dua jenis state:
1. **Local state** — state di dalam satu widget (pake `setState`, nanti di Tahap 5)
2. **Global state** — state yang dipake banyak widget (pake `Provider`, kita bahas sekarang)

### 3.2 ChangeNotifier — "Si Pemberi Tahu"

```dart
class TransactionProvider extends ChangeNotifier {
```

`ChangeNotifier` adalah class bawaan Flutter yang bisa **memberitahu** widget lain bahwa datanya berubah.

Bayangkan seperti ini:
- `ChangeNotifier` = pengeras suara di kantor
- `notifyListeners()` = "Ada pengumuman! Data berubah!"
- Widget yang `Consumer` = orang-orang yang mendengarkan pengumuman

### 3.3 Private List + Encapsulation

```dart
final List<Transaction> _transactions = [];
```

Lihat underscore `_` di depan `_transactions`. Di Dart, underscore berarti **private** — hanya bisa diakses dari dalam class ini saja.

```dart
List<Transaction> get transactions =>
    List.unmodifiable(_transactions);
```

`List.unmodifiable` membuat **salinan list yang tidak bisa diubah**. Jadi kalo ada widget yang coba nambah/hapus transaksi langsung dari getter ini, akan error.

**Kenama repot-repot pake private + unmodifiable?**

Ini pola **encapsulation** — melindungi data dari perubahan tak sengaja. Satu-satunya cara mengubah data adalah lewat method yang kita sediakan (`addTransaction`, `deleteTransaction`). Ini mencegah bug yang susah dilacak.

### 3.4 Consumer — Widget yang Rebuild Otomatis

Di `dashboard_screen.dart` (kita akan bahas detail di Tahap 4):

```dart
Consumer<TransactionProvider>(
  builder: (context, provider, _) {
    // provider = instance TransactionProvider
    // Kode di sini otomatis di-rebuild saat notifyListeners() dipanggil
    return Text(formatRupiah(provider.todayRevenue));
  },
)
```

**Cara kerja Consumer:**
1. `Consumer<TransactionProvider>` mendaftarkan diri ke provider
2. Saat `notifyListeners()` dipanggil (misal setelah addTransaction)
3. Consumer menjalankan ulang `builder` — UI di-update

### 3.5 context.watch vs context.read

Ada 3 cara mengakses provider:

```dart
// 1. Consumer — rebuild widget SAJA yang dibungkus Consumer
Consumer<TransactionProvider>(builder: ...)

// 2. context.watch — rebuild SELURUH widget
final provider = context.watch<TransactionProvider>();

// 3. context.read — akses TANPA rebuild
final provider = context.read<TransactionProvider>();
```

**Kapan pake yang mana?**

| Situasi | Pake |
|---------|------|
| Mau baca data dan rebuild saat berubah | `Consumer` atau `context.watch` |
| Mau panggil method (misal tombol hapus) | `context.read` |
| Hanya sebagian widget perlu rebuild | `Consumer` (lebih efisien) |

### 3.6 Computed Properties — Properti yang Dihitung

Lihat getter-getter di `TransactionProvider`:

| Getter | Sumber Data | Cara Hitung |
|--------|-------------|-------------|
| `todayTransactions` | `_transactions` | Filter berdasarkan tanggal |
| `todayRevenue` | `todayTransactions` | `fold` jumlah total |
| `todayCount` | `todayTransactions` | `.length` |
| `last7DaysRevenue` | `_transactions` | `List.generate` + `where` + `fold` |

```dart
double get todayRevenue =>
    todayTransactions.fold(0.0, (sum, t) => sum + t.total);
```

Ini disebut **computed property** — properti yang nilainya dihitung dari data lain. Kita gak nyimpan `todayRevenue` di field terpisah. Setiap kali diakses, nilainya dihitung ulang.

**Kenapa gak disimpan aja?**

Karena kalo disimpan, kita harus ingat meng-update `todayRevenue` setiap kali ada transaksi baru. Kalo lupa update, datanya salah. Dengan computed property, nilainya selalu akurat.

### 3.7 ChangeNotifierProvider

Di `lib/main.dart`:

```dart
ChangeNotifierProvider(
  create: (_) => TransactionProvider()..seedSampleData(),
  child: MaterialApp(
    ...
  ),
)
```

`ChangeNotifierProvider` adalah widget yang **menyediakan** provider ke seluruh widget di dalamnya. Semua widget di dalam `MaterialApp` bisa mengakses `TransactionProvider`.

### 3.8 Cascade Notation (..)

```dart
TransactionProvider()..seedSampleData()
//                   ^^
```

**Cascade notation** (`..`) adalah fitur Dart untuk memanggil method pada object yang baru dibuat, tanpa perlu menyimpannya ke variable dulu.

Kode di atas sama dengan:
```dart
final provider = TransactionProvider();
provider.seedSampleData();
return provider;
```

Lebih ringkas, kan?

### Istilah Baru di Tahap 3

| Istilah | Arti |
|---------|------|
| **State** | Data yang bisa berubah dan mempengaruhi UI |
| **ChangeNotifier** | Class yang bisa memberitahu widget saat data berubah |
| **`notifyListeners()`** | Panggil ini setelah data berubah agar UI di-rebuild |
| **Consumer** | Widget yang rebuild otomatis saat data provider berubah |
| **Encapsulation** | Melindungi data dengan private + getter/method |
| **Computed property** | Properti yang dihitung dari data lain |
| **Cascade notation** | `..` — panggil method pada object tanpa variable |

### Latihan Tahap 3

1. **Tambah computed property:** Di `TransactionProvider`, tambah getter `int get totalItemsSoldAllTime` yang menghitung total quantity dari SEMUA transaksi (pake `fold`).
2. **Tambah method hapus semua:** Buat method `void clearAllTransactions()` yang mengosongkan list dan panggil `notifyListeners()`. Tambahkan tombol di dashboard untuk memanggilnya.
3. **Consumer kecil:** Di `MainScreen`, tambah `Consumer<TransactionProvider>` di AppBar yang menampilkan teks "Hari ini: X transaksi". (Petunjuk: lihat bagaimana AppBar title diatur di `main.dart`)

---

## Tahap 4 — Dashboard: Layout & Grafik

Di tahap ini, kamu akan belajar **layout Flutter** (cara menata widget) dan **grafik** dengan package `fl_chart`.

Buka file `lib/screens/dashboard_screen.dart`.

### 4.1 Scaffold & AppBar

```dart
Scaffold(
  appBar: AppBar(title: const Text('Dashboard')),
  body: ...,
)
```

**`Scaffold`** adalah struktur dasar halaman Flutter. Di dalamnya, atur:
- `appBar` — bar di atas halaman
- `body` — konten utama
- `bottomNavigationBar` — navigasi bawah (di `main.dart`)

### 4.2 RefreshIndicator — Tarik untuk Refresh

```dart
RefreshIndicator(
  onRefresh: () async {
    // Kode yang dijalankan saat user tarik layar ke bawah
  },
  child: ListView(...),
)
```

`RefreshIndicator` memungkinkan user menarik layar ke bawah untuk me-refresh data.

### 4.3 Row & Column — Menata Widget

Flutter punya dua widget utama untuk tata letak:

**`Column`** — menata widget dari atas ke bawah (vertikal):
```
Column
  ├── Widget 1 (atas)
  ├── Widget 2 (tengah)
  └── Widget 3 (bawah)
```

**`Row`** — menata widget dari kiri ke kanan (horizontal):
```
Row
  ├── Widget 1 (kiri)
  ├── Widget 2 (tengah)
  └── Widget 3 (kanan)
```

**`Expanded`** — membagi ruang secara proporsional:

```dart
Row(
  children: [
    Expanded(child: StatCard(...)),   // 50%
    SizedBox(width: 12),              // jarak 12px
    Expanded(child: StatCard(...)),   // 50%
  ],
)
```

Dua `Expanded` berarti masing-masing mendapat 50% lebar. Kalo satu pake `flex: 2` dan satu `flex: 1`, berarti 2/3 dan 1/3.

**`SizedBox`** — widget transparan untuk spasi:
```dart
SizedBox(width: 12)   // Spasi horizontal 12px
SizedBox(height: 16)  // Spasi vertikal 16px
```

### 4.4 Layout Dashboard

Dashboard terdiri dari:

```
Column
  ├── Header (judul + tanggal)
  ├── Row 1: [StatCard: Penjualan Hari Ini] [StatCard: Total Transaksi]
  ├── Row 2: [StatCard: Item Terjual]      [StatCard: Total Pendapatan]
  ├── Grafik Penjualan 7 Hari
  └── Recent Transactions (5 transaksi terbaru)
```

Perhatikan kodenya:

```dart
// Baris 1: dua kartu
Row(
  children: [
    Expanded(
      child: StatCard(
        title: 'Penjualan Hari Ini',
        value: formatRupiah(provider.todayRevenue),
        icon: Icons.trending_up_rounded,
        color: Colors.green,
        subtitle: '${provider.todayCount} transaksi',
      ),
    ),
    SizedBox(width: 12),  // Jarak antar kartu
    Expanded(
      child: StatCard(
        title: 'Total Transaksi',
        value: '${provider.transactions.length}',
        icon: Icons.receipt_long_rounded,
        color: Colors.blue,
      ),
    ),
  ],
),
```

### 4.5 Grafik dengan fl_chart

Grafik di dashboard menggunakan package **fl_chart**. Struktur hierarkinya:

```
BarChart
  └── BarChartData
        ├── barGroups → List<BarChartGroupData>
        │     └── barRods → List<BarChartRodData>
        ├── titlesData → FlTitlesData (label sumbu)
        ├── gridData → FlGridData (garis bantu)
        └── borderData → FlBorderData (border chart)
```

Data grafik berasal dari `provider.last7DaysRevenue`:

```dart
// Di provider
List<double> get last7DaysRevenue {
  final now = DateTime.now();
  return List.generate(7, (i) {
    final day = now.subtract(Duration(days: 6 - i));
    return _transactions
        .where((t) =>
            t.date.year == day.year &&
            t.date.month == day.month &&
            t.date.day == day.day)
        .fold(0.0, (sum, t) => sum + t.total);
  });
}
```

**`List.generate(7, (i) => ...)`** — membuat list dengan 7 element. Setiap element dihitung dengan fungsi berdasarkan index `i`.

**Safety maxY:**

```dart
final maxRevenue = chartRevenue.isEmpty
    ? 0.0
    : chartRevenue.reduce((a, b) => a > b ? a : b);
final maxY = maxRevenue > 0 ? maxRevenue * 1.3 : 100000.0;
```

Kalo `maxY = 0`, grafik bisa error. Makanya ada fallback: kalo semua data 0, pake `maxY = 100000.0`.

### 4.6 Tooltip Interaktif

```dart
barTouchData: BarTouchData(
  enabled: true,
  touchTooltipData: BarTouchTooltipData(
    getTooltipItem: (group, groupIndex, rod, rodIndex) {
      return BarTooltipItem(
        formatRupiah(rod.toY),  // Format pake helper
        TextStyle(color: Colors.white),
      );
    },
  ),
),
```

Tooltip muncul saat user menyentuh bar — menampilkan nominal dalam format Rupiah.

### 4.7 Recent Transactions — Spread Operator

```dart
...provider.transactions.take(5).map((t) => _TransactionCard(
    transaction: t,
    onDelete: () => provider.deleteTransaction(t.id),
)),
```

**Spread operator `...`** — mengambil semua element dari list dan memasukkannya satu per satu ke dalam `children`.

Tanpa spread:
```dart
children: [
  Card(...),
  Card(...),
  Card(...),
]
```

Dengan spread:
```dart
children: [
  Text('Transaksi Terbaru'),
  ...listOfCards,  // Semua element list jadi children
]
```

### Istilah Baru di Tahap 4

| Istilah | Arti |
|---------|------|
| **Scaffold** | Struktur dasar halaman Flutter |
| **Row / Column** | Widget untuk menata widget secara horizontal/vertikal |
| **Expanded** | Membagi ruang proporsional |
| **SizedBox** | Widget spasi transparan |
| **Spread operator (`...`)** | Memasukkan element list ke dalam collection |
| **`List.generate`** | Membuat list dengan fungsi per index |
| **Tooltip** | Info yang muncul saat user menyentuh elemen |

### Latihan Tahap 4

1. **Ganti warna grafik:** Ubah `color: Colors.blue[400]` di bar chart jadi gradient (`Colors.blue[400]` untuk ganjil, `Colors.blue[200]` untuk genap).
2. **Tambah stat card:** Tambah kartu kelima di dashboard: "Rata-rata per Transaksi". (Petunjuk: `totalRevenue / transactions.length` — handle case kalo list kosong).
3. **Ubah jumlah recent items:** Ganti `.take(5)` jadi `.take(3)`. Lihat perubahannya.

---

## Tahap 5 — Form Tambah Transaksi: Input & Validasi

Di tahap ini, kamu akan belajar **form**, **input**, dan **StatefulWidget**. Kamu akan membaca `lib/screens/add_transaction_screen.dart`.

Buka file tersebut.

### 5.1 StatefulWidget — Widget dengan State

```dart
class AddTransactionScreen extends StatefulWidget {
  ...
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  ...
}
```

Berbeda dengan `StatelessWidget` yang tampilannya tetap, **`StatefulWidget`** punya **state** yang bisa berubah selama widget hidup.

**Dua class untuk satu widget:**
1. `AddTransactionScreen` — konfigurasi widget (parameter yang diterima)
2. `_AddTransactionScreenState` — state dan logic yang bisa berubah

### 5.2 setState — Trigger Rebuild

```dart
setState(() {
  _items.add(_ItemEntry(name: name, quantity: qty, price: price));
});
```

**`setState()`** adalah cara memberi tahu Flutter: "Ada data yang berubah, rebuild widget ini!".

Kapan pake `setState`?
- User menambah/menghapus item di form
- User mengganti metode pembayaran
- Data lokal berubah

> **Penting:** Kalo lupa panggil `setState`, UI TIDAK akan berubah meskipun datanya udah diupdate!

### 5.3 TextEditingController

```dart
final _itemNameCtrl = TextEditingController();
```

**`TextEditingController`** adalah jembatan antara input teks di layar dengan kode. Lewat controller, kita bisa:
- Membaca teks yang diketik user: `_itemNameCtrl.text`
- Mengosongkan input: `_itemNameCtrl.clear()`
- Mengisi input dari kode: `_itemNameCtrl.text = 'Beras'`

### 5.4 Form & GlobalKey

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: ...,
)
```

**`GlobalKey<FormState>()`** adalah kunci untuk mengakses state dari widget `Form`. Lewat key ini, kita bisa:

```dart
if (!_formKey.currentState!.validate()) return;
```

Method `validate()` menjalankan validator di semua `TextFormField`. Kalo ada yang gak valid, form otomatis menampilkan pesan error dan `validate()` return `false`.

### 5.5 TextFormField & Validator

```dart
TextFormField(
  controller: _customerCtrl,
  decoration: const InputDecoration(labelText: 'Nama Pelanggan'),
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama pelanggan wajib diisi';
    }
    return null;  // null = valid
  },
)
```

`validator` adalah fungsi yang:
- Return `String?` — kalo ada pesan error, tampilkan pesan itu
- Return `null` — input valid

### 5.6 tryParse — Konversi String ke Angka

```dart
final qty = int.tryParse(_itemQtyCtrl.text) ?? 0;
final price = double.tryParse(_itemPriceCtrl.text) ?? 0;
```

**`tryParse`** adalah method yang mencoba mengubah string menjadi angka. Kalo gagal (misal user ngetik "abc"), return `null`.

`int.tryParse('42')` → `42`
`int.tryParse('abc')` → `null`
`int.tryParse('abc') ?? 0` → `0` (null diganti 0)

### 5.7 Dynamic Item List

Form ini unik karena user bisa menambah **jumlah item yang tidak tetap**. Ada 3 bagian:

**1. Daftar item yang sudah ditambah:**
```dart
ListView.builder(
  itemCount: _items.length,
  itemBuilder: (context, index) {
    final item = _items[index];
    return Card(
      child: ListTile(
        title: Text(item.name),
        subtitle: Text('${item.quantity}x @ ${formatRupiah(item.price)}'),
        trailing: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => setState(() => _items.removeAt(index)),
        ),
      ),
    );
  },
)
```

**2. Form input item baru:**
```dart
Row(
  children: [
    Expanded(flex: 2, child: TextField(controller: _itemNameCtrl, ...)),
    Expanded(child: TextField(controller: _itemQtyCtrl, ...)),
    Expanded(child: TextField(controller: _itemPriceCtrl, ...)),
    IconButton(icon: Icon(Icons.add), onPressed: _addItem),
  ],
)
```

**3. Method `_addItem`:**
```dart
void _addItem() {
  final name = _itemNameCtrl.text.trim();
  final qty = int.tryParse(_itemQtyCtrl.text) ?? 0;
  final price = double.tryParse(_itemPriceCtrl.text) ?? 0;

  if (name.isEmpty || qty <= 0 || price <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Isi nama, qty, dan harga item dengan benar')),
    );
    return;
  }

  setState(() {
    _items.add(_ItemEntry(name: name, quantity: qty, price: price));
    _itemNameCtrl.clear();
    _itemQtyCtrl.clear();
    _itemPriceCtrl.clear();
  });
}
```

### 5.8 AnimatedContainer

```dart
AnimatedContainer(
  duration: Duration(milliseconds: 200),
  decoration: BoxDecoration(
    color: selected ? Colors.blue[50] : Colors.grey[100],
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: selected ? Colors.blue : Colors.grey[300]!,
      width: selected ? 2 : 1,
    ),
  ),
  child: ...
)
```

**`AnimatedContainer`** adalah `Container` yang **menganimasikan** perubahannya sendiri. Cukup ubah properti lewat `setState`, Flutter yang handle transisi animasinya.

Di form ini, chip pembayaran berubah warna dan border saat dipilih — animasi 200ms.

### 5.9 SnackBar — Feedback ke User

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Isi nama, qty, dan harga item dengan benar')),
);
```

**SnackBar** adalah notifikasi kecil yang muncul di bawah layar. Cocok untuk feedback cepat: sukses, error, info.

### 5.10 Navigator — Pindah Halaman

```dart
// Buka halaman form
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
);

// Kembali ke halaman sebelumnya
Navigator.of(context).pop();
```

**Navigator** mengelola tumpukan (stack) halaman. `push` menambahkan halaman baru di atas, `pop` menghapus halaman yang sedang aktif dan kembali ke halaman sebelumnya.

### Istilah Baru di Tahap 5

| Istilah | Arti |
|---------|------|
| **StatefulWidget** | Widget dengan state yang bisa berubah |
| **setState** | Method untuk trigger rebuild widget |
| **TextEditingController** | Jembatan antara input teks dan kode |
| **GlobalKey** | Kunci untuk mengakses state widget |
| **Validator** | Fungsi yang ngecek apakah input valid |
| **tryParse** | Konversi string ke angka, return null kalo gagal |
| **SnackBar** | Notifikasi kecil di bawah layar |
| **Navigator** | Mengelola tumpukan halaman (push/pop) |
| **AnimatedContainer** | Container dengan animasi otomatis |

### Latihan Tahap 5

1. **Tambah field telepon:** Tambah `TextFormField` untuk nomor telepon dengan validator: minimal 10 digit, hanya angka.
2. **Tombol batal:** Tambah tombol "Batal" di samping tombol "Simpan". Kalo ditekan, tampilkan dialog konfirmasi (`showDialog` with `AlertDialog`) sebelum `Navigator.pop()`.
3. **Format ID:** Ganti ID dari `DateTime.now().millisecondsSinceEpoch.toString()` jadi format "TRX-001", "TRX-002" — auto increment berdasarkan jumlah transaksi yang sudah ada.

---

## Tahap 6 — Daftar Transaksi: List & Navigasi

Di tahap ini, kamu akan belajar **ListView**, **ExpansionTile**, dan **bottom navigation**.

Buka file `lib/screens/transactions_screen.dart` dan `lib/main.dart` (bagian bottom nav).

### 6.1 ListView.builder — List Efisien

```dart
ListView.builder(
  itemCount: transactions.length,
  itemBuilder: (context, index) {
    final transaction = transactions[index];
    return _buildTransactionCard(transaction);
  },
)
```

**`ListView.builder`** adalah widget untuk menampilkan list dengan efisien. Bedanya dengan `Column` yang berisi banyak widget:

- **Column** — semua widget di-render dari awal, bahkan yang gak kelihatan
- **ListView.builder** — hanya widget yang terlihat di layar yang di-render. Sisanya di-render saat di-scroll ke bawah.

Ini penting untuk performa. Kalo ada 1000 transaksi, `Column` akan nge-render 1000 card sekaligus. `ListView.builder` hanya nge-render ~10 card yang kelihatan.

### 6.2 ExpansionTile — Widget Expandable

```dart
ExpansionTile(
  leading: _paymentAvatar(t.paymentMethod),
  title: Text(t.customerName),
  subtitle: Text('${t.formattedDate} · ${t.paymentLabel}'),
  children: [
    ...t.items.map((item) => Row(
      children: [
        Expanded(flex: 3, child: Text(item.name)),
        SizedBox(width: 60, child: Text('${item.quantity}x')),
        SizedBox(width: 100, child: Text(formatRupiah(item.price))),
        SizedBox(width: 100, child: Text(formatRupiah(item.subtotal))),
      ],
    )),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Total Item: ${t.totalItems}'),
        Text(formatRupiah(t.total)),
      ],
    ),
    OutlinedButton.icon(onPressed: ..., ...),
  ],
)
```

**`ExpansionTile`** adalah list item yang bisa di-expand/di-collapse. Pas di-tap, bagian `children` muncul dengan animasi.

**Item row layout:**
```
[ Nama Barang ]    [ 2x ]    [ Rp18.000 ]    [ Rp36.000 ]
    flex: 3         60px        100px           100px
```

### 6.3 Empty State

```dart
if (transactions.isEmpty) {
  return Center(
    child: Column(
      children: [
        Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[300]),
        Text('Belum ada transaksi'),
        Text('Tap + untuk menambah transaksi baru'),
      ],
    ),
  );
}
```

**Empty state** adalah tampilan yang muncul saat data kosong. Ini penting untuk UX — user tahu bahwa aplikasi berfungsi, cuma belum ada data.

### 6.4 Bottom Navigation

Di `lib/main.dart`:

```dart
bottomNavigationBar: NavigationBar(
  selectedIndex: _currentIndex,
  onDestinationSelected: (i) => setState(() => _currentIndex = i),
  destinations: const [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard_rounded),
      label: 'Dashboard',
    ),
    NavigationDestination(
      icon: Icon(Icons.receipt_long_outlined),
      selectedIcon: Icon(Icons.receipt_long_rounded),
      label: 'Transaksi',
    ),
  ],
),
```

`NavigationBar` adalah bottom navigation versi Material 3. Setiap tab punya icon (biasa dan aktif) serta label.

### 6.5 IndexedStack vs PageView

```dart
body: IndexedStack(
  index: _currentIndex,
  children: _screens,
),
```

**`IndexedStack`** — semua halaman tetap di-memory (state tersimpan). Cocok untuk tab navigasi.
**`PageView`** — halaman di luar viewport bisa di-dispose. Cocok untuk onboarding/wizard.

Kalo pake `PageView`, setiap ganti tab, halaman di-render ulang dari awal. `IndexedStack` lebih cocok untuk dashboard dan daftar transaksi yang state-nya perlu dipertahankan.

### Istilah Baru di Tahap 6

| Istilah | Arti |
|---------|------|
| **ListView.builder** | Widget list efisien — render item yang terlihat saja |
| **ExpansionTile** | Item list yang bisa di-expand |
| **Empty state** | Tampilan saat data kosong |
| **NavigationBar** | Bottom navigation Material 3 |
| **IndexedStack** | Menyimpan state semua tab |

### Latihan Tahap 6

1. **Tambah sorting:** Tambah dropdown atau tombol untuk mengurutkan transaksi: Terbaru, Tertua, Tertinggi. (Petunjuk: pake method `..sort()` bawaan list).
2. **Badge notifikasi:** Tambah badge di `NavigationDestination` "Transaksi" yang menampilkan jumlah transaksi hari ini. (Petunjuk: cek properti `badge` di NavigationDestination).
3. **Halaman detail:** Ganti `ExpansionTile` jadi tap untuk navigasi ke halaman detail transaksi terpisah. Buat screen baru `TransactionDetailScreen`.
