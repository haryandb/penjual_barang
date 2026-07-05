import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        final currency = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        );

        if (provider.transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long_outlined,
                    size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text('Belum ada transaksi',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    )),
                const SizedBox(height: 8),
                Text(
                  'Klik + untuk menambah transaksi baru',
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: provider.transactions.length,
          itemBuilder: (context, index) {
            final t = provider.transactions[index];
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Colors.grey[200]!),
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                shape: const Border(),
                collapsedShape: const Border(),
                leading: _paymentAvatar(t.paymentMethod),
                title: Text(
                  t.customerName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${t.formattedDate} ${t.formattedTime} · ${t.paymentLabel}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currency.format(t.total),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right,
                        size: 20, color: Colors.grey[400]),
                  ],
                ),
                children: [
                  const Divider(),
                  // Items table
                  ...t.items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(item.name,
                                  style: const TextStyle(fontSize: 14)),
                            ),
                            SizedBox(
                              width: 60,
                              child: Text(
                                '${item.quantity}x',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Text(
                                currency.format(item.price),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Text(
                                currency.format(item.subtotal),
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Item: ${t.totalItems}',
                          style: TextStyle(color: Colors.grey[600])),
                      Text(
                        currency.format(t.total),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => provider.deleteTransaction(t.id),
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Hapus Transaksi'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red[600],
                        side: BorderSide(color: Colors.red[200]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _paymentAvatar(String method) {
    Color color;
    IconData icon;
    switch (method) {
      case 'cash':
        color = Colors.green;
        icon = Icons.money_rounded;
        break;
      case 'transfer':
        color = Colors.blue;
        icon = Icons.account_balance_rounded;
        break;
      case 'qris':
        color = Colors.purple;
        icon = Icons.qr_code_rounded;
        break;
      default:
        color = Colors.grey;
        icon = Icons.payment_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
