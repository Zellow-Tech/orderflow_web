import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ofg_web/constants/color_palette.dart';
import 'package:ofg_web/constants/texts.dart';
import 'package:ofg_web/routes/app/app_endpoints.dart';
import 'package:ofg_web/services/password_reset_services.dart';
import 'package:ofg_web/utils/text_formatting.dart';
import 'package:ofg_web/widgets/snackbar.dart';
import 'package:ofg_web/widgets/top_label_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Controller for email input field
  final TextEditingController _emailController = TextEditingController();

  // Custom input field widget
  final TopLabelTextField topLabelTextField = TopLabelTextField();

  // Color palette instance
  final OFGColorPalette _palette = OFGColorPalette();

  // Loading state for the submit button
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Branding: OrderFlow Logo & Name
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: _palette.primaryBlue,
                        child: const Icon(
                          Icons.shopping_cart,
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
                        'Reset your password securely',
                        style: TextStyle(
                          fontSize: 14,
                          color: _palette.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Email Input Field
                topLabelTextField.topLabelTextField(
                  controller: _emailController,
                  label: OFGTexts.forgotPasswordTitle,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  borderRadius: 10.0,
                  hintText: OFGTexts.forgotPasswordInstruction,
                  requiredField: true,
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: height * 0.065,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _palette.primaryBlue,
                      side: BorderSide(
                        width: 1,
                        color: _palette.inactiveIcon,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: () async {
                      // password reset login
                      var res = _textFieldValidation();
                      // check res and show the appropriate dialog
                      if (res != '1') {
                        // show the message
                        OFGSnackBar().snackBarWithContent(
                            content: res, context: context);

                        // set the loading to false
                        setState(() {
                          _isLoading = false;
                        });
                      } else {
                        // login and move to the content page
                        _sendResetLinkAfterValidation();
                      }
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            OFGTexts.sendResetLink,
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // Navigate to Login Screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      OFGTexts.rememberPassword,
                      style: TextStyle(
                        fontSize: 15,
                        color: _palette.tertiaryText,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.offAllNamed(
                            OFGEndpoints.login); // Navigate to Login Page
                      },
                      child: Text(
                        OFGTexts.loginButton,
                        style: TextStyle(
                          fontSize: 15,
                          color: _palette.linkBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _textFieldValidation() {
// check if phone number is that of Indian origin, password is atleast 8 chars, and every other field is correct
    if (_emailController.text.isEmpty) {
      return 'Please complete all the above fields';
    } else if (!OFGTextFormatting()
        .isValidEmail(_emailController.text.trim().toString())) {
      return 'Please enter a valid email';
    } else {
      return '1';
    }
  }

  _sendResetLinkAfterValidation() async {
    setState(() {
      _isLoading = true;
    });

    // auth service for login
    await PassWordResetService()
        .sendResetEmail(_emailController.text.trim(), context);
    setState(() {
      _isLoading = true;
    });
  }
}
