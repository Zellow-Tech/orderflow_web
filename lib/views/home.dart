import 'package:flutter/material.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:ofg_web/views/common/account_creation_page.dart';
import 'package:ofg_web/views/common/account_login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(
              height: height * 0.06,
            ),
// The image or png that is used in the su screen
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                radius: width * 0.32,
                child: Image.asset(
                  'assets/illustrations/wlcm.png',
                ),
              ),
            ),

            SizedBox(
              height: height * 0.04,
            ),

// The welcome text that is the main thing
            const Text(
              'Welcome!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(
              height: height * 0.02,
            ),

// The small desription on what to do next
            Text(
              "Sign up to be a partner, if you haven’t already.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorPalette().tertiaryTextColor,
                fontSize: 14,
              ),
            ),

            SizedBox(
              height: height * 0.16,
            ),

// The elevated button that is for the Vendores to register
            ElevatedButton.icon(
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

              // Register as Vendor button action on click
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AccountCreation();
                }));
              },
              icon: const Icon(
                Icons.add_business_outlined,
                color: Colors.white,
              ),
              label: const Text(
                'Register my business',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),

            SizedBox(
              height: height * 0.025,
            ),

// The 'or' divider between the two main buttons
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.1, vertical: height * 0.025),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                        height: 1,
                        thickness: 1,
                        color: ColorPalette().tertiaryTextColor),
                  ),
                  Text(
                    '  or  ',
                    style: TextStyle(
                        fontSize: 14, color: ColorPalette().tertiaryTextColor),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      height: 1,
                      color: ColorPalette().tertiaryTextColor,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: height * 0.025,
            ),

// The  go to sign in text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(
                      fontSize: 15, color: ColorPalette().tertiaryTextColor),
                ),
                InkWell(
                  // Go to sign in page with an alert dialog pop  up
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const AccountLogin();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Sign In',
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
}
