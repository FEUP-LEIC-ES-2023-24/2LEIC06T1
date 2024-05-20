import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/network/post/post_header.dart';

void main() {
  testWidgets('PostHeader renders with network image', (WidgetTester tester) async {
    // Define test variables
    const name = 'John Doe';
    const footer = 'Some footer text';
    const profileImageUrl = 'https://example.com/profile.jpg';

    // Build the PostHeader widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PostHeader(
          name: name,
          footer: footer,
          profileImageUrl: profileImageUrl,
        ),
      ),
    ));

    // Verify that the name and footer text are rendered
    expect(find.text(name), findsOneWidget);
    expect(find.text(footer), findsOneWidget);

    // Verify that the profile image is rendered
    expect(find.byType(CircleAvatar), findsOneWidget);
  });

  testWidgets('PostHeader renders with file image', (WidgetTester tester) async {
    // Define test variables
    const name = 'Jane Smith';
    const footer = 'Another footer text';
    final profileImageFile = File('/path/to/image.jpg');

    // Build the PostHeader widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PostHeader(
          name: name,
          footer: footer,
          profileImageUrl: profileImageFile,
        ),
      ),
    ));

    // Verify that the name and footer text are rendered
    expect(find.text(name), findsOneWidget);
    expect(find.text(footer), findsOneWidget);

    // Verify that the profile image is rendered
    expect(find.byType(CircleAvatar), findsOneWidget);
  });

  testWidgets('PostHeader renders without image', (WidgetTester tester) async {
    // Define test variables
    const name = 'Anonymous';
    const footer = 'No image provided';

    // Build the PostHeader widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PostHeader(
          name: name,
          footer: footer,
          profileImageUrl: null,
        ),
      ),
    ));

    // Verify that the name and footer text are rendered
    expect(find.text(name), findsOneWidget);
    expect(find.text(footer), findsOneWidget);

    // Verify that no profile image is rendered
    expect(find.byType(CircleAvatar), findsNothing);
  });
}
