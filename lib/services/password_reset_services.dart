import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ofg_web/constants/texts.dart';
import 'package:ofg_web/utils/text_formatting.dart';

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
      Timer(const Duration(seconds: 3), () {
        // TODO: Implement navigation to login page after reset email is sent.
      });
    } catch (e) {
      // Handles any errors encountered while sending the reset email.
      _formatting.errorTextHandling(e.toString());
    }
  }
}
