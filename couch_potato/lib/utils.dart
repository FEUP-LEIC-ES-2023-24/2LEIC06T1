import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

Color appColor = const Color(0xFFCF7000);

Future<bool> hasInternetConnection() async {
  try {
    final response = await InternetAddress.lookup('google.com').timeout(const Duration(milliseconds: 1500));
    if (response.isNotEmpty && response[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } on SocketException catch (_) {
    return false;
  } on TimeoutException catch (_) {
    return false;
  }
}