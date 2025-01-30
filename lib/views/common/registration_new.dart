import 'package:flutter/material.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:ofg_web/utils/custom_widgets.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final ColorPalette _palette = ColorPalette(); // Initialize color palette

  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
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
                  color: _palette.inactiveIconGrey.withOpacity(0.2),
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // OrderFlow General Branding (Logo + Name)
                Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: _palette.primaryBlue,
                      child: Icon(
                        Icons.shopping_cart,
                        size: 40,
                        color: Colors.white,
                      ), // Placeholder for logo
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'OrderFlow General',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _palette.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Seamless order management at your fingertips',
                      style: TextStyle(
                        fontSize: 14,
                        color: _palette.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Registration Form
                TopLabelTextField().topLabelTextField(
                  controller: _ownerNameController,
                  label: 'Owner\'s Name',
                  hintText: 'Enter the owner\'s name',
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  requiredField: true,
                  borderColor: _palette.primaryBlue,
                  borderRadius: 8.0,
                ),
                const SizedBox(height: 16),
                TopLabelTextField().topLabelTextField(
                  controller: _storeNameController,
                  label: 'Store Name',
                  hintText: 'Enter the store name',
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  requiredField: true,
                  borderColor: _palette.primaryBlue,
                  borderRadius: 8.0,
                ),
                const SizedBox(height: 16),
                TopLabelTextField().topLabelTextField(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  requiredField: true,
                  borderColor: _palette.primaryBlue,
                  borderRadius: 8.0,
                ),
                const SizedBox(height: 16),

                // Password Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 14,
                            color: _palette.primaryBlue,
                          ),
                        ),
                        const Text(
                          '*',
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: _palette.textGrey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: _palette.primaryBlue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: _palette.primaryBlue),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: _palette.inactiveIconGrey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      print('Registering...');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: _palette.secondaryButtonGreen,
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 16,
                        color: _palette.primaryBlue,
                      ),
                    ),
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
