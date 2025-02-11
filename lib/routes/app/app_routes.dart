import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:ofg_web/routes/app/app_endpoints.dart';
import 'package:ofg_web/views/auth/email_verification_page.dart';
import 'package:ofg_web/views/auth/forgot_password.dart';
import 'package:ofg_web/views/auth/login_screen.dart';
import 'package:ofg_web/views/auth/registration_screen.dart';
import 'package:ofg_web/views/main/dashboard.dart';

class OFGPages {
  static final pages = [
    GetPage(name: OFGEndpoints.login, page: () => const LoginPage()),
    GetPage(name: OFGEndpoints.register, page: () => const RegistrationPage()),
    GetPage(name: OFGEndpoints.forgotPassword, page: () => const ForgotPasswordPage()),

    // Pass VendorModel via Get.arguments
    GetPage(
      name: OFGEndpoints.emailVerifcation,
      page: () {
        final args = Get.arguments;
        if (args is Map<String, dynamic> && args.containsKey('vendor')) {
          return EmailVerificationPage(
            vendor: args['vendor'],
          );
        }
        return Scaffold(body: Center(child: Text('Invalid Arguments')));
      },
    ),

    GetPage(name: OFGEndpoints.dashboard, page: () => DashboardPage()),

    // for and unknown route
    GetPage(name: OFGEndpoints.unknown, page: () => Scaffold(body: Center(child: Text('Page Not Found'))),
    ),
  ];
}
