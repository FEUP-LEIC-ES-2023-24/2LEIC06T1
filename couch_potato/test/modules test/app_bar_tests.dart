import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:couch_potato/modules/app_bar.dart';

void main() {
  group('MyAppBar', () {
    testWidgets('should display title', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          appBar: MyAppBar(),
        ),
      ));

      expect(find.text('COUCH POTATO'), findsOneWidget);
    });

    testWidgets('should not display back button by default', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          appBar: MyAppBar(),
        ),
      ));

      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('should display back button when showBackButton is true', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          appBar: MyAppBar(showBackButton: true),
        ),
      ));

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('back button should pop the current route', (WidgetTester tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(
          appBar: MyAppBar(showBackButton: true),
        ),
      ));

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();

      expect(navigatorKey.currentState!.canPop(), false);
    });
  });
}
