import 'package:flutter/material.dart';
import 'package:ofg_web/services/password_reset_service.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:ofg_web/utils/custom_widgets.dart';
import 'package:ofg_web/utils/tools.dart';

// ignore: must_be_immutable
class PasswordResetPage extends StatefulWidget {
  String email;
  PasswordResetPage({Key? key, required this.email}) : super(key: key);

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final CustomWidgets cWidgetsInstance = CustomWidgets();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: cWidgetsInstance.customAppBar(context, false, true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Center(
          child: ListView(
            children: [
              // the asset image
              SizedBox(
                  height: height * 0.3,
                  child: Image.asset('assets/illustrations/emtylist.png')),
              SizedBox(
                height: height * 0.06,
              ),
              // receive email text
              const Text(
                'Receive a recovery email from OrderFlow General to reset your password by entering the email linked to your account.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),

              // the email enterinf field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Email'),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),

              // The main button that triggers the enail password reset function
              ElevatedButton.icon(
                onPressed: () {
                  emailController.text == widget.email &&
                          Tools().isValidEmail(emailController.text)
                      ? PassWordResetService()
                          .sendResetEmail(emailController.text.trim(), context)
                      : cWidgetsInstance.snackBarWidget(
                          content: 'Please check the entered email',
                          context: context);
                },
                icon: const Icon(
                  Icons.email_rounded,
                  color: Colors.white,
                ),
                label: const Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette().primaryBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(height * 0.04)),
                    elevation: 0,
                    padding: const EdgeInsets.all(12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
