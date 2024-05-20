import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/network/create_post/description_text_field.dart'; // Update with your actual package name

void main() {
  Future<void> _buildWidget(WidgetTester tester, {String defaultText = '', Function(String)? onSubmitted}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DescriptionTextField(
            onSubmitted: onSubmitted ?? (String value) {},
            defaultText: defaultText,
          ),
        ),
      ),
    );
  }

  testWidgets('displays default text correctly', (WidgetTester tester) async {
    await _buildWidget(tester, defaultText: 'Initial description');
    expect(find.text('Initial description'), findsOneWidget);
  });

  testWidgets('calls onSubmitted callback when submitted', (WidgetTester tester) async {
    String submittedText = '';
    await _buildWidget(tester, onSubmitted: (String value) => submittedText = value);

    await tester.enterText(find.byType(TextField), 'New description');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(submittedText, 'New description');
  });

  testWidgets('enforces maximum length', (WidgetTester tester) async {
    await _buildWidget(tester);

    await tester.enterText(find.byType(TextField), 'A' * 301);
    await tester.pump();

    expect(find.text('A' * 301), findsNothing);
    expect(find.text('A' * 300), findsOneWidget); // Only 300 characters should be allowed
  });

  testWidgets('enforces leading newlines restriction', (WidgetTester tester) async {
    await _buildWidget(tester);

    await tester.enterText(find.byType(TextField), '\nNew description');
    await tester.pump();

    expect(find.text('\nNew description'), findsNothing);
    expect(find.text('New description'), findsNothing); // Text should not be displayed
  });

  testWidgets('enforces maximum paragraph count', (WidgetTester tester) async {
    await _buildWidget(tester);

    String longText = 'Paragraph 1\n\nParagraph 2\n\nParagraph 3\n\nParagraph 4\n\nParagraph 5\n\nParagraph 6';
    await tester.enterText(find.byType(TextField), longText);
    await tester.pump();

    expect(find.text(longText), findsNothing);

    String validText = 'Paragraph 1\n\nParagraph 2\n\nParagraph 3\n\nParagraph 4\n\nParagraph 5';
    await tester.enterText(find.byType(TextField), validText);
    await tester.pump();

    expect(find.text(validText), findsOneWidget);
  });
}
