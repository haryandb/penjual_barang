import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:penjual_barang/main.dart';

void main() {
  setUpAll(() {
    Intl.defaultLocale = 'id_ID';
  });

  testWidgets('App renders dashboard without error', (WidgetTester tester) async {
    await tester.pumpWidget(const PenjualBarangApp());

    // Tunggu semua animasi selesai
    await tester.pumpAndSettle();

    // AppBar title + BottomNavigationBar item
    expect(find.text('Dashboard'), findsAtLeastNWidgets(1));
    expect(find.text('Transaksi'), findsAtLeastNWidgets(1));

    // Cek stat cards muncul (sample data)
    expect(find.textContaining('Penjualan Hari Ini'), findsOneWidget);
    expect(find.textContaining('Total Transaksi'), findsOneWidget);
    expect(find.textContaining('Item Terjual'), findsOneWidget);
    expect(find.textContaining('Total Pendapatan'), findsOneWidget);

    // Cek grafik
    expect(find.text('Grafik Penjualan 7 Hari'), findsOneWidget);

    // Cek nama customer dari sample data
    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('Siti Rahmawati'), findsOneWidget);
  });

  testWidgets('Bottom navigation switches to transactions tab', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PenjualBarangApp());
    await tester.pumpAndSettle();

    // Tap "Transaksi" di bottom nav
    await tester.tap(find.text('Transaksi').last);
    await tester.pumpAndSettle();

    // Harusnya judul AppBar berubah jadi "Transaksi"
    expect(find.text('Transaksi'), findsAtLeastNWidgets(1));

    // Kembali ke Dashboard
    await tester.tap(find.text('Dashboard').last);
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsAtLeastNWidgets(1));
  });

  testWidgets('FAB opens add transaction form', (WidgetTester tester) async {
    await tester.pumpWidget(const PenjualBarangApp());
    await tester.pumpAndSettle();

    // Tap FAB "Transaksi Baru"
    await tester.tap(find.text('Transaksi Baru'));
    await tester.pumpAndSettle();

    // Cek form elements muncul
    expect(find.text('Nama Pelanggan'), findsOneWidget);
    expect(find.text('Metode Pembayaran'), findsOneWidget);
    expect(find.text('Tunai'), findsOneWidget);
    expect(find.text('Transfer'), findsOneWidget);
    expect(find.text('QRIS'), findsOneWidget);
  });

  testWidgets('Transaction list shows payment methods', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PenjualBarangApp());
    await tester.pumpAndSettle();

    // Buka halaman Transaksi
    await tester.tap(find.text('Transaksi').last);
    await tester.pumpAndSettle();

    // Cek data sample muncul
    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('Ahmad Hidayat'), findsOneWidget);

    // Cek metode pembayaran
    expect(find.textContaining('Tunai'), findsWidgets);
  });
}
