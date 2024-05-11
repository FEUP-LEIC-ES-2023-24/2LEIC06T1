import 'package:flutter/material.dart';

class DescriptionTextField extends StatefulWidget {
  final Function onSubmitted;
  final String defaultText;
  const DescriptionTextField({super.key, required this.onSubmitted, this.defaultText = ''});

  @override
  State<DescriptionTextField> createState() => _DescriptionTextFieldState();
}

class _DescriptionTextFieldState extends State<DescriptionTextField> {
  String _descriptionTemp = '';

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.defaultText);
    _descriptionTemp = widget.defaultText;
  }

  int _countParagraphs(String text) {
    List<String> lines = text.split('\n');
    int paragraphCount = 0;

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];

      // If the line is not empty, count it as a paragraph
      if (line.trim().isNotEmpty) {
        paragraphCount++;
      }
      // If the line is empty and it's not the last line, count it as a paragraph
      else if (i != lines.length - 1) {
        paragraphCount++;
      }
    }

    return paragraphCount;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
          maxLength: 300,
          onTapOutside: (PointerDownEvent event) {
            FocusScope.of(context).unfocus();
            widget.onSubmitted(_descriptionTemp);
          },
          onSubmitted: (String description) {
            widget.onSubmitted(description);
          },
          onChanged: (value) {
            value = value.replaceAll(RegExp(r'\n{3,}'), '\n\n');

            // Check for leading newlines and total length
            if (value.startsWith('\n') || value.length > 300 || _countParagraphs(value) > 5) {
              // Revert to the last valid state without causing infinite loop
              _controller.value = TextEditingValue(
                text: _descriptionTemp,
                selection: TextSelection.collapsed(offset: _descriptionTemp.length),
              );
            } else {
              // Update the state with the new valid value
              setState(() {
                _descriptionTemp = value;
              });
            }
          },
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style: const TextStyle(
            color: Color(0xFF555555),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
          ),
          cursorWidth: 1,
          cursorHeight: 20,
          decoration: const InputDecoration(
            hintText: 'Enter a description for your post',
            hintStyle: TextStyle(
              color: Color(0xFFBEBEBE),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
