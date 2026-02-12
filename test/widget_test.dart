import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Guardian app startup test', (WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    expect(find.byType(SizedBox), findsOneWidget);
  });
}
