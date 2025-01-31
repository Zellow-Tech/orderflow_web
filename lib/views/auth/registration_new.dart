import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
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
                const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 20),
                TopLabelTextField().topLabelTextField(
                  controller: _ownerNameController,
                  label: 'Owner\'s Name',
                  hintText: 'Enter the owner\'s name',
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  requiredField: true,
                  borderColor: Colors.teal,
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
                  borderColor: Colors.teal,
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
                  borderColor: Colors.teal,
                  borderRadius: 8.0,
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Password',
                          style: TextStyle(fontSize: 14, color: Colors.teal),
                        ),
                        Text(
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
                        hintStyle:
                            TextStyle(fontSize: 14, color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Colors.teal),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle registration logic
                      print('Registering...');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: Colors.teal,
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 16),
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

// Placeholder for the TopLabelTextField class
class TopLabelTextField {
  TopLabelTextField();

  Widget topLabelTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required TextInputType keyboardType,
    required bool obscureText,
    required bool requiredField,
    Color? borderColor,
    int? maxLines,
    int? maxLength,
    double? borderRadius,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, color: borderColor ?? Colors.teal),
            ),
            requiredField
                ? const Text(
                    '*',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          maxLength: maxLength,
          maxLines: maxLines ?? 1,
          keyboardType: keyboardType,
          obscureText: obscureText,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor ?? Colors.teal),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor ?? Colors.teal),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
            ),
          ),
        ),
      ],
    );
  }
}
