import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants/urls/firebase_endpoints.dart';
import '../utils/custom_widgets.dart';
import '../utils/tools.dart';

class ProfileServices {
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  final FirebaseRoutes _firebaseRoutes = FirebaseRoutes();

  // get profile data
  getProfileData({required BuildContext context}) async {
    try {
      debugPrint('********************** calling server ');
      DocumentSnapshot snap = await _firestoreInstance
          .collection(_firebaseRoutes.rootCollection)
          .doc(_firebaseRoutes.profileDoc)
          .collection(_firebaseRoutes.fUid)
          .doc(_firebaseRoutes.profileData)
          .get();
      return (snap.data() as Map<String, dynamic>);
    } catch (e) {
      CustomWidgets().snackBarWidget(
          content: Tools().errorTextHandling(e.toString()), context: context);
    }
    return null;
  }

  // registers the basic store profile info
  setStoreProfile(
      {required BuildContext context,
      required Map<String, dynamic> vendor}) async {
    try {
      await _firestoreInstance
          .collection(_firebaseRoutes.rootCollection)
          .doc(_firebaseRoutes.profileDoc)
          .collection(_firebaseRoutes.fUid)
          .doc(_firebaseRoutes.profileData)
          .set(vendor);
      return '1';
    } catch (e) {
      CustomWidgets().snackBarWidget(
          content: Tools().errorTextHandling(e.toString()), context: context);
    }
  }
}
