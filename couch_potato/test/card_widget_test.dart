import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuple/tuple.dart';
import '../lib/modules/card_widget.dart'; // update with the actual path

void main() {
  testWidgets('CardWidget displays child widget', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CardWidget(
          child: Text('Test Child'),
        ),
      ),
    ));

    expect(find.text('Test Child'), findsOneWidget);
  });

  testWidgets('CardWidget applies shadow correctly', (WidgetTester tester) async {
    const Tuple2<Color, double> shadow = Tuple2(Color(0x55000000), 0.5);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CardWidget(
          child: Text('Test Child'),
          shadow: shadow,
        ),
      ),
    ));

    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as ShapeDecoration;
    final boxShadow = decoration.shadows!.first as BoxShadow;

    expect(boxShadow.color, shadow.item1.withOpacity(shadow.item2));
  });
}
