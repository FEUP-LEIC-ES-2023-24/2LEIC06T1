import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:couch_potato/utils/utils.dart';
import '../lib/network/post/post_footer.dart';

void main() {
  group('PostFooter widget tests', () {
    testWidgets('Widget displays location text correctly', (WidgetTester tester) async {
      // Build the PostFooter widget
      await tester.pumpWidget(MaterialApp(
        home: PostFooter(
          fullLocation: 'Test Location',
          favFunction: () {},
          sharePostFunction: () {},
          isFavorite: false,
        ),
      ));

      // Verify that the location text is displayed correctly
      expect(find.text('Test Location'), findsOneWidget);
    });

    testWidgets('Widget displays favorite icon correctly', (WidgetTester tester) async {
      // Build the PostFooter widget with isFavorite set to true
      await tester.pumpWidget(MaterialApp(
        home: PostFooter(
          fullLocation: 'Test Location',
          favFunction: () {},
          sharePostFunction: () {},
          isFavorite: true,
        ),
      ));

      // Verify that the favorite icon is displayed correctly
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('Widget invokes favorite function when icon is tapped', (WidgetTester tester) async {
      // Define a variable to track whether the favorite function is called
      bool functionCalled = false;

      // Build the PostFooter widget with a function that sets functionCalled to true
      await tester.pumpWidget(MaterialApp(
        home: PostFooter(
          fullLocation: 'Test Location',
          favFunction: () {
            functionCalled = true;
          },
          sharePostFunction: () {},
          isFavorite: false,
        ),
      ));

      // Tap the favorite icon
      await tester.tap(find.byIcon(Icons.star_border));

      // Verify that the favorite function is called
      expect(functionCalled, true);
    });

  });
}
