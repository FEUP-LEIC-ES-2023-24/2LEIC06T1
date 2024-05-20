import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/network/create_post/category_field.dart';

void main() {
  testWidgets('CategoryField displays default category and calls onSubmitted', (WidgetTester tester) async {
    Category selectedCategory = Category.other;  // Initialize with a default value
    final Category defaultCategory = Category.books;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CategoryField(
            onSubmitted: (value) {
              selectedCategory = value!;
            },
            defaultCategory: defaultCategory,
          ),
        ),
      ),
    );

    // Verify that the default category is displayed
    expect(find.text('Books'), findsOneWidget);

    // Open dropdown
    await tester.tap(find.byType(DropdownButtonFormField<Category>));
    await tester.pumpAndSettle();

    // Select a new category
    await tester.tap(find.text('Electronics').last);
    await tester.pumpAndSettle();

    // Verify the onSubmitted callback is called with the correct value
    expect(selectedCategory, Category.electronics);
  });
}
