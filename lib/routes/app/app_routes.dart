import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:ofg_web/routes/app/app_endpoints.dart';
import 'package:ofg_web/views/auth/forgot_password.dart';
import 'package:ofg_web/views/auth/login_screen.dart';
import 'package:ofg_web/views/auth/registration_screen.dart';

class OFGPages {
  static final pages = [
    GetPage(name: OFGEndpoints.login, page: () => const LoginScreen()),
    GetPage(
        name: OFGEndpoints.register, page: () => const RegistrationScreen()),
    GetPage(
        name: OFGEndpoints.forgotPassword,
        page: () => const ForgotPasswordScreen()),
    // GetPage(name: OFGEndpoints.forgotPassword, page: () => const ForgotPasswordScreen()),
    // GetPage(name: OFGEndpoints.resetPassword, page: () => const ResetPasswordScreen()),
    // GetPage(name: OFGEndpoints.dashboard, page: () => const DashboardScreen()),
    // GetPage(name: OFGEndpoints.account, page: () => const AccountScreen()),
    // GetPage(name: OFGEndpoints.settings, page: () => const SettingsScreen()),
    GetPage(
        name: OFGEndpoints.unknown,
        page: () => Scaffold(body: Center(child: Text('Page Not Found'))))
  ];
}
