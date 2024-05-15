import 'package:flutter/material.dart';

class PageFaultScreen extends StatefulWidget {
  final String imagePath;
  final String title;
  final String description;
  const PageFaultScreen({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  State<PageFaultScreen> createState() => _PageFaultScreenState();
}

class _PageFaultScreenState extends State<PageFaultScreen> {
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 150),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.imagePath,
            ),
            const SizedBox(height: 40),
            Text(
              widget.title,
              style: const TextStyle(
                color: Color(0xFF2F2F2F),
                fontSize: 20,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                letterSpacing: 1.36,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Text(
                widget.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF555555),
                  fontSize: 15,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
