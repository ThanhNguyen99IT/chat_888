import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:chat_888/app.dart';

void main() {
  testWidgets('App renders HomePage', (tester) async {
    await tester.pumpWidget(const App());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
