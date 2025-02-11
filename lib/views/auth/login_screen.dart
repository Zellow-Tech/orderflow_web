import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:ofg_web/constants/color_palette.dart';
import 'package:ofg_web/constants/texts.dart';
import 'package:ofg_web/routes/app/app_endpoints.dart';
import 'package:ofg_web/services/auth_services.dart';
import 'package:ofg_web/utils/text_formatting.dart';
import 'package:ofg_web/widgets/snackbar.dart';
import 'package:ofg_web/widgets/top_label_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Custom input field widget
  final TopLabelTextField topLabelTextField = TopLabelTextField();

  // Color palette instance
  final OFGColorPalette _palette = OFGColorPalette();

  // Password visibility toggle
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 500, // Fixed width for web, matching registration page
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
                        OFGTexts.appTagline,
                        style: TextStyle(
                          fontSize: 14,
                          color: _palette.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.02),

                // Email Input Field
                topLabelTextField.topLabelTextField(
                  controller: _emailController,
                  label: OFGTexts.loginEmailLabel,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  borderRadius: 10.0,
                  hintText: OFGTexts.loginEmailHint,
                  requiredField: true,
                ),
                SizedBox(height: height * 0.02),

                // Password Input Field with Toggle
                topLabelTextField.topLabelTextField(
                  controller: _passwordController,
                  label: OFGTexts.loginPasswordLabel,
                  keyboardType: TextInputType.text,
                  obscureText: _obscurePassword,
                  borderRadius: 10.0,
                  hintText: OFGTexts.loginPasswordHint,
                  requiredField: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),

                // The forgot password text heere
                InkWell(
                  onTap: () {
                    Get.toNamed('/forgotPassword');
                  },
                  child: Text(
                    OFGTexts.loginForgotPassword,
                    style: TextStyle(
                        color: _palette.linkBlue,
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                ),

                // Login Button
                SizedBox(height: height * 0.02),

                // _paletteRegister Button
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
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: () async {
                      // activate the loading for UI to update button
                      setState(() {
                        _isLoading = true;
                      });

                      // validate the text field
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
                        _signInAfterValidation();
                      }
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            OFGTexts.loginButton,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                  ),
                ),

                SizedBox(height: height * 0.03),

                // _paletteNavigate to Login Screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // "New to OFg" text
                    Text(
                      OFGTexts.loginNoAccount,
                      style: TextStyle(
                        fontSize: 15,
                        color: _palette.tertiaryText,
                      ),
                    ),

                    // "Login here" clickable text
                    InkWell(
                      onTap: () {
                        Get.toNamed(OFGEndpoints.register);
                      },
                      child: Text(
                        ' ${OFGTexts.loginSignUp}',
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
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      return 'Please complete all the above fields';
    } else if (_passwordController.text.length < 8) {
      return 'Password should be 8 or more charecters long';
    } else if (!OFGTextFormatting()
        .isValidEmail(_emailController.text.trim().toString())) {
      return 'Please enter a valid email';
    } else {
      return '1';
    }
  }

  _signInAfterValidation() async {
    // vendor user registration

    setState(() {
      _isLoading = true;
    });

    // auth service for login
    String result = await AuthServices().signUserIn(
        email: _emailController.text.trim(),
        password: _passwordController.text);

    // check for the result
    if (result == '1') {
      // move to the dashboard
      Get.offAllNamed(OFGEndpoints.dashboard);
    }
    // lock out the loading to end it
    setState(() {
      _isLoading = false;
    });
  }
}
