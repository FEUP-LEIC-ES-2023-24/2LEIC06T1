import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/modules/nav_app_bar.dart'; // update with the actual path

void main() {
  testWidgets('NavAppBar displays navigation destinations', (WidgetTester tester) async {
    final pageController = PageController();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: NavAppBar(
          currentIndex: 1,
          pageController: pageController,
        ),
      ),
    ));

    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
    expect(find.byIcon(Icons.message_outlined), findsOneWidget);
  });

  testWidgets('NavAppBar changes pages on destination selected', (WidgetTester tester) async {
    final PageController pageController = PageController(initialPage: 0);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: pageController,
                  children: <Widget>[
                    Container(color: Colors.red),
                    Container(color: Colors.green),
                    Container(color: Colors.blue),
                  ],
                ),
              ),
              NavAppBar(currentIndex: 0, pageController: pageController),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();

    expect(pageController.page, 1);
  });
  
}
