import 'package:intl/intl.dart';

/// Format angka ke mata uang Rupiah.
/// Fallback ke format manual kalo locale data gak available (misal di test).
NumberFormat _currencyFormat = _createFormat();

NumberFormat _createFormat() {
  try {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
  } catch (_) {
    // Fallback: locale 'id_ID' mungkin gak tersedia
    try {
      return NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp ',
        decimalDigits: 0,
      );
    } catch (_) {
      return NumberFormat.currency(
        symbol: 'Rp ',
        decimalDigits: 0,
      );
    }
  }
}

String formatRupiah(double amount) {
  try {
    return _currencyFormat.format(amount);
  } catch (_) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}';
  }
}
