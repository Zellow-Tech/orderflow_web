import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofg_web/constants/urls/uris.dart';
import 'package:ofg_web/services/auth_services.dart';
import 'package:ofg_web/services/profile_services.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:ofg_web/utils/custom_widgets.dart';
import 'package:ofg_web/views/home.dart';
import 'package:ofg_web/views/vendor/store_options/edit_profile.dart';
import 'package:ofg_web/views/vendor/store_options/qr_page.dart';
import 'package:share_plus/share_plus.dart';

class StoreProfile extends StatefulWidget {
  final Map<String, dynamic>? vendorData;
  const StoreProfile({Key? key, this.vendorData}) : super(key: key);

  @override
  State<StoreProfile> createState() => _StoreProfileState();
}

class _StoreProfileState extends State<StoreProfile> {
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
  final CustomWidgets cWidgetsInstance = CustomWidgets();
  final ColorPalette _palette = ColorPalette();
  final URIs _uris = URIs();

  Map<dynamic, dynamic> profileData = {};
  bool _isLoading = false;

  bool isAdLoaded = false;

  @override
  void initState() {
    // this is to set the profile up
    widget.vendorData != null
        ? profileData = widget.vendorData!
        : storeProfileDataSetUp(context: context, force: true);

    // loading the banner ad

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldStateKey,

      // drawer
      drawer: cWidgetsInstance.navDrawer(
        context,
        'Store Profile',
        Icon(
          Icons.store_mall_directory_outlined,
          color: ColorPalette().secondaryTextColor,
        ),
      ),
      // Appbar
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        leading: Platform.isAndroid
            ? IconButton(
                onPressed: () {
                  // open nav drawer
                  _scaffoldStateKey.currentState!.openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: ColorPalette().inactiveIconGrey,
                ))
            : null,
        title: Text('Store Profile',
            style: GoogleFonts.montserrat(
                color: ColorPalette().primaryBlue,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),

      // body
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: ColorPalette().primaryBlue,
                ),
              )
            : RefreshIndicator(
                onRefresh: () =>
                    storeProfileDataSetUp(context: context, force: true),
                child: ListView(
                  children: [
                    // create a store header that shows profile edit, profile pic and Vendor address.
                    SizedBox(
                      height: height * 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // The profile image and name ui
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // The profile image Circle avatar
                              Container(
                                height: width * 0.2,
                                width: width * 0.2,
                                decoration: BoxDecoration(
                                  color: ColorPalette().containerGrey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: profileData['profilePicture'] == null ||
                                        profileData['profilePicture'] == ""
                                    ? Icon(
                                        Icons.person_add_alt_1_rounded,
                                        color: ColorPalette().primaryBlue,
                                        size: width * 0.08,
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          profileData['profilePicture'],
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(
                                              Icons.error_outline_rounded,
                                              color: ColorPalette().deletionRed,
                                            );
                                          },
                                        ),
                                      ),
                              ),

                              // The edit profile outlibed button
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                    color: ColorPalette().primaryBlue,
                                  )),
                                  onPressed: () async {
                                    // go to the edit page where the profile image and
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return EditProfile(
                                              url: _isLoading
                                                  ? ''
                                                  : profileData[
                                                      'profilePicture']);
                                        },
                                      ),
                                    );
                                  },
                                  child: const Text('Edit Logo'),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: height * 0.02),

                          // The store name and desc
                          Text(
                            profileData['storeName'].toString(),
                            style: GoogleFonts.heebo(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: ColorPalette().secondaryTextColor),
                          ),
                          Text(
                            '${profileData['emailId']}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: ColorPalette().inactiveIconGrey),
                          ),
                        ],
                      ),
                    ),

                    //  create the listiles list veiw that is going to hold other funcs, incl settings,

                    // settings for ios devices
                    Platform.isAndroid
                        ? const SizedBox(
                            height: 0,
                          )
                        : ListTile(
                            onTap: () {
                              // move to the settings page for ios
                            },
                            leading: Icon(
                              CupertinoIcons.gear,
                              color: ColorPalette().primaryBlue,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: ColorPalette().textGrey,
                              size: width * 0.04,
                            ),
                            title: Text(
                              'Settings',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: ColorPalette().secondaryTextColor),
                            ),
                          ),

                    // Stats
                    ListTile(
                      onTap: () async {
                        // move to the states page
                        await Share.share(
                            'Get OrderFlow General for your business too! Click https://play.google.com/store/apps/details?id=com.zellow.orderflowgeneral',
                            subject: 'Get Orderflow for FREE!!!');
                      },
                      leading: Icon(
                        CupertinoIcons.share,
                        color: ColorPalette().primaryBlue,
                      ),
                      title: Text(
                        'Share',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: ColorPalette().secondaryTextColor),
                      ),
                    ),

                    // Personal QRC
                    ListTile(
                      onTap: () => cWidgetsInstance.moveToPage(
                          page: QRPage(
                              storeName: widget.vendorData!['storeName']),
                          context: context,
                          replacement: false),
                      leading: Icon(
                        Icons.qr_code_rounded,
                        color: ColorPalette().primaryBlue,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: ColorPalette().textGrey,
                        size: width * 0.04,
                      ),
                      title: Text(
                        'Store QR',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: ColorPalette().secondaryTextColor),
                      ),
                    ),

                    SizedBox(
                      height: height * 0.02,
                    ),

                    Divider(
                      color: ColorPalette().textGrey,
                      indent: width * 0.2,
                      endIndent: width * 0.2,
                    ),

                    SizedBox(
                      height: height * 0.02,
                    ),

                    // Contact support
                    ListTile(
                      onTap: () {
                        cWidgetsInstance.launchItemInPhone(
                            'mailto:zellow.india@gmail.com', context);
                      },
                      leading: Icon(
                        Icons.support_agent_rounded,
                        color: ColorPalette().primaryBlue,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: ColorPalette().textGrey,
                        size: width * 0.04,
                      ),
                      title: Text(
                        'Contact Support',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: ColorPalette().secondaryTextColor),
                      ),
                    ),

                    // TNC
                    ListTile(
                      onTap: () {
                        cWidgetsInstance.launchItemInPhone(_uris.tnc, context);
                      },
                      leading: Icon(
                        Icons.library_books_outlined,
                        color: ColorPalette().primaryBlue,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: ColorPalette().textGrey,
                        size: width * 0.04,
                      ),
                      title: Text(
                        'Terms & Conditions',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: ColorPalette().secondaryTextColor),
                      ),
                    ),

                    // privacy policy
                    ListTile(
                      onTap: () {
                        cWidgetsInstance.launchItemInPhone(
                            _uris.privacyPolicy, context);
                      },
                      leading: Icon(
                        Icons.policy_outlined,
                        color: ColorPalette().primaryBlue,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: ColorPalette().textGrey,
                        size: width * 0.04,
                      ),
                      title: Text(
                        'Privacy Policy',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: ColorPalette().secondaryTextColor),
                      ),
                    ),

                    SizedBox(
                      height: height * 0.02,
                    ),

                    Divider(
                      color: ColorPalette().textGrey,
                      indent: width * 0.2,
                      endIndent: width * 0.2,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),

                    // Signout incase of iOS
                    ListTile(
                      onTap: () {
                        AuthServices().signUserOut(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const Home();
                            },
                          ),
                        );
                      },
                      leading: Icon(
                        Icons.logout_rounded,
                        color: ColorPalette().deletionRed,
                      ),
                      tileColor: _palette.buttonBgRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(height * 0.018),
                      ),
                      title: Text(
                        'Sign Out',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: ColorPalette().secondaryTextColor),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  // store profile data setup
  storeProfileDataSetUp(
      {required BuildContext context, required bool force}) async {
    setState(() {
      _isLoading = true;
    });

    if (force) {
      // get the store data using firebase store services
      var map = await ProfileServices().getProfileData(context: context);
      setState(() {
        profileData = map ?? {};
        _isLoading = false;
      });
    } else {
      if (widget.vendorData != null) {
        setState(() {
          profileData = widget.vendorData!;
          _isLoading = false;
        });
      } else {
        // get the store data using firebase store services
        var map = await ProfileServices().getProfileData(context: context);
        setState(() {
          profileData = map ?? {};
          _isLoading = false;
        });
      }
    }
  }
}
