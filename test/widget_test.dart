import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:herbisense/main.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: HerbiSenseApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
