import 'package:flutter_test/flutter_test.dart';
import 'package:penjual_barang/main.dart';

void main() {
  testWidgets('App should render', (WidgetTester tester) async {
    await tester.pumpWidget(const PenjualBarangApp());
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
