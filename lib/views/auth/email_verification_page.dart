import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ofg_web/constants/color_palette.dart';
import 'package:ofg_web/constants/texts.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OFGColorPalette _palette = OFGColorPalette();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 500, // Fixed width for web, matching login & register pages
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Branding: OrderFlow Logo & Name
                CircleAvatar(
                  radius: 40,
                  backgroundColor: _palette.primaryBlue,
                  child: const Icon(
                    Icons.email,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  OFGTexts.appName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _palette.primaryBlue,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Check your email',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _palette.secondaryText,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'A verification link has been sent to your registered email address. Please check your inbox and follow the instructions to verify your email.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: _palette.tertiaryText,
                  ),
                ),

                const SizedBox(height: 24),

                // Navigate to Login Screen
                Text(
                  'Please do NOT close this page',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _palette.errorRed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
