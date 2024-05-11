import 'package:couch_potato/utils/utils.dart';
import 'package:flutter/material.dart';

class LocationField extends StatefulWidget {
  final Function onSubmitted;
  final String defaultText;
  const LocationField({super.key, required this.onSubmitted, this.defaultText = ''});

  @override
  State<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  String _locationTemp = '';

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.defaultText);
    _locationTemp = widget.defaultText;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            color: Color(0xFF979797),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFDFDFDF),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: const InputDecorationTheme(
                counterStyle: TextStyle(
                  color: Colors.grey, // Replace with your desired color
                ),
              ),
            ),
            child: TextField(
              controller: _controller,
              onTapOutside: (PointerDownEvent event) {
                FocusScope.of(context).unfocus();
                widget.onSubmitted(_locationTemp);
              },
              onSubmitted: (String description) {
                FocusScope.of(context).unfocus();
                widget.onSubmitted(description);
              },
              onEditingComplete: () {
                widget.onSubmitted(_locationTemp);
              },
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.streetAddress,
              maxLines: null,
              style: const TextStyle(
                color: Color(0xFF555555),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
              ),
              cursorWidth: 1,
              cursorHeight: 20,
              maxLength: 50,
              decoration: InputDecoration(
                counterText: '',
                prefixIcon: Icon(Icons.location_pin, color: appColor, size: 25),
                hintText: "Enter the item's location",
                hintStyle: const TextStyle(
                  color: Color(0xFFBEBEBE),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
