// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ofg_web/services/auth_services.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:ofg_web/utils/custom_widgets.dart';
import 'package:ofg_web/utils/tools.dart';
import 'package:ofg_web/views/vendor/vendor_home.dart';
import 'package:ofg_web/views/home.dart';
import 'package:ofg_web/views/common/password_reset.dart';

// ignore: must_be_immutable
class AccountLogin extends StatefulWidget {
  const AccountLogin({Key? key}) : super(key: key);

  @override
  State<AccountLogin> createState() => _AccountLoginState();
}

class _AccountLoginState extends State<AccountLogin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CustomWidgets cWidgetsInstance = CustomWidgets();

  TextEditingController emailController = TextEditingController();
  TextEditingController passcodeController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final TopLabelTextField topLabelTextField = TopLabelTextField();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: cWidgetsInstance.customAppBar(context, false, true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: ListView(
          children: [
// The main title for the screen
            const Text(
              'Sign In',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              'for Store partners',
              style: TextStyle(
                  fontSize: 14, color: ColorPalette().tertiaryTextColor),
            ),

            SizedBox(
              height: height * 0.05,
            ),

// The email text field in sign in for carrier partners
            topLabelTextField.topLabelTextField(
                controller: emailController,
                label: 'email ',
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                borderRadius: 12.0,
                hintText: 'example@xyz.abc',
                requiredField: true),

            SizedBox(
              height: height * 0.03,
            ),

// The oasswkrds text field in sign in for carrier partners
            topLabelTextField.topLabelTextField(
                controller: passcodeController,
                label: 'password ',
                keyboardType: TextInputType.text,
                obscureText: true,
                borderRadius: 12.0,
                hintText: 'enter your password here',
                requiredField: true),

            SizedBox(
              height: height * 0.01,
            ),

// The forgot password text heere
            InkWell(
              onTap: () {
                Tools().isValidEmail(emailController.text.trim())
                    ? cWidgetsInstance.moveToPage(
                        page: PasswordResetPage(email: emailController.text),
                        context: context,
                        replacement: false)
                    : cWidgetsInstance.snackBarWidget(
                        content: 'Enter a valid email',
                        context: _scaffoldKey.currentContext!);
              },
              child: Text(
                '\nRecover Password? ',
                style: TextStyle(
                    color: ColorPalette().linkBlue,
                    fontWeight: FontWeight.w400,
                    fontSize: 15),
              ),
            ),

            SizedBox(
              height: height * 0.26,
            ),

// The main sign in button for the auth of vendor partners
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette().primaryBlue,
                side: BorderSide(
                  width: 1,
                  color: ColorPalette().inactiveIconGrey,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
                padding: const EdgeInsets.all(12),
              ),
              onPressed: () async {
                if (validateForms()) {
                  setState(() {
                    _isLoading = !_isLoading;
                  });

                  // Sign in the user
                  List res = await AuthServices().signUserIn(
                      email: emailController.text.trim(),
                      password: passcodeController.text);

                  if (res[0] == '1') {
                    setState(() {
                      _isLoading = !_isLoading;
                    });
                    Navigator.pop(context);
                    cWidgetsInstance.moveToPage(
                        page: const VendorHome(),
                        context: context,
                        replacement: true);
                  } else {
                    cWidgetsInstance.snackBarWidget(
                        content: 'Something went wrong',
                        context: _scaffoldKey.currentContext!);
                  }
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(cWidgetsInstance.snackBarWidget(
                    context: _scaffoldKey.currentContext!,
                    content: 'Entered fields are incorrect',
                  ));
                }
              },
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      'Sign In',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
            ),

            SizedBox(
              height: height * 0.05,
            ),

// The go back to sign up screen aka home
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'New to OrderFlow? ',
                  style: TextStyle(
                      fontSize: 15, color: ColorPalette().tertiaryTextColor),
                ),
                InkWell(
                  // Go to sign up page with an alert dialog pop  up
                  onTap: () {
                    Navigator.pop(context);
                    cWidgetsInstance.moveToPage(
                        page: const Home(),
                        context: context,
                        replacement: true);
                  },

                  child: Text(
                    'Sign Up',
                    style:
                        TextStyle(fontSize: 15, color: ColorPalette().linkBlue),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

// Implement the calidation for sign in
  bool validateForms() {
    if (emailController.text.isNotEmpty &&
        passcodeController.text.isNotEmpty &&
        passcodeController.text.length >= 8 &&
        Tools().isValidEmail(emailController.text)) {
      return true;
    }
    return false;
  }
}
