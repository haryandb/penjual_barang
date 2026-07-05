# Restruktur Panduan Belajar — Flutter Seller Dashboard

**Tanggal:** 5 Juli 2026
**Status:** Final (disetujui user via brainstorming)

---

## 1. Latar Belakang

Dokumen `docs/panduan-belajar.md` saat ini berisi dokumentasi teknis yang menjelaskan kode project Flutter Seller Dashboard dari atas ke bawah. Untuk dijadikan materi pembelajaran mahasiswa baru (belum pernah programming), dokumentasi perlu diubah menjadi **project-based learning** dengan:
- Target: **benar-benar dari nol** (tidak ada pengalaman programming)
- Pendekatan: **per-komponen project** (belajar sambil membaca kode project)
- Dilengkapi: **soal latihan** di setiap bab

---

## 2. Struktur Materi

### Tahap 0: Persiapan & "Halo Flutter" (~5 halaman)
- Install Flutter SDK, VS Code, emulator/HP fisik
- Clone project, `flutter pub get`, `flutter run`
- Hot reload demo
- Pengenalan struktur folder project
- **Latihan:** ganti warna tema, ganti nama AppBar

### Tahap 1: Model — Belajar Dart Lewat Data Transaksi (~8 halaman)
- Buka `lib/models/transaction.dart`
- Variable & tipe data: `String`, `int`, `double`
- `final` — immutability
- Class & constructor, `required` keyword, `this.`
- Object literal
- Getter: `double get subtotal => quantity * price`
- String interpolation: `${expression}`
- List & `fold` untuk akumulasi
- Switch-case untuk payment label
- Array index offset (`date.month - 1`)
- **Latihan:** tambah field `discount`, buat model `Customer`

### Tahap 2: StatCard — Widget Flutter Pertama (~6 halaman)
- Buka `lib/widgets/stat_card.dart`
- `StatelessWidget` vs `StatefulWidget` (pengertian awal)
- `build(BuildContext context)` — return widget tree
- Widget tree visual: Card > Padding > Column > Container/Text
- Parameter widget: `required` vs optional (`String?`)
- Widget dasar: `Card`, `Padding`, `Column`, `Container`, `Text`, `Icon`
- `BorderRadius`, `EdgeInsets`
- Conditional widget: `if (subtitle != null) Text(subtitle!)`
- Null assertion `!`
- `copyWith`
- **Latihan:** buat `StatusBadge` widget, tambah `onTap` di StatCard

### Tahap 3: Provider & State Management (~8 halaman)
- Buka `lib/providers/transaction_provider.dart` dan `lib/main.dart`
- Konsep state — data yang bisa berubah
- `ChangeNotifier` + `notifyListeners()`
- `Consumer<T>` — rebuild otomatis
- `context.watch<T>` vs `context.read<T>` (kapan pake yang mana)
- Encapsulation: private `_transactions` + `List.unmodifiable`
- Computed properties: `todayRevenue`, `last7DaysRevenue`
- `ChangeNotifierProvider` di root widget
- Cascade notation `..`: `TransactionProvider()..seedSampleData()`
- **Latihan:** tambah computed property, tambah method `clearAllTransactions()`

### Tahap 4: Dashboard Screen — Layout & Grafik (~10 halaman)
- Buka `lib/screens/dashboard_screen.dart`
- `Scaffold`, `AppBar`, `RefreshIndicator`
- `Column`, `Row`, `Expanded`, `SizedBox`
- Grid stat cards (4 kartu dalam 2 baris)
- Grafik fl_chart: `BarChart` > `BarChartData` > `BarChartGroupData`
- Safety fallback `maxY`
- Tooltip interaktif
- `.take(5)`, spread operator `...`
- `_TransactionCard` private widget
- Date format manual (array hari/bulan Indonesia)
- **Latihan:** ganti warna grafik, tambah card kelima, ganti jumlah recent items

### Tahap 5: Form Tambah Transaksi — Input & Validasi (~10 halaman)
- Buka `lib/screens/add_transaction_screen.dart`
- `StatefulWidget` (dengan state lokal)
- `setState()` — trigger rebuild
- `TextEditingController`
- `Form` + `GlobalKey<FormState>` — validasi
- `TextFormField` + validator
- `tryParse` pattern: `int.tryParse(text) ?? 0`
- Dynamic item list: `List<_ItemEntry>` dengan add/remove
- `AnimatedContainer` — animasi otomatis
- `GestureDetector`
- `Navigator.push()` / `pop()`
- `SnackBar` — feedback ke user
- **Latihan:** tambah field telepon, tombol batal, ganti ID format

### Tahap 6: Daftar Transaksi — List & Navigasi (~7 halaman)
- Buka `lib/screens/transactions_screen.dart`
- `ListView.builder` — render efisien
- `ExpansionTile` — expandable list item
- Empty state pattern
- Bottom nav `NavigationBar` + `IndexedStack`
- Item row dengan `Expanded(flex:)` + `SizedBox` fixed
- Delete button
- `_paymentAvatar` helper function
- **Latihan:** sorting, badge di bottom nav, halaman detail terpisah

### Tahap 7: Utility — Error Handling & Formatting (~5 halaman)
- Buka `lib/utils/currency_helper.dart`
- Top-level function
- `NumberFormat.currency` — masalah locale Indonesia
- `try-catch` cascade (3 level fallback)
- Regex separator ribuan: `(\d)(?=(\d{3})+(?!\d))`
- Positive & negative lookahead
- `replaceAllMapped`
- **Latihan:** `formatDate` dengan fallback pattern, `parseRupiah`

### Tahap 8: Widget Testing (~6 halaman)
- Buka `test/app_test.dart`
- Kenapa testing penting
- `testWidgets`, `pumpWidget`, `pumpAndSettle`
- `setUpAll` untuk locale
- Finder: `find.text()`, `find.textContaining()`, `find.widgetWithText()`
- Matcher: `findsOneWidget`, `findsWidgets`, `findsNothing`
- Simulasi tap & enterText
- **Latihan:** test submit form, test hapus transaksi

### Tahap 9: CI/CD dengan GitHub Actions (~4 halaman)
- Buka `.github/workflows/build-debug-apk.yml`
- Konsep CI/CD
- Trigger: push, PR, manual
- Steps: checkout → setup Java → setup Flutter → analyze → test → build → upload
- Download APK dari artifact
- **Latihan:** tambah notifikasi gagal, tambah build appbundle

### Penutup (~2 halaman)
- Tabel ringkasan konsep → implementasi
- Daftar istilah (glossary)
- Next steps pengembangan

---

## 3. Prinsip Penulisan

1. **Bahasa Indonesia** — seluruh materi ditulis dalam Bahasa Indonesia
2. **Tidak ada asumsi pengetahuan sebelumnya** — setiap istilah teknis dijelaskan pertama kali muncul
3. **Kode langsung dari project** — semua contoh kode merujuk ke file di project ini
4. **Satu konsep per sub-bab** — tidak mencampur multiple konsep baru dalam satu sub-bab
5. **Latihan relevan** — latihan memodifikasi project, bukan soal abstrak
6. **Visual widget tree** — diagram struktur widget untuk memudahkan pemahaman

---

## 4. Glossary (Istilah yang akan dijelaskan)

| Istilah | Muncul di Tahap |
|---------|-----------------|
| SDK, emulator, hot reload | 0 |
| pubspec, dependency | 0 |
| variable, tipe data, String, int, double | 1 |
| class, constructor, object, instance | 1 |
| final, required, this | 1 |
| getter, method | 1 |
| List, fold, where, map | 1, 3 |
| interpolation, switch-case | 1 |
| StatelessWidget, StatefulWidget | 2, 5 |
| widget tree, build method | 2 |
| Card, Padding, Column, Container, Text, Icon | 2 |
| nullable, null assertion, conditional widget | 2 |
| state, state management, ChangeNotifier | 3 |
| Provider, Consumer, context | 3 |
| encapsulation, unmodifiable | 3 |
| computed property | 3 |
| cascade notation | 3 |
| Scaffold, AppBar, RefreshIndicator | 4 |
| Row, Column, Expanded | 4 |
| fl_chart, BarChart, tooltip | 4 |
| spread operator, take, map | 4 |
| TextEditingController, Form, validator | 5 |
| tryParse, SnackBar, Navigator | 5 |
| AnimatedContainer, GestureDetector | 5 |
| ListView.builder, ExpansionTile | 6 |
| NavigationBar, IndexedStack | 6 |
| empty state | 6 |
| top-level function | 7 |
| try-catch, fallback | 7 |
| regex, lookahead | 7 |
| testing, testWidgets, pumpWidget | 8 |
| finder, matcher | 8 |
| CI/CD, GitHub Actions, workflow | 9 |
| artifact | 9 |

---

## 5. File Output

Dokumen final akan ditulis ke: `docs/panduan-belajar.md`
(Mengganti konten yang sudah ada dengan struktur baru ini.)
