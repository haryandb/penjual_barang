import 'package:flutter_test/flutter_test.dart';
import 'package:penjual_barang/main.dart';

void main() {
  testWidgets('App renders dashboard without error', (WidgetTester tester) async {
    await tester.pumpWidget(const PenjualBarangApp());

    // Tunggu rendering selesai
    await tester.pumpAndSettle();

    // Cek elemen utama muncul
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Transaksi'), findsOneWidget);

    // Cek stat cards muncul (sample data)
    expect(find.textContaining('Penjualan Hari Ini'), findsOneWidget);
    expect(find.textContaining('Total Transaksi'), findsOneWidget);
    expect(find.textContaining('Item Terjual'), findsOneWidget);
    expect(find.textContaining('Total Pendapatan'), findsOneWidget);

    // Cek grafik ada
    expect(find.text('Grafik Penjualan 7 Hari'), findsOneWidget);

    // Cek transaksi sample muncul
    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('Siti Rahmawati'), findsOneWidget);
    expect(find.text('Ahmad Hidayat'), findsOneWidget);
  });

  testWidgets('Bottom navigation switches screens', (WidgetTester tester) async {
    await tester.pumpWidget(const PenjualBarangApp());
    await tester.pumpAndSettle();

    // Tap Transaksi tab
    await tester.tap(find.text('Transaksi'));
    await tester.pumpAndSettle();

    // Cek halaman transaksi
    expect(find.text('Transaksi'), findsNWidgets(2)); // AppBar title + bottom nav

    // Kembali ke Dashboard
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
  });

  testWidgets('Add transaction button opens form', (WidgetTester tester) async {
    await tester.pumpWidget(const PenjualBarangApp());
    await tester.pumpAndSettle();

    // Tap FAB "Transaksi Baru"
    await tester.tap(find.text('Transaksi Baru'));
    await tester.pumpAndSettle();

    // Cek form muncul
    expect(find.text('Nama Pelanggan'), findsOneWidget);
    expect(find.text('Metode Pembayaran'), findsOneWidget);

    // Isi form
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nama Pelanggan'),
      'Test Customer',
    );
    await tester.pumpAndSettle();

    // Cek tombol simpan
    expect(find.text('Simpan Transaksi'), findsOneWidget);
  });

  testWidgets('Transaction list shows items with payment methods', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PenjualBarangApp());
    await tester.pumpAndSettle();

    // Buka halaman Transaksi
    await tester.tap(find.text('Transaksi'));
    await tester.pumpAndSettle();

    // Cek transaksi pertama (Budi Santoso)
    expect(find.text('Budi Santoso'), findsOneWidget);

    // Cek label payment muncul
    expect(find.textContaining('Tunai'), findsWidgets);
    expect(find.textContaining('QRIS'), findsWidgets);
    expect(find.textContaining('Transfer'), findsWidgets);
  });
}
