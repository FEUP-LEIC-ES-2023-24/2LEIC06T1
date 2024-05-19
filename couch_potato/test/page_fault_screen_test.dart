import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/modules/page_fault_screen.dart'; // update with the actual path

void main() {
  testWidgets('PageFaultScreen displays image, title, and description', (WidgetTester tester) async {
    const String imagePath = 'assets/test_image.png';
    const String title = 'Test Title';
    const String description = 'Test Description';

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PageFaultScreen(
          imagePath: imagePath,
          title: title,
          description: description,
        ),
      ),
    ));

    expect(find.byType(Image), findsOneWidget);
    expect(find.text(title), findsOneWidget);
    expect(find.text(description), findsOneWidget);
  });
}
