import 'package:flutter/material.dart';
import 'package:ofg_web/constants/color_palette.dart';
import 'package:ofg_web/constants/texts.dart';
import 'package:ofg_web/widgets/top_label_text_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Controllers for form fields
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Widget for custom text fields
  final TopLabelTextField topLabelTextField = TopLabelTextField();

  // Color palette instance
  final OFGColorPalette _palette = OFGColorPalette();

  // Password visibility toggle
  bool _obscurePassword = true;

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
            width: 500, // Fixed width for web
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

                // _paletteOwner's Name Field
                topLabelTextField.topLabelTextField(
                  controller: _ownerNameController,
                  label: OFGTexts.registerOwnerNameLabel,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  borderRadius: 10.0,
                  hintText: OFGTexts.registerOwnerNameHint,
                  requiredField: true,
                ),
                SizedBox(height: height * 0.02),

                // _paletteStore Name Field
                topLabelTextField.topLabelTextField(
                  controller: _storeNameController,
                  label: OFGTexts.registerStoreNameLabel,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  borderRadius: 10.0,
                  hintText: OFGTexts.registerStoreNameHint,
                  requiredField: true,
                ),
                SizedBox(height: height * 0.02),

                // _paletteEmail Field
                topLabelTextField.topLabelTextField(
                  controller: _emailController,
                  label: OFGTexts.registerEmailLabel,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  borderRadius: 10.0,
                  hintText: OFGTexts.registerEmailHint,
                  requiredField: true,
                ),
                SizedBox(height: height * 0.02),

                // _palettePassword Field with Visibility Toggle
                topLabelTextField.topLabelTextField(
                  controller: _passwordController,
                  label: OFGTexts.registerPasswordLabel,
                  keyboardType: TextInputType.text,
                  obscureText: _obscurePassword,
                  borderRadius: 10.0,
                  hintText: OFGTexts.registerPasswordHint,
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

                SizedBox(height: height * 0.02),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'By signing up you are agreeing to our ',
                      overflow: TextOverflow.visible,
                      style:
                          TextStyle(fontSize: 15, color: _palette.tertiaryText),
                    ),
                    InkWell(
                      // go to the tnc readme on github
                      onTap: () async {},

                      child: Text(
                        'Terms and Conditions',
                        overflow: TextOverflow.visible,
                        style:
                            TextStyle(fontSize: 15, color: _palette.linkBlue),
                      ),
                    ),
                  ],
                ),

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
                      elevation: 0,
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: () async {
                      // TODO: Implement registration logic here
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            OFGTexts.registerButton,
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
                    // "Already have an account?" text
                    Text(
                      OFGTexts.registerAlreadyHaveAccount,
                      style: TextStyle(
                        fontSize: 15,
                        color: _palette.tertiaryText,
                      ),
                    ),

                    // "Login here" clickable text
                    InkWell(
                      onTap: () {
                        // TODO: Implement navigation to login page
                      },
                      child: Text(
                        ' ${OFGTexts.registerLogin}',
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
}
