# Flutter Seller Dashboard — Panduan Belajar + Coding

Aplikasi Flutter untuk manajemen transaksi penjualan. Semua data disimpan **di memory (array)** — tanpa database, tanpa API. Cocok untuk belajar Flutter tingkat pemula - menengah.

**Repo:** https://github.com/haryandb/penjual_barang

---

## 📋 Daftar Isi

1. [Arsitektur Project](#1-arsitektur-project)
2. [Model & Data](#2-model--data)
3. [State Management dengan Provider](#3-state-management-dengan-provider)
4. [Dashboard & Grafik](#4-dashboard--grafik)
5. [Form Tambah Transaksi (Dynamic Form)](#5-form-tambah-transaksi-dynamic-form)
6. [Daftar Transaksi (Expandable List)](#6-daftar-transaksi-expandable-list)
7. [Widget Reusable: StatCard](#7-widget-reusable-statcard)
8. [Format Rupiah & Locale Fallback](#8-format-rupiah--locale-fallback)
9. [Widget Testing](#9-widget-testing)
10. [CI/CD dengan GitHub Actions](#10-cicd-dengan-github-actions)

---

## 1. Arsitektur Project

### Struktur Folder

```
penjual_barang/
├── lib/
│   ├── main.dart                         # Entry point + bottom navigation
│   ├── models/
│   │   └── transaction.dart              # Struktur data transaksi
│   ├── providers/
│   │   └── transaction_provider.dart     # State management (ChangeNotifier)
│   ├── screens/
│   │   ├── dashboard_screen.dart         # Dashboard + grafik penjualan
│   │   ├── transactions_screen.dart      # Daftar semua transaksi
│   │   └── add_transaction_screen.dart   # Form tambah transaksi
│   ├── widgets/
│   │   └── stat_card.dart                # Widget kartu statistik reusable
│   └── utils/
│       └── currency_helper.dart          # Helper format rupiah
├── test/
│   └── app_test.dart                     # Widget testing
└── .github/workflows/
    └── build-debug-apk.yml               # CI/CD workflow
```

### Alur Data

```
User Input (Form)
    ↓
Provider (ChangeNotifier)  ←→  Model (Transaction)
    ↓
UI (Consumer Widget)
```

- **Model** — struktur data transaksi (plain Dart class)
- **Provider** — tempat penyimpanan data di memory, logic bisnis, computed properties
- **UI** — consumer widget yang rebuild otomatis saat data berubah

### Kenapa Provider?

| State Management | Cocok Untuk |
|---|---|
| **Provider** | Aplikasi kecil-menegah, CRUD sederhana |
| Bloc/Cubit | Aplikasi kompleks dengan banyak event stream |
| Riverpod | Aplikasi yang butuh dependency injection kuat |
| GetX | Aplikasi yang butuh routing + state management all-in-one |

**Kesimpulan:** Untuk kasus ini (transaksi CRUD tanpa API), Provider是最 simpel dan paling ringan.

---

## 2. Model & Data

### File: `lib/models/transaction.dart`

```dart
class TransactionItem {
  String name;       // Nama barang
  int quantity;      // Jumlah
  double price;      // Harga satuan

  TransactionItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  /// Getter: subtotal = quantity × price
  /// Kenapa getter? Karena nilainya dihitung dari properti lain,
  /// gak perlu disimpan sebagai field terpisah.
  double get subtotal => quantity * price;
}
```

**Pembahasan:**
- `required` keyword — semua parameter wajib diisi, gak boleh null
- **Getter** (`get subtotal`) — method tanpa parameter yang dipanggil seperti properti. Di sini dipakai karena `subtotal` selalu dihitung dari `quantity * price`, jadi gak perlu disimpan. Ini bedanya:

  ```dart
  // ❌ Kalau pake method: panggil dengan ()
  item.subtotal()

  // ✅ Kalau pake getter: panggil tanpa ()
  item.subtotal
  ```

```dart
class Transaction {
  final String id;                    // ID unik (timestamp)
  final String customerName;          // Nama pelanggan
  final List<TransactionItem> items;  // Daftar barang
  final DateTime date;                // Tanggal transaksi
  final String paymentMethod;         // cash | transfer | qris

  Transaction({
    required this.id,
    required this.customerName,
    required this.items,
    required this.date,
    this.paymentMethod = 'cash',      // Default: Tunai
  });
```

**Pembahasan:**
- `final` — field tidak bisa diubah setelah object dibuat (immutable). Cocok untuk data transaksi yang udah terjadi
- `this.paymentMethod = 'cash'` — **default value**. Kalo gak diisi pas bikin object, otomatis jadi 'cash'

```dart
  /// Total harga: jumlah dari semua subtotal item
  /// pakai [fold] untuk akumulasi nilai dari list
  double get total =>
      items.fold(0, (sum, item) => sum + item.subtotal);

  /// Total jumlah item (semua quantity dijumlah)
  int get totalItems =>
      items.fold(0, (sum, item) => sum + item.quantity);
```

**Pembahasan `fold`:**

```dart
// fold(initialValue, (accumulator, element) => ...)
items.fold(0, (sum, item) => sum + item.subtotal)
//       ^                 ^
//   nilai awal    sum = accumulator, item = element list
```

`fold` mirip `reduce`, tapi bedanya:
- `reduce` — minimal harus ada 1 element, return type sama dengan element
- `fold` — bisa untuk list kosong, return type bisa beda dengan element

```dart
  /// Format tanggal: "5 Jul 2026"
  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
    //                           ^^^^^^^^
    // months index 0-based, sedangkan date.month 1-based
  }
```

**Pembahasan:**
- **Index offset:** `date.month` return 1-12, tapi array index 0-11. Makanya pake `date.month - 1`
- **String interpolation:** `${expression}` di Dart

```dart
  /// Label metode pembayaran dalam Bahasa Indonesia
  String get paymentLabel {
    switch (paymentMethod) {
      case 'cash':     return 'Tunai';
      case 'transfer': return 'Transfer';
      case 'qris':     return 'QRIS';
      default:         return paymentMethod;
    }
  }
```

---

## 3. State Management dengan Provider

### File: `lib/providers/transaction_provider.dart`

```dart
class TransactionProvider extends ChangeNotifier {
  /// Private list — hanya bisa diakses via method/getter yang kita sediakan
  final List<Transaction> _transactions = [];

  /// Public getter: return salinan list (immutable dari luar)
  List<Transaction> get transactions =>
      List.unmodifiable(_transactions);
```

**Kenapa private + `List.unmodifiable`?**

Ini pola **encapsulation**: data cuma bisa diubah lewat method yang kita sediakan (`addTransaction`, `deleteTransaction`), bukan langsung dari luar. `List.unmodifiable` mencegah UI mengubah list secara tidak sengaja.

```dart
  /// Transaksi hari ini — difilter berdasarkan tanggal sekarang
  List<Transaction> get todayTransactions {
    final now = DateTime.now();
    return _transactions.where((t) =>
        t.date.year == now.year &&
        t.date.month == now.month &&
        t.date.day == now.day
    ).toList();
  }
```

**`where` — filter list:**
```dart
_transactions.where((t) => kondisi).toList()
//                 ^
//   predicate: return true untuk item yang lolos filter
```

```dart
  /// Total pendapatan hari ini
  double get todayRevenue =>
      todayTransactions.fold(0.0, (sum, t) => sum + t.total);

  /// Jumlah transaksi hari ini
  int get todayCount => todayTransactions.length;
```

### Computed Properties

**Computed property** = properti yang nilainya dihitung otomatis dari data lain, bukan disimpan sebagai field. Contoh:

| Properti | Sumber Data | Method |
|---|---|---|
| `todayRevenue` | `todayTransactions` | `fold` |
| `todayCount` | `todayTransactions` | `length` |
| `totalRevenue` | `_transactions` | `fold` |
| `last7DaysRevenue` | `_transactions` | `List.generate` + `where` |

```dart
  /// Revenue 7 hari terakhir (untuk grafik)
  List<double> get last7DaysRevenue {
    final now = DateTime.now();
    return List.generate(7, (i) {
      // Hari ke-6 sampai hari ini (7 hari)
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

**`List.generate` pattern:**
```dart
List.generate(jumlah, (index) => value_for_index)
// Berguna untuk bikin list dengan pola tertentu
```

### Method CRUD

```dart
  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);  // Insert di index 0 (paling baru)
    notifyListeners();                     // Rebuild UI
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }
```

**`notifyListeners()` —** method dari `ChangeNotifier` yang memberitahu semua `Consumer` bahwa data berubah, sehingga UI di-rebuild.

### Sample Data

```dart
  void seedSampleData() {
    if (_transactions.isNotEmpty) return;  // Cegah duplikasi

    final now = DateTime.now();
    final sample = [
      Transaction(
        id: '1',
        customerName: 'Budi Santoso',
        items: [
          TransactionItem(name: 'Beras 5kg', quantity: 2, price: 65000),
          TransactionItem(name: 'Minyak Goreng 1L', quantity: 3, price: 18000),
        ],
        date: now.subtract(const Duration(hours: 2)),
        paymentMethod: 'cash',
      ),
      // ... 5 transaksi lainnya
    ];
    _transactions.addAll(sample);
    notifyListeners();
  }
```

### Entry Point (`lib/main.dart`)

```dart
void main() {
  runApp(const PenjualBarangApp());
}

class PenjualBarangApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionProvider()..seedSampleData(),
      //                         ^^  Cascade notation: panggil method
      //                             setelah object dibuat
      child: MaterialApp(
        title: 'Penjual Barang',
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          useMaterial3: true,  // Material 3 (Material You)
        ),
        home: const MainScreen(),
      ),
    );
  }
}
```

**Cascade notation (`..`):**
```dart
TransactionProvider()..seedSampleData()
//                   ^^
// 1. Buat object TransactionProvider
// 2. Panggil seedSampleData() pada object tsb
// 3. Return object (untuk parameter create)
```

Sama seperti:
```dart
final provider = TransactionProvider();
provider.seedSampleData();
return provider;
```

### Navigation & Bottom Nav (`lib/main.dart`)

```dart
class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final _screens = [
    const DashboardScreen(),
    const TransactionsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
        // ^^  IndexedStack: menyimpan state tiap tab
        //     beda sama PageView yang dispose tiap ganti tab
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddTransactionScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Transaksi Baru'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) =>
            setState(() => _currentIndex = i),
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
    );
  }
}
```

**`IndexedStack` vs `PageView`:**
- `IndexedStack` — semua halaman tetap di-memory, cocok untuk tab navigasi
- `PageView` — halaman di luar viewport bisa di-dispose

---

## 4. Dashboard & Grafik

### File: `lib/screens/dashboard_screen.dart`

### Consumer Pattern

```dart
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        // provider = instance TransactionProvider
        // otomatis rebuild saat notifyListeners() dipanggil
        ...
      },
    );
  }
}
```

**3 cara akses Provider:**

```dart
// 1. Consumer — rebuild widget SAJA yang dibungkus Consumer
Consumer<TransactionProvider>(builder: ...)

// 2. context.watch — rebuild seluruh widget
final provider = context.watch<TransactionProvider>();

// 3. context.read — akses data TANPA rebuild (buat event handler)
final provider = context.read<TransactionProvider>();
```

### Kartu Statistik

```dart
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
    SizedBox(width: 12),
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

**`Expanded` —** membagi ruang secara proporsional dalam `Row`/`Column`. Dua `Expanded` berarti masing-masing 50%.

### Grafik dengan fl_chart

```dart
// Safety maxY — cegah crash kalo semua data = 0
final maxRevenue = chartRevenue.isEmpty
    ? 0.0
    : chartRevenue.reduce((a, b) => a > b ? a : b);
final maxY = maxRevenue > 0 ? maxRevenue * 1.3 : 100000.0;
```

**Kenapa `maxY` perlu safety?**
- Kalo `maxRevenue = 0`, maka `maxY = 0`. Grafik dengan `maxY = 0` bisa crash atau error
- Solusi: kalo `maxRevenue = 0`, pake `maxY = 100000.0` (default value)

```dart
BarChart(
  BarChartData(
    maxY: maxY,
    barGroups: List.generate(chartRevenue.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: chartRevenue[i],
            color: Colors.blue[400],
            width: 18,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }),
  ),
)
```

**Struktur fl_chart:**
```
BarChart
  └── BarChartData
        ├── barGroups → List<BarChartGroupData>
        │     └── barRods → List<BarChartRodData>
        ├── titlesData → FlTitlesData (label sumbu)
        ├── gridData → FlGridData (garis bantu)
        └── borderData → FlBorderData (border chart)
```

### BarTooltip (interaktif)

```dart
barTouchData: BarTouchData(
  enabled: true,
  touchTooltipData: BarTouchTooltipData(
    getTooltipItem: (group, groupIndex, rod, rodIndex) {
      return BarTooltipItem(
        formatRupiah(rod.toY),  // Format pakai helper
        TextStyle(color: Colors.white, ...),
      );
    },
  ),
),
```

### Recent Transactions

```dart
...provider.transactions.take(5).map((t) => _TransactionCard(
    transaction: t,
    onDelete: () => provider.deleteTransaction(t.id),
)),
```

**Spread operator (`...`):**
```dart
// Tanpa spread:
children: [
  Card(...),
  Card(...),
  Card(...),
]

// Dengan spread — inject list ke dalam collection
children: [
  Text('Transaksi Terbaru'),
  ...listOfCards,  // Semua element list masuk sebagai children terpisah
]
```

### Date Format Tanpa Package

```dart
String _formatDate(DateTime date) {
  const days = [
    'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu',
  ];
  const months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];
  return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
}
```

**Kenapa manual, bukan pakai `intl`?**

Awalnya pake `DateFormat('EEEE, dd MMMM yyyy', 'id')` dari package `intl`. Tapi pas di Flutter test, lempar `LocaleDataException` karena locale `id_ID` gak selalu tersedia. Solusi: bikin manual dengan array nama hari/bulan. Lebih ringan dan 100% portable.

---

## 5. Form Tambah Transaksi (Dynamic Form)

### File: `lib/screens/add_transaction_screen.dart`

### State Items

```dart
class _ItemEntry {
  final String name;
  final int quantity;
  final double price;
  _ItemEntry({required this.name, required this.quantity, required this.price});
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<_ItemEntry> _items = [];
  ...
}
```

**`GlobalKey<FormState>()` —** key untuk mengakses state Form, berguna untuk validasi.

### Add Item Logic

```dart
void _addItem() {
  final name = _itemNameCtrl.text.trim();
  final qty = int.tryParse(_itemQtyCtrl.text) ?? 0;
  final price = double.tryParse(_itemPriceCtrl.text) ?? 0;

  if (name.isEmpty || qty <= 0 || price <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Isi nama, qty, dan harga item dengan benar')),
    );
    return;
  }

  setState(() {
    _items.add(_ItemEntry(name: name, quantity: qty, price: price));
    // Clear input setelah add
    _itemNameCtrl.clear();
    _itemQtyCtrl.clear();
    _itemPriceCtrl.clear();
  });
}
```

**`tryParse` pattern:**
```dart
int.tryParse(text) ?? 0
// Kalo text bukan angka, return null → pakai 0
```

### Payment Chip Selector

```dart
class _PaymentChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: selected ? Colors.blue[50] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey[300]!,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: ...),
            Text(label, style: ...),
          ],
        ),
      ),
    );
  }
}
```

**`AnimatedContainer` —** container yang animasi propertinya otomatis kalo diubah. Cukup ganti `color`/`border` via `setState`, Flutter yang handle animasinya.

### Submit & Validasi

```dart
void _submit() {
  if (!_formKey.currentState!.validate()) return;
  // ^^ validate() dari Form — ngecek semua TextFormField validator

  if (_items.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tambah minimal 1 item')),
    );
    return;
  }

  final transaction = Transaction(
    id: DateTime.now().millisecondsSinceEpoch.toString(), // ID unik
    customerName: _customerCtrl.text.trim(),
    items: _items.map((e) => TransactionItem(
      name: e.name, quantity: e.quantity, price: e.price,
    )).toList(),
    date: DateTime.now(),
    paymentMethod: _paymentMethod,
  );

  provider.addTransaction(transaction);
  Navigator.of(context).pop(); // Kembali ke dashboard
}
```

**`DateTime.now().millisecondsSinceEpoch` —** membuat ID unik berupa timestamp milidetik. Cukup untuk aplikasi offline tanpa database.

---

## 6. Daftar Transaksi (Expandable List)

### File: `lib/screens/transactions_screen.dart`

```dart
ExpansionTile(
  leading: _paymentAvatar(t.paymentMethod),
  title: Text(t.customerName),
  subtitle: Text('${t.formattedDate} · ${t.paymentLabel}'),
  children: [
    // Item table
    ...t.items.map((item) => Row(
      children: [
        Expanded(flex: 3, child: Text(item.name)),
        SizedBox(width: 60, child: Text('${item.quantity}x')),
        SizedBox(width: 100, child: Text(formatRupiah(item.price))),
        SizedBox(width: 100, child: Text(formatRupiah(item.subtotal))),
      ],
    )),
    // Total
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Total Item: ${t.totalItems}'),
        Text(formatRupiah(t.total)),
      ],
    ),
    // Delete button
    OutlinedButton.icon(
      onPressed: () => provider.deleteTransaction(t.id),
      icon: Icon(Icons.delete_outline),
      label: Text('Hapus Transaksi'),
    ),
  ],
)
```

**`flex` pada `Expanded`:**
```dart
Expanded(flex: 3, child: ...) // 3 bagian
SizedBox(width: 60)           // 60px fixed
SizedBox(width: 100)          // 100px fixed
// Row membagi ruang = flex / total flex × (lebar - fixed widths)
```

### Payment Avatar

```dart
Widget _paymentAvatar(String method) {
  Color color;
  IconData icon;
  switch (method) {
    case 'cash':     color = Colors.green;  icon = Icons.money_rounded;
    case 'transfer': color = Colors.blue;   icon = Icons.account_balance_rounded;
    case 'qris':     color = Colors.purple; icon = Icons.qr_code_rounded;
    default:         color = Colors.grey;   icon = Icons.payment_rounded;
  }

  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(icon, color: color, size: 20),
  );
}
```

**`withOpacity(0.1)` —** bikin warna lebih transparan untuk background. Nilai 0.0 (full transparan) sampai 1.0 (solid).

---

## 7. Widget Reusable: StatCard

### File: `lib/widgets/stat_card.dart`

```dart
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;   // Nullable — bisa diisi bisa tidak

  const StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,           // Optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(height: 12),
            // Value
            Text(value, style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
            // Title
            Text(title, style: TextStyle(color: Colors.grey[600])),
            // Optional subtitle
            if (subtitle != null) Text(subtitle!,
                style: TextStyle(color: color, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
```

**Conditional Widget dengan `if`:**
```dart
Column(
  children: [
    Text('Title'),
    if (subtitle != null) Text(subtitle!),
    // ^^  Kalo null, widget ini gak dirender sama sekali
  ],
)
```

**Nullable parameter pattern:**
```dart
final String? subtitle;  // Boleh null

this.subtitle,           // Di constructor: optional, default null

subtitle!                // Saat dipake: ! artinya "saya yakin gak null"
```

---

## 8. Format Rupiah & Locale Fallback

### File: `lib/utils/currency_helper.dart`

### Masalah

Di Flutter, `NumberFormat.currency(locale: 'id_ID')` butuh ICU data untuk locale Indonesia. Di lingkungan tertentu (Flutter test), data ini gak tersedia dan throw `LocaleDataException`.

### Solusi: Try-Catch Cascade

```dart
NumberFormat _currencyFormat = _createFormat();

NumberFormat _createFormat() {
  try {
    // Coba dengan locale lengkap
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
  } catch (_) {
    try {
      // Fallback: locale tanpa country code
      return NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp ',
        decimalDigits: 0,
      );
    } catch (_) {
      // Fallback terakhir: tanpa locale
      return NumberFormat.currency(
        symbol: 'Rp ',
        decimalDigits: 0,
      );
    }
  }
}
```

**Cascade fallback pattern:**
```
Coba A → gagal? → Coba B → gagal? → Coba C (default)
```

Berguna untuk API/feature yang mungkin gak tersedia di semua environment.

### Format Manual (Last Resort)

```dart
String formatRupiah(double amount) {
  try {
    return _currencyFormat.format(amount);
  } catch (_) {
    // Manual: tambah separator ribuan
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}';
  }
}
```

**Regex separator ribuan:**
```
RegExp(r'(\d)(?=(\d{3})+(?!\d))')
//       ^     ^^^^^^^^^^
//   1 digit    diikuti 1+ grup 3 digit
//              (?=...) = positive lookahead
//              (?!\d)  = negative lookahead (gak boleh ada digit setelahnya)
```

Contoh: `1000000` → `1.000.000`

---

## 9. Widget Testing

### File: `test/app_test.dart`

### Setup

```dart
void main() {
  setUpAll(() {
    Intl.defaultLocale = 'id_ID';
    // Set default locale untuk NumberFormat di test
  });
```

**`setUpAll` —** dijalankan SEKALI sebelum semua test. Beda dengan `setUp` yang dijalankan sebelum SETIAP test.

### Test 1: Render Dashboard

```dart
testWidgets('App renders dashboard without error', (tester) async {
  await tester.pumpWidget(const PenjualBarangApp());
  await tester.pumpAndSettle();

  expect(find.text('Dashboard'), findsAtLeastNWidgets(1));
  expect(find.textContaining('Penjualan Hari Ini'), findsOneWidget);
  expect(find.textContaining('Total Transaksi'), findsOneWidget);
  expect(find.text('Grafik Penjualan 7 Hari'), findsOneWidget);
  expect(find.text('Budi Santoso'), findsOneWidget);
});
```

**`pumpAndSettle()` vs `pump()`:**
- `pump()` — render 1 frame
- `pumpAndSettle()` — render terus sampai gak ada animasi lagi (untuk widget dengan animasi/transisi)

### Test 2: Navigasi

```dart
testWidgets('Bottom navigation switches to transactions tab', (tester) async {
  await tester.pumpWidget(const PenjualBarangApp());
  await tester.pumpAndSettle();

  // .last — ambil widget "Transaksi" yang TERAKHIR (bottom nav)
  await tester.tap(find.text('Transaksi').last);
  await tester.pumpAndSettle();

  expect(find.text('Transaksi'), findsAtLeastNWidgets(1));
});
```

**Kenapa `.last`?** Karena "Transaksi" muncul 2×:
1. Di **AppBar title** — saat di tab Transaksi
2. Di **NavigationBar** — label bottom nav

Kalo `.first`, yang diklik AppBar title — gak ngapa-ngapain. `.last` nge-klik bottom nav yang mengubah tab.

### Test 3: Form

```dart
testWidgets('FAB opens add transaction form', (tester) async {
  await tester.pumpWidget(const PenjualBarangApp());
  await tester.pumpAndSettle();

  await tester.tap(find.text('Transaksi Baru'));
  await tester.pumpAndSettle();

  expect(find.text('Nama Pelanggan'), findsOneWidget);
  expect(find.text('Metode Pembayaran'), findsOneWidget);
  expect(find.text('Tunai'), findsOneWidget);
  expect(find.text('Transfer'), findsOneWidget);
  expect(find.text('QRIS'), findsOneWidget);
});
```

### Test 4: Daftar Transaksi

```dart
testWidgets('Transaction list shows payment methods', (tester) async {
  await tester.pumpWidget(const PenjualBarangApp());
  await tester.pumpAndSettle();

  await tester.tap(find.text('Transaksi').last);
  await tester.pumpAndSettle();

  expect(find.text('Budi Santoso'), findsOneWidget);
  expect(find.textContaining('Tunai'), findsWidgets);
});
```

### Finder Methods

| Finder | Fungsi |
|---|---|
| `find.text('...')` | Cari widget dengan teks exact |
| `find.textContaining('...')` | Cari widget yang mengandung teks |
| `find.widgetWithText(Type, '...')` | Cari widget dari tipe tertentu dengan teks |

### Matcher Methods

| Matcher | Artinya |
|---|---|
| `findsOneWidget` | Tepat 1 widget ketemu |
| `findsWidgets` | ≥1 widget ketemu |
| `findsAtLeastNWidgets(n)` | Minimal n widget ketemu |
| `findsNothing` | Gak ada widget ketemu |

---

## 10. CI/CD dengan GitHub Actions

### File: `.github/workflows/build-debug-apk.yml`

### Workflow Overview

```yaml
name: Build Debug APK

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:  # Manual trigger dari GitHub UI
```

**3 trigger:**
- Push ke `main`
- Pull Request ke `main`
- Manual via **"Run workflow"** di GitHub Actions tab

### Setup Flutter (Manual)

```yaml
- name: Setup Flutter
  run: |
    git clone --depth 1 -b stable https://github.com/flutter/flutter.git "$HOME/flutter"
    echo "$HOME/flutter/bin" >> "$GITHUB_PATH"
```

**Kenapa manual, bukan pakai action?**

Awalnya pake `subosito/flutter-action@v2`, tapi error:
```
Unable to determine Flutter version for channel: stable
```

Action pihak ketiga kadang bermasalah (API berubah, deprecated, dll). Clone langsung dari repo Flutter lebih reliable.

### Generate Platform Files

```yaml
- name: Generate platform files
  run: |
    flutter create --project-name penjual_barang --platforms android .
    rm -f test/widget_test.dart
```

**Kenapa perlu `flutter create`?** Project ini dibuat manual tanpa `flutter create` (Flutter gak terinstall di mesin developer). Folder `android/` (Gradle config, AndroidManifest, dll) harus digenerate dulu.

**Kenapa `rm -f test/widget_test.dart`?** `flutter create` generate file test default yang panggil class `MyApp` — class kita namanya `PenjualBarangApp`. File ini dihapus karena kita punya test sendiri.

### Test & Build

```yaml
- name: Analyze
  run: flutter analyze --no-fatal-infos --no-fatal-warnings

- name: Run tests
  run: flutter test --reporter expanded

- name: Build debug APK
  run: flutter build apk --debug

- name: Upload APK artifact
  uses: actions/upload-artifact@v4
  with:
    name: debug-apk
    path: build/app/outputs/flutter-apk/*.apk
```

**`--reporter expanded` —** menampilkan hasil test lebih detail (termasuk error message).

### Hasil CI

Setiap push ke `main`, GitHub akan:
1. ✅ **Analyze** — cek kualitas kode (warning, error)
2. ✅ **Test** — jalanin widget test (4 test cases)
3. ✅ **Build** — kompilasi APK debug (~69MB)
4. ✅ **Upload** — APK siap download dari **Artifacts**

---

## Penutup

Aplikasi ini dibuat sebagai **learning project** untuk memahami:

| Konsep | Implementasi |
|---|---|
| State Management | Provider + ChangeNotifier |
| CRUD tanpa database | List in-memory |
| Reusable widget | StatCard |
| Form dynamic | List + setState |
| Grafik | fl_chart |
| Testing | flutter_test |
| CI/CD | GitHub Actions |
| Error handling | try-catch + fallback |

### Next Steps (Ide Pengembangan)

- 🔄 Edit transaksi (update data)
- 🔍 Search/filter transaksi
- 👤 Riwayat per pelanggan
- 📊 Export laporan ke PDF/Excel
- 💾 Local database (SQLite via sqflite)
- 🌐 Backend API (Laravel)

---

*Dokumentasi ini dibuat untuk materi pembelajaran Flutter.*

*Repo: https://github.com/haryandb/penjual_barang*
