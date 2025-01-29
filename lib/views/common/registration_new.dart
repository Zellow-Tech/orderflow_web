import 'package:flutter/material.dart';
import 'package:ofg_web/models/Invoice_PDF/invoice_pdf_model.dart';
import 'package:ofg_web/services/pdf_generation_services.dart';
import 'package:ofg_web/utils/custom_widgets.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

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
                        hintStyle: TextStyle(
                            fontSize: 14, color: Colors.grey.shade400),
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
                ElevatedButton(
                  onPressed: () => generateAndDownloadInvoice(context),
                  child: Text("Generate Invoice"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void generateAndDownloadInvoice(BuildContext context) {
    final invoiceDetails = IBDetails(
      invoiceNumber: "INV-123456",
      customerName: "John Doe",
      customerEmail: "john.doe@example.com",
      date: DateTime.now(),
      items: [
        // InvoiceItem(description: "Product 1", quantity: 2, unitPrice: 50.0),
        // InvoiceItem(description: "Product 2", quantity: 1, unitPrice: 100.0),
      ],
      totalAmount: 200.0,
    );

    final pdfGenerator = PdfInvoiceGenerator();
    pdfGenerator.printOrDownloadInvoice(context, invoiceDetails);
  }
}
