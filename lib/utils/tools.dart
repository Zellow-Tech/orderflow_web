import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Tools {
  errorTextHandling(String error) {
    for (int i = 0; i < error.length; i++) {
      if (error[i] == ']') {
        return error.substring(i + 1, error.length);
      }
    }
    return error;
  }

  // url launcher
  launchUrlAfterCheck(
      {required String url, required BuildContext context}) async {
    await launchUrl(Uri.parse(url));
  }

  // pop till root method
  void popRouteUntilRoot(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
      popRouteUntilRoot(context);
    }
  }

  bool isValidUPI(String upi) {
    if (upi.contains('@') && upi.length >= 5) {
      return true;
    }
    return false;
  }

  bool isValidEmail(email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  String kmbGenerator(double amount, bool makeK) {
    if (amount > 999 && amount < 99999 && makeK) {
      return "${(amount / 1000).toStringAsFixed(2)} K";
    } else if (amount > 99999 && amount < 999999) {
      return "${(amount / 1000).toStringAsFixed(2)} K";
    } else if (amount > 999999 && amount < 999999999) {
      return "${(amount / 1000000).toStringAsFixed(2)} M";
    } else if (amount > 999999999) {
      return "${(amount / 1000000000).toStringAsFixed(2)} B";
    } else {
      return amount.toString();
    }
  }

  String generateInvoiceNumber() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Format the date in the desired format (yyyyMMdd)
    String formattedDate =
        '${now.year.toString().substring(2, 4)}${_twoDigits(now.month)}${_twoDigits(now.day)}';

    // Format the time in the desired format (HHmmss)
    String formattedTime =
        '${_twoDigits(now.hour)}${_twoDigits(now.minute)}${_twoDigits(now.second)}';

    // Concatenate the formatted date, time, and store name to create the invoice number
    String invoiceNumber = '$formattedTime$formattedDate';

    return invoiceNumber;
  }

  String getBilledDate(String checkoutNo) {
    String cno = checkoutNo.toString();
    return '${cno.substring(10, 12)}/${cno.substring(8, 10)}/${cno.substring(6, 8)}';
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

// Helper function to ensure that single-digit numbers are formatted with leading zeros
  String _twoDigits(int n) {
    if (n >= 10) {
      return "$n";
    }
    return "0$n";
  }

  String getDate() {
    DateTime now = DateTime.now();
    return '${_twoDigits(now.day)}/${_twoDigits(now.month)}/${now.year}';
  }

  String getTime() {
    DateTime time = DateTime.timestamp();
    return '${time.hour}:${time.minute}:${time.second}';
  }
}
