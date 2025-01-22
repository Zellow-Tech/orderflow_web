import 'package:flutter/material.dart';
import 'package:ofg_web/constants/urls/firebase_endpoints.dart';
import 'package:ofg_web/models/vendor_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ofg_web/services/auth_services.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:ofg_web/utils/custom_widgets.dart';
import 'package:ofg_web/utils/tools.dart';
import 'package:ofg_web/views/common/email_verification.dart';

// ignore: must_be_immutable
class AccountCreation extends StatefulWidget {
  const AccountCreation({Key? key}) : super(key: key);

  @override
  State<AccountCreation> createState() => _AccountCreationState();
}

class _AccountCreationState extends State<AccountCreation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CustomWidgets cWidgetsInstance = CustomWidgets();

  TextEditingController emailController = TextEditingController();
  TextEditingController passcodeController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController storeNameController = TextEditingController();

  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passcodeController.dispose();
    storeNameController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    TopLabelTextField topLabelTextField = TopLabelTextField();

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
              'Create your account',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              'for Business partners',
              style: TextStyle(
                  fontSize: 14, color: ColorPalette().tertiaryTextColor),
            ),

            SizedBox(
              height: height * 0.05,
            ),

// The legal name text field
            topLabelTextField.topLabelTextField(
                controller: nameController,
                label: 'legal name ',
                keyboardType: TextInputType.text,
                obscureText: false,
                borderRadius: 12.0,
                hintText: 'enter your legal name here',
                requiredField: true),

            SizedBox(
              height: height * 0.03,
            ),

// The phone number field
            topLabelTextField.topLabelTextField(
                controller: storeNameController,
                label: 'store name',
                hintText: 'enter your store name here',
                keyboardType: TextInputType.text,
                obscureText: false,
                borderRadius: 12.0,
                requiredField: true),

            SizedBox(
              height: height * 0.03,
            ),

// The email text field in sign in for carrier partners
            topLabelTextField.topLabelTextField(
                controller: emailController,
                label: 'email',
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
                label: 'password',
                keyboardType: TextInputType.text,
                obscureText: true,
                borderRadius: 12.0,
                hintText: 'enter your password here',
                requiredField: true),

            SizedBox(
              height: height * 0.1,
            ),

// The sign in terms and conditions
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'By signing up you are agreeing to our ',
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      fontSize: 15, color: ColorPalette().tertiaryTextColor),
                ),
                InkWell(
                  // go to the tnc readme on github
                  onTap: () async {
                    !await launchUrl(Uri.parse(
                        'https://github.com/ShimronAlakkal/opentest/blob/main/tnc.md'));
                  },

                  child: Text(
                    'Terms and Conditions',
                    overflow: TextOverflow.visible,
                    style:
                        TextStyle(fontSize: 15, color: ColorPalette().linkBlue),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: height * 0.025,
            ),

// The main sign in button for the auth of carrier partners
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
                  padding: const EdgeInsets.all(12)),

              // register account based on Vendor or carrier partner
              onPressed: () async {
                // This is checking for text field validatoins
                String tvalRes = _textFieldValidation();
                if (tvalRes == '1') {
                  // meaning, textFields are valideated on a basic level
                  // Go to the next conditional checking for carrier AC or Vendor AC

                  signUserUpAfterValidation(context);
                } else {
                  setState(() {
                    _isLoaded = false;
                  });
                  // return the message returned by the scaff
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(tvalRes)));
                }
              },

              child: _isLoaded
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      'Continue',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
            ),

            SizedBox(
              height: height * 0.025,
            ),
          ],
        ),
      ),
    );
  }

  String _textFieldValidation() {
// check if phone number is that of Indian origin, password is atleast 8 chars, and every other field is correct
    if (emailController.text.isEmpty ||
        passcodeController.text.isEmpty ||
        nameController.text.isEmpty ||
        storeNameController.text.isEmpty) {
      return 'Please complete all the above fields';
    } else if (passcodeController.text.length < 8) {
      return 'Password should be 8 or more charecters long';
    } else if (!Tools().isValidEmail(emailController.text.trim().toString())) {
      return 'Please enter a valid email';
    } else {
      return '1';
    }
  }

  signUserUpAfterValidation(BuildContext context) async {
    // vendor user registration

    setState(() {
      _isLoaded = true;
    });

    String result = await AuthServices().signVendorUp(
        email: emailController.text.trim(), password: passcodeController.text);

    if (result == '1') {
      var fuid = FirebaseRoutes().fUid;


      // create the first basic vendor to passover to the email verif page
      // VendorModel vendor = VendorModel(
      //     firebaseUid: fuid,
      //     storeName: storeNameController.text,
      //     isBanned: false,
      //     ownerName: nameController.text,
      //     emailId: emailController.text.trim(),
      //     phoneNumber: '',
      //     address: '',
      //     bio: '',
      //     profilePicture: '',
      //     metadata: [],
      //     upiIds: []);

      cWidgetsInstance.moveToPage(
          page: EmailVerificationPage(
            email: emailController.text,
            vendor: VendorModel(
                firebaseUid: fuid,
                storeName: storeNameController.text,
                isBanned: false,
                ownerName: nameController.text,
                emailId: emailController.text.trim(),
                phoneNumber: '',
                address: '',
                bio: '',
                profilePicture: '',
                metadata: [],
                upiIds: []).toMap(),
          ),
          context: context,
          replacement: true);
      setState(() {
        _isLoaded = false;
      });
    } else {
      setState(() {
        _isLoaded = false;
      });
      cWidgetsInstance.snackBarWidget(
          context: _scaffoldKey.currentContext!,
          content: Tools().errorTextHandling(result));
    }
  }
}
