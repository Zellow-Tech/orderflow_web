import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ofg_web/models/vendor_model.dart';
import 'package:ofg_web/services/profile_services.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:ofg_web/utils/custom_widgets.dart';
import 'package:ofg_web/utils/tools.dart';
import 'package:ofg_web/views/home.dart';
import 'package:ofg_web/views/vendor/vendor_home.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;
  final VendorModel vendor;

  const EmailVerificationPage(
      {Key? key, required this.email, required this.vendor})
      : super(key: key);

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final CustomWidgets cWidgetsInstance = CustomWidgets();

  bool _isEmailVerified = false;
  Timer? timer;
  double counter = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    _isEmailVerified = _auth.currentUser!.emailVerified;
    sendEmailVerificationForUser();
    if (_isEmailVerified == false) {
      timer = Timer.periodic(
        const Duration(seconds: 5),
        (timer) {
          emailVerificationStatus(context);
          setState(() {
            counter++;
          });
        },
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    !_isEmailVerified ? deleteUserAccountCreated() : null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // this is the case when the user hasnt verified the email but still has over
        // 50 value in counter in which case the user account has to be deleted on will pop
        // and the stage set to true.
        if (counter > 50 && _isEmailVerified == false) {
          deleteUserAccountCreated();
          return true;
        }
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: 'Do not close the app at the moment! \n\n',
                    style: TextStyle(
                        color: ColorPalette().deletionRed, fontSize: 16)),
                TextSpan(
                    text:
                        'Please verify your email within 250 seconds by clicking the link sent to \n\n',
                    style: TextStyle(
                        color: ColorPalette().secondaryTextColor,
                        fontSize: 16)),
                TextSpan(
                    text: widget.email,
                    style: TextStyle(
                        color: ColorPalette().linkBlue,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        "\n\n Please check the 'spam' folder if you haven't received any emails from Orderflow general. ",
                    style: TextStyle(
                        color: ColorPalette().secondaryTextColor,
                        fontSize: 16)),
              ]),
              textAlign: TextAlign.center,
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
        // register the user's basic info provided to firestore here.
        await _registeruserData();
        // close registering here and move onto the next route.
        timer?.cancel();
        cWidgetsInstance.moveToPage(
            page: VendorHome(
              vendor: widget.vendor.toMap(),
            ),
            context: context,
            replacement: true);
      }
    } else if (counter >= 50 && _isEmailVerified == false) {
      deleteUserAccountCreated();
    }
  }

  deleteUserAccountCreated() async {
    try {
      _auth.currentUser!.delete();
      Tools().popRouteUntilRoot(context);
      cWidgetsInstance.moveToPage(
          page: const Home(), context: context, replacement: true);
      cWidgetsInstance.snackBarWidget(
          content: 'Unable to verify email.', context: context);
    } catch (e) {
      cWidgetsInstance.snackBarWidget(
          content: Tools().errorTextHandling(e.toString()), context: context);
    }
  }

  sendEmailVerificationForUser() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } catch (e) {
      cWidgetsInstance.snackBarWidget(
          content: Tools().errorTextHandling(e.toString()), context: context);
    }
  }

  _registeruserData() async {
    var res = await ProfileServices()
        .setStoreProfile(context: context, vendor: widget.vendor.toMap());
    if (res == '1') {
      return true;
    } else {
      _registeruserData();
    }
  }
}
