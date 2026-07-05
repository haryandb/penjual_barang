import 'package:flutter/foundation.dart';
import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  final List<Transaction> _transactions = [];
  final List<Transaction> _deletedTransactions = [];

  List<Transaction> get transactions => List.unmodifiable(_transactions);

  List<Transaction> get todayTransactions {
    final now = DateTime.now();
    return _transactions.where((t) =>
        t.date.year == now.year &&
        t.date.month == now.month &&
        t.date.day == now.day).toList();
  }

  List<Transaction> get thisMonthTransactions {
    final now = DateTime.now();
    return _transactions.where((t) =>
        t.date.year == now.year && t.date.month == now.month).toList();
  }

  double get todayRevenue =>
      todayTransactions.fold(0.0, (sum, t) => sum + t.total);

  double get monthRevenue =>
      thisMonthTransactions.fold(0.0, (sum, t) => sum + t.total);

  int get todayCount => todayTransactions.length;

  int get totalItemsSold =>
      _transactions.fold(0, (sum, t) => sum + t.totalItems);

  double get totalRevenue =>
      _transactions.fold(0.0, (sum, t) => sum + t.total);

  /// Get revenue for last N days (for chart)
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

  /// Get count for last N days (for chart)
  List<int> get last7DaysCount {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return _transactions
          .where((t) =>
              t.date.year == day.year &&
              t.date.month == day.month &&
              t.date.day == day.day)
          .length;
    });
  }

  List<String> get last7DaysLabels {
    final now = DateTime.now();
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return days[day.weekday - 1];
    });
  }

  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  void deleteTransaction(String id) {
    final idx = _transactions.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _deletedTransactions.add(_transactions[idx]);
      _transactions.removeAt(idx);
      notifyListeners();
    }
  }

  /// Seed some sample data
  void seedSampleData() {
    if (_transactions.isNotEmpty) return;

    final now = DateTime.now();
    final sample = [
      Transaction(
        id: '1',
        customerName: 'Budi Santoso',
        items: [
          TransactionItem(name: 'Beras 5kg', quantity: 2, price: 65000),
          TransactionItem(name: 'Minyak Goreng 1L', quantity: 3, price: 18000),
          TransactionItem(name: 'Gula Pasir 1kg', quantity: 1, price: 15000),
        ],
        date: now.subtract(const Duration(hours: 2)),
        paymentMethod: 'cash',
      ),
      Transaction(
        id: '2',
        customerName: 'Siti Rahmawati',
        items: [
          TransactionItem(name: 'Telur 1kg', quantity: 1, price: 28000),
          TransactionItem(name: 'Susu Kental Manis', quantity: 2, price: 12000),
        ],
        date: now.subtract(const Duration(hours: 4)),
        paymentMethod: 'qris',
      ),
      Transaction(
        id: '3',
        customerName: 'Ahmad Hidayat',
        items: [
          TransactionItem(name: 'Kopi Bubuk 200gr', quantity: 1, price: 35000),
          TransactionItem(name: 'Roti Tawar', quantity: 2, price: 15000),
          TransactionItem(name: 'Selai Kacang', quantity: 1, price: 22000),
          TransactionItem(name: 'Teh Celup 25s', quantity: 1, price: 8500),
        ],
        date: now.subtract(const Duration(hours: 6)),
        paymentMethod: 'transfer',
      ),
      Transaction(
        id: '4',
        customerName: 'Dewi Lestari',
        items: [
          TransactionItem(name: 'Sabun Mandi', quantity: 3, price: 7500),
          TransactionItem(name: 'Shampoo Sachet', quantity: 5, price: 2000),
          TransactionItem(name: 'Pasta Gigi', quantity: 2, price: 12000),
        ],
        date: now.subtract(const Duration(days: 1)),
        paymentMethod: 'cash',
      ),
      Transaction(
        id: '5',
        customerName: 'Rudi Hermawan',
        items: [
          TransactionItem(name: 'Mie Instan', quantity: 10, price: 3500),
          TransactionItem(name: 'Kecap Manis', quantity: 1, price: 9500),
          TransactionItem(name: 'Sambal Botol', quantity: 1, price: 17000),
        ],
        date: now.subtract(const Duration(days: 1, hours: 3)),
        paymentMethod: 'qris',
      ),
      Transaction(
        id: '6',
        customerName: 'Ani Fitriani',
        items: [
          TransactionItem(name: 'Beras 10kg', quantity: 1, price: 125000),
          TransactionItem(name: 'Minyak Goreng 2L', quantity: 2, price: 35000),
        ],
        date: now.subtract(const Duration(days: 2)),
        paymentMethod: 'transfer',
      ),
    ];

    _transactions.addAll(sample);
    notifyListeners();
  }
}
