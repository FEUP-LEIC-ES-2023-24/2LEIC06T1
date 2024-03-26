import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:devicelocale/devicelocale.dart';

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

String? location;

void fetchLocation() async {
  String? locale = await Devicelocale.currentLocale;
  debugPrint('locale: $locale');
  String? countryCode = locale?.split('-').elementAt(1);
  debugPrint('countryCode: $countryCode');
  location = countryCode;
}

String timeDelta(String timestampString) {
    DateTime dateTime = DateTime.parse(timestampString);
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes == 1) {
      return '1 minute ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours == 1) {
      return '1 hour ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return '1 day ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      int weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else {
      return 'over a year ago';
    }
  }