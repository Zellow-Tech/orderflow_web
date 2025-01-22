// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ofg_web/services/media_services.dart';
import 'package:ofg_web/constants/urls/firebase_endpoints.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:ofg_web/utils/custom_widgets.dart';
import 'package:ofg_web/utils/tools.dart';

class EditProfile extends StatefulWidget {
  String url;
  EditProfile({Key? key, required this.url}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final CustomWidgets cWidgetsInstance = CustomWidgets();
  final FirebaseRoutes _routes = FirebaseRoutes();

  int flag = 0;

  File? selectedProfileImage;

  final MediaServices mediaService = MediaServices(
      type: 'Vendor', uid: FirebaseAuth.instance.currentUser!.uid);
  String imageUrl = '';
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      imageUrl = widget.url;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: !_isLoading,
      child: Scaffold(
        // appbar
        appBar: _isLoading
            ? null
            : AppBar(
                actions: [
                  TextButton(
                    onPressed: () {
                      // launch the modal bottom sheet here
                      launchBottomSheet(context, height);
                    },
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        color: ColorPalette().linkBlue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                elevation: 0,
                shadowColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () {
                    flag == 1
                        ? Navigator.pop(context, true)
                        : Navigator.pop(context, false);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: ColorPalette().inactiveIconGrey,
                  ),
                ),
              ),

        // body
        body: InkWell(
          onTap: () {
            // Show bottom sheet popup in here to upload image or remove image.
            launchBottomSheet(context, height);
          },
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      color: ColorPalette().primaryBlue),
                )
              : Center(
                  child: imageUrl == ''
                      ? Icon(
                          Icons.person_add_alt_1_rounded,
                          size: width * 0.08,
                          color: ColorPalette().primaryBlue,
                        )
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          height: height * 0.4,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.error_outline_rounded,
                              color: ColorPalette().deletionRed,
                            );
                          },
                          width: width,
                        ),
                ),
        ),
      ),
    );
  }

  launchBottomSheet(BuildContext context, double height) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // remove photo if there exist none.
              widget.url != ''
                  ? CupertinoActionSheetAction(
                      onPressed: () {
                        // delete media from storage
                        setState(() {
                          _isLoading = true;
                          Navigator.pop(context);
                        });

                        // delete media action
                        profileAction(context: context, action: 'remove');
                      },
                      isDestructiveAction: true,
                      child: const Text('Remove Photo'),
                    )
                  : const SizedBox(
                      height: 0,
                    ),

              // take a picture
              CupertinoActionSheetAction(
                onPressed: () async {
                  // take a picture and if not null then upload it to storage i guess?
                  selectedProfileImage =
                      await mediaService.takePicturesUsingCamera(context);
                  Navigator.pop(context);

                  if (selectedProfileImage != null) {
                    setState(() {
                      _isLoading = true;
                    });

                    // take photo action
                    profileAction(context: context, action: 'take photo');
                  }
                  if (flag == 1) {
                    Navigator.pop(context);
                  }
                },
                isDestructiveAction: false,
                child: const Text('Take Photo'),
              ),

              // choose ono from gallery
              CupertinoActionSheetAction(
                onPressed: () async {
                  // choose an image fromm gallery
                  selectedProfileImage =
                      await mediaService.pickImageFromGallery();
                  Navigator.pop(context);

                  if (selectedProfileImage != null) {
                    setState(() {
                      _isLoading = true;
                    });

                    // choose photo action
                    profileAction(context: context, action: '');
                  }

                  if (flag == 1) {
                    Navigator.pop(context);
                  }
                },
                isDestructiveAction: false,
                child: const Text('Choose Photo'),
              )
            ],
          );
        });
  }

  profileAction({required BuildContext context, required String action}) async {
    if (action == 'remove') {
      FirebaseFirestore.instance
          .collection(_routes.rootCollection)
          .doc(_routes.profileDoc)
          .collection(_routes.fUid)
          .doc(_routes.profileData)
          .update({'profilePicture': ""});
      mediaService.mediaDeletionFromStorage(
          context: context, route: _routes.vendorProfileRoute);

      Navigator.pop(context, true);

      cWidgetsInstance.snackBarWidget(
          content:
              'Removed your profile picture. Changes will be reflected soon.',
          context: context);

      //
    } else {
      delAndUploadAndStateSet();
    }
  }

  delAndUploadAndStateSet() async {
    try {
      if (imageUrl != '') {
        // delete old photo
        await mediaService.mediaDeletionFromStorage(
            context: context, route: _routes.vendorProfileRoute);
      }

      // upload the image to the directory in Vendor
      List url = await mediaService.mediaUploadToRoute(
        route: _routes.vendorProfileRoute,
        context: context,
        files: [selectedProfileImage],
      );

      await FirebaseFirestore.instance
          .collection(_routes.rootCollection)
          .doc(_routes.profileDoc)
          .collection(_routes.fUid)
          .doc(_routes.profileData)
          .update({'profilePicture': url[0]});

      setState(() {
        flag = 1;
        _isLoading = false;
        imageUrl = url[0];
      });
      cWidgetsInstance.snackBarWidget(
          content:
              'Profile picutre updated successfully. Changes will be reflected soon.',
          context: context);
    } catch (e) {
      cWidgetsInstance.snackBarWidget(
          content: Tools().errorTextHandling(e.toString()), context: context);
    }
  }
}
