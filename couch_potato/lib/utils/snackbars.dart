import 'package:flutter/material.dart';

class ErrorSnackbar extends SnackBar {
  ErrorSnackbar({
    super.key,
    required String errorText,
    required BuildContext context,
  }) : super(
          content: Text(
            errorText,
            style: const TextStyle(
                color: Color.fromARGB(255, 206, 20, 7),
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat'),
          ),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.white,
          elevation: 5,
        );
}
