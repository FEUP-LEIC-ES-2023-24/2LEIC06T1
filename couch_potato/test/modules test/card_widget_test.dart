import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:couch_potato/modules/card_widget.dart';
import 'package:tuple/tuple.dart';

void main() {
  group('CardWidget', () {
    testWidgets('should display child widget', (WidgetTester tester) async {
      final Widget child = Container();

      await tester.pumpWidget(MaterialApp(
        home: CardWidget(child: child),
      ));

      expect(find.byWidget(child), findsOneWidget);
    });
  });
}
