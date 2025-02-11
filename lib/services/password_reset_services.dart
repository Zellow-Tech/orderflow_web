import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:ofg_web/constants/texts.dart';
import 'package:ofg_web/routes/app/app_endpoints.dart';
import 'package:ofg_web/utils/text_formatting.dart';
import 'package:ofg_web/widgets/snackbar.dart';

/// Service for handling password reset functionality.
class PassWordResetService {
  /// Firebase Authentication instance.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Utility class for text formatting.
  final OFGTextFormatting _formatting = OFGTextFormatting();

  /// Sends a password reset email to the given email address.
  Future<void> sendResetEmail(String email, BuildContext context) async {
    try {
      // Sends password reset email via Firebase Authentication.
      await _auth.sendPasswordResetEmail(email: email);

      // Displays a confirmation message using the formatting utility.
      _formatting.errorTextHandling(OFGTexts.passwordResetEmailSent);

      // Waits for 3 seconds before navigating to the login screen.
      Timer(const Duration(seconds: 5), () {
        OFGSnackBar().snackBarWithContent(
            content: 'Password reset email has been sent!', context: context);
        Get.offAllNamed(OFGEndpoints.login);
      });
    } catch (e) {
      // Handles any errors encountered while sending the reset email.
      _formatting.errorTextHandling(e.toString());
    }
  }
}
