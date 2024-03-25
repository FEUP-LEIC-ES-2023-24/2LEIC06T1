import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

enum ParentType { branded, custom }

class CardWidget extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color borderColor;
  final Color backgroundColor;
  final double borderWidth;
  final Tuple2<Color, double> shadow;
  const CardWidget({
    super.key,
    required this.child,
    this.borderColor = const Color(0xFFEFEFEF),
    this.padding = const EdgeInsets.all(17),
    this.backgroundColor = Colors.white,
    this.borderWidth = 0.5,
    this.shadow = const Tuple2(Color(0x00000000), 0.20),
  });

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    Tuple2<Color, double> shadow = widget.shadow;
    return Container(
      decoration: ShapeDecoration(
        color: widget.backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: widget.borderWidth, color: widget.borderColor),
          borderRadius: BorderRadius.circular(11),
        ),
        shadows: [
          BoxShadow(
            color: shadow.item1.withOpacity(shadow.item2),
            spreadRadius: -7,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: widget.padding,
        child: widget.child,
      ),
    );
  }
}
