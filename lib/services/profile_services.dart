import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ofg_web/routes/server/firebase_routes.dart';
import 'package:ofg_web/utils/text_formatting.dart';

class OFGProfileServices {
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  final OFGFirebaseRoutes _firebaseRoutes = OFGFirebaseRoutes();
  final OFGTextFormatting _formatting = OFGTextFormatting();

  // get profile data
  getProfileData({required BuildContext context}) async {
    try {
      DocumentSnapshot snap = await _firestoreInstance
          .collection(_firebaseRoutes.rootCollection)
          .doc(_firebaseRoutes.profileDoc)
          .collection(_firebaseRoutes.fUid)
          .doc(_firebaseRoutes.profileData)
          .get();
      return (snap.data() as Map<String, dynamic>);
    } catch (e) {
      _formatting.errorTextHandling(
        e.toString(),
      );
    }
    return null;
  }

  // registers the basic store profile info
  registerStoreProfile(
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
      _formatting.errorTextHandling(
        e.toString(),
      );
    }
  }
}
