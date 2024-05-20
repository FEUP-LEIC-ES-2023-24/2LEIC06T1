import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/network/create_post/location_field.dart';

void main() {
  group('LocationField widget tests', () {
    testWidgets('Widget updates text on input', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LocationField(
            onSubmitted: (value) {
              // Verify that the value passed to the callback is correct
              expect(value, 'New Location');
            },
          ),
        ),
      ));

      final inputField = find.byType(TextField);
      expect(inputField, findsOneWidget);

      // Simulate user input
      await tester.enterText(inputField, 'New Location');
    });

    testWidgets('Widget submits text on keyboard submit', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LocationField(
            onSubmitted: (value) {
              // Verify that the value passed to the callback is correct
              expect(value, 'New Location');
            },
          ),
        ),
      ));

      final inputField = find.byType(TextField);
      expect(inputField, findsOneWidget);

      // Simulate user input
      await tester.enterText(inputField, 'New Location');

      // Submit text via keyboard
      await tester.testTextInput.receiveAction(TextInputAction.done);
    });
  });
}
