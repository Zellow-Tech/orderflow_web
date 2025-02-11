import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Utility class for text formatting, validation, and miscellaneous functions.
class OFGTextFormatting {
  /// Extracts an error message from a formatted error string.
  /// Removes content before the first `]` character.
  String errorTextHandling(String error) {
    for (int i = 0; i < error.length; i++) {
      if (error[i] == ']') {
        return error.substring(i + 1, error.length);
      }
    }
    return error;
  }

  /// Launches a URL after parsing.
  Future<void> launchUrlAfterCheck(
      {required String url, required BuildContext context}) async {
    await launchUrl(Uri.parse(url));
  }

  /// Pops routes until reaching the root.
  void popRouteUntilRoot(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
      popRouteUntilRoot(context);
    }
  }

  /// Checks if the given string is a valid UPI ID.
  bool isValidUPI(String upi) {
    return upi.contains('@') && upi.length >= 5;
  }

  /// Validates an email format using a regular expression.
  bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  /// Converts numbers into `K`, `M`, or `B` format (e.g., 1500 → 1.5K).
  String kmbGenerator(double amount, bool makeK) {
    if (amount >= 1e9) {
      return "${(amount / 1e9).toStringAsFixed(2)} B";
    } else if (amount >= 1e6) {
      return "${(amount / 1e6).toStringAsFixed(2)} M";
    } else if (amount >= 1e5 || (amount > 999 && makeK)) {
      return "${(amount / 1e3).toStringAsFixed(2)} K";
    }
    return amount.toString();
  }

  /// Generates a unique invoice number based on the current date and time.
  String generateInvoiceNumber() {
    DateTime now = DateTime.now();
    String formattedDate =
        '${now.year.toString().substring(2, 4)}${_twoDigits(now.month)}${_twoDigits(now.day)}';
    String formattedTime =
        '${_twoDigits(now.hour)}${_twoDigits(now.minute)}${_twoDigits(now.second)}';

    return '$formattedTime$formattedDate';
  }

  /// Extracts the billing date from a given checkout number.
  String getBilledDate(String checkoutNo) {
    if (checkoutNo.length < 12) return "Invalid Checkout No";
    return '${checkoutNo.substring(10, 12)}/${checkoutNo.substring(8, 10)}/${checkoutNo.substring(6, 8)}';
  }

  /// Rounds a double value to the specified decimal places.
  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  /// Returns the current date in `DD/MM/YYYY` format.
  String getDate() {
    DateTime now = DateTime.now();
    return '${_twoDigits(now.day)}/${_twoDigits(now.month)}/${now.year}';
  }

  /// Returns the current time in `HH:MM:SS` format.
  String getTime() {
    DateTime now = DateTime.now();
    return '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}';
  }

  /// Ensures numbers are formatted with leading zeros if less than 10.
  String _twoDigits(int n) => n >= 10 ? "$n" : "0$n";
}
