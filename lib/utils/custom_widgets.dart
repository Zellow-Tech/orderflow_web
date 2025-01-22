import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofg_web/constants/urls/uris.dart';
import 'package:ofg_web/views/home.dart';
import 'package:ofg_web/views/vendor/store_listings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ofg_web/services/auth_services.dart';
import 'package:ofg_web/utils/constants.dart';

final ColorPalette _palette = ColorPalette();

// the custom text field
class TopLabelTextField {
  TopLabelTextField();

  topLabelTextField(
      {required controller,
      required label,
      required hintText,
      required keyboardType,
      required obscureText,
      required requiredField,
      borderColor,
      maxLines,
      maxLength,
      borderRadius}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            // the label above top
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: _palette.primaryBlue,
              ),
            ),
            requiredField
                ? const Text(
                    '*',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  )
                : const SizedBox(
                    width: 0,
                  ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          maxLength: maxLength,
          maxLines: maxLines != null ? maxLines! : 1,
          keyboardType: keyboardType,
          obscureText: obscureText,
          cursorColor: _palette.primaryBlue,
          autocorrect: true,
          autofocus: false,
          controller: controller,
          decoration: InputDecoration(
            focusedBorder: borderColor != null
                ? OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor!))
                : null,
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
            border: borderRadius == null
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    borderSide: BorderSide(color: _palette.primaryBlue))
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: BorderSide(color: _palette.primaryBlue)),
          ),
        ),
      ],
    );
  }
}

// the custom splash loading animation
class CustomLoaders {
  dataLoaderAnimation(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Orderflow',
              style: GoogleFonts.montserrat(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'General',
              style: GoogleFonts.montserrat(
                fontSize: 32,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.05,
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.35,
                child: const LinearProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PlaceholderDialog extends StatelessWidget {
  const PlaceholderDialog({
    this.icon,
    this.title,
    this.message,
    this.actions = const [],
    Key? key,
  }) : super(key: key);

  final Widget? icon;
  final String? title;
  final String? message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      icon: icon,
      title: title == null
          ? null
          : Text(
              title!,
              textAlign: TextAlign.center,
            ),
      content: message == null
          ? null
          : Text(
              message!,
              textAlign: TextAlign.center,
            ),
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowButtonSpacing: 8.0,
      actions: actions,
    );
  }
}

class CustomWidgets {
  final URIs _uris = URIs();

  customAppBar(BuildContext context, bool signOut, bool backArrow) {
    return AppBar(
      actions: signOut
          ? [
              IconButton(
                  onPressed: () async {
                    await AuthServices().signUserOut(context);
                  },
                  icon: Icon(
                    Icons.logout_rounded,
                    color: _palette.inactiveIconGrey,
                  ))
            ]
          : [],
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      leading: backArrow
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: _palette.inactiveIconGrey,
              ),
            )
          : null,
    );
  }

  // navigatoion method
  moveToPage(
      {required Widget page,
      required BuildContext context,
      required bool replacement}) {
    if (replacement) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return page;
      }));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return page;
      }));
    }
  }

  // snack bar widget
  snackBarWidget({required String content, required BuildContext context}) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(content),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
  }

  // the main nav drawer
  navDrawer(BuildContext context, String page, Icon icon) {
    return Platform.isIOS
        ? null
        : Drawer(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            child: ListView(
              children: [
                // Drawer header image here
                const DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/illustrations/card-bg.jpg'),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 12.0,
                        left: 16.0,
                        child: Text("OrderFlow",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),

                // The List items start here
                // Home
                _drawerItem(page, icon, 1, context),

                // products
                // _drawerItem(
                //     'Products',
                //     Icon(Icons.shopping_bag_outlined,
                //         color: _palette.secondaryTextColor),
                //     2,
                //     context),

                // Create an ad campaign
                // _drawerItem(
                //     'Campaign',
                //     Icon(Icons.campaign_outlined,
                //         color: _palette.secondaryTextColor),
                //     3,
                //     context),

                // contact
                _drawerItem(
                    'Contact',
                    Icon(Icons.person_add_alt_1_outlined,
                        color: _palette.secondaryTextColor),
                    4,
                    context),

                // Divider
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Divider(
                    color: _palette.inactiveIconGrey,
                  ),
                ),

                // Privacy Policy
                _drawerItem(
                    'Privacy Policy',
                    Icon(
                      Icons.policy_outlined,
                      color: _palette.secondaryTextColor,
                    ),
                    5,
                    context),

                _drawerItem(
                    'Terms & Conditions',
                    Icon(Icons.my_library_books_outlined,
                        color: _palette.secondaryTextColor),
                    6,
                    context),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.26,
                ),

                // sign user out
                _drawerItem(
                    'Sign Out',
                    Icon(Icons.logout_rounded, color: _palette.deletionRed),
                    7,
                    context),
              ],
            ),
          );
  }

  // the url launching method
  launchItemInPhone(String url, BuildContext context) async {
    if (!await launchUrl(Uri.parse(url))) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Could not open link.'),
      ));
    }
  }

  // the item in the drawer
  _drawerItem(String title, Icon icon, int index, BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 18, color: _palette.secondaryTextColor),
      ),
      leading: icon,
      onTap: () {
        switch (index) {
          case 1:
            Navigator.pop(context);
            break;

          // go to products list page
          case 2:
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const StoreListing();
            }));
            break;

          // open campaign page in web
          case 3:
            break;

          // open contacts
          case 4:
            launchItemInPhone("mailto:shimron.alakkal1804@gmail.com", context);
            break;

          // the privacy policy launcher
          case 5:
            launchItemInPhone(_uris.privacyPolicy, context);
            break;

          // the terms and conditions page
          case 6:
            launchItemInPhone(_uris.tnc, context);
            break;

          // sign the user out
          case 7:
            AuthServices().signUserOut(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const Home();
                },
              ),
            );
            break;
        }
      },
    );
  }
}
