import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:ofg_web/constants/color_palette.dart';
import 'package:ofg_web/constants/texts.dart';
import 'package:ofg_web/models/vendor_model.dart';
import 'package:ofg_web/routes/app/app_endpoints.dart';
import 'package:ofg_web/services/profile_services.dart';

class EmailVerificationPage extends StatefulWidget {
  final VendorModel vendor;

  const EmailVerificationPage({super.key, required this.vendor});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final OFGColorPalette _palette = OFGColorPalette();
  bool _isEmailVerified = false;
  Timer? timer;
  double counter = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // check if the email is verified
    _isEmailVerified = _auth.currentUser!.emailVerified;

    // inital email verification sender
    sendEmailVerificationForUser();

    // loop over every 5 seconds to recheck for verification
    if (!_isEmailVerified) {
      timer = Timer.periodic(
        const Duration(seconds: 5),
        (timer) {
          emailVerificationStatus(context);
          setState(
            () {
              counter++;
            },
          );
        },
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    // dispose timer on email verification
    timer?.cancel();
    // if not verified and timer is up, delete user account that was created
    // this prevents the user from not being able to create an account when they want to, later.
    !_isEmailVerified ? deleteUserAccountCreated() : null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        // this is the case when the user hasnt verified the email but still has over
        // 50 value in counter in which case the user account has to be deleted on will pop
        // and the stage set to true.
        if (counter > 50 && _isEmailVerified == false) {
          deleteUserAccountCreated();
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width:
                  500, // Fixed width for web, matching login & register pages
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
                    'A verification link has been sent to your registered email address. Please check your inbox and follow the instructions to verify your email in 250 seconds.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: _palette.tertiaryText,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Navigate to Login Screen
                  Text(
                    'Do NOT close this page',
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
      ),
    );
  }

  emailVerificationStatus(BuildContext context) async {
    if (counter < 50) {
      try {
        // check the verification status
        await _auth.currentUser!.reload();
        setState(() {
          _isEmailVerified = _auth.currentUser!.emailVerified;
        });
      } catch (e) {
        // on error or anything, delete the user account
        deleteUserAccountCreated();
      }
      setState(() {
        _isEmailVerified = _auth.currentUser!.emailVerified;
      });

      if (_isEmailVerified) {
        timer?.cancel();

        // register the vendor's basic info provided to firestore here.
        _registerVendorData();
        // close registering here and move onto the next route.
        // move to the main dashboard
        Get.offAllNamed(OFGEndpoints.dashboard);
      }
    } else if (counter >= 50) {
      // delete the account created
      deleteUserAccountCreated();
    }
  }

  // function delete the account created
  deleteUserAccountCreated() async {
    try {
      _auth.currentUser!.delete();
      // move to the main login screen with no context or pages in stack

      // show the snackbar telling the user about being unable to verify email.
    } catch (e) {
      // error snackbar for telling the error info to the user
    }
  }

  sendEmailVerificationForUser() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } catch (e) {
      // error snackbar
    }
  }

  _registerVendorData() async {
    var res = await OFGProfileServices()
        .registerStoreProfile(context: context, vendor: widget.vendor.toMap());
    if (res == '1') {
      return true;
    } else {
      _registerVendorData();
    }
  }
}
