class TransactionItem {
  String name;
  int quantity;
  double price;

  TransactionItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  double get subtotal => quantity * price;

  Map<String, dynamic> toMap() => {
        'name': name,
        'quantity': quantity,
        'price': price,
        'subtotal': subtotal,
      };
}

class Transaction {
  final String id;
  final String customerName;
  final List<TransactionItem> items;
  final DateTime date;
  final String paymentMethod; // cash, transfer, qris

  Transaction({
    required this.id,
    required this.customerName,
    required this.items,
    required this.date,
    this.paymentMethod = 'cash',
  });

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String get formattedTime {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get paymentLabel {
    switch (paymentMethod) {
      case 'cash':
        return 'Tunai';
      case 'transfer':
        return 'Transfer';
      case 'qris':
        return 'QRIS';
      default:
        return paymentMethod;
    }
  }
}
