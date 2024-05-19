import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/modules/app_bar.dart';

void main() {
  testWidgets('MyAppBar displays title correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(appBar: MyAppBar(title: 'Test Title')),
    ));

    expect(find.text('Test Title'), findsOneWidget);
  });

  testWidgets('MyAppBar displays back button when showBackButton is true', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(appBar: MyAppBar(showBackButton: true)),
    ));

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('MyAppBar does not display back button when showBackButton is false', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(appBar: MyAppBar(showBackButton: false)),
    ));

    expect(find.byIcon(Icons.arrow_back), findsNothing);
  });
}
