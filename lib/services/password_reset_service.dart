import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ofg_web/utils/custom_widgets.dart';
import 'package:ofg_web/utils/tools.dart';
import 'package:ofg_web/views/home.dart';

class PassWordResetService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  sendResetEmail(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      CustomWidgets().snackBarWidget(
          content: 'Password reset email has been sent', context: context);
      Timer(
        const Duration(seconds: 3),
        () => CustomWidgets().moveToPage(
            page: const Home(), context: context, replacement: true),
      );
    } catch (e) {
      CustomWidgets().snackBarWidget(
          content: Tools().errorTextHandling(e.toString()),
          context: context);
    }
  }
}
