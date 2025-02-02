import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ofg_web/widgets/snackbar.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final OFGSnackBar _snackBar = OFGSnackBar();

  /// Signs up a vendor with Firebase Authentication
  Future<String> signVendorUp(
      {required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return '1'; // Success
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  /// Signs in a user using Firebase Authentication
  Future<String> signUserIn(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return '1'; // Success
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  /// Signs out the user, clears Firestore cache
  Future<String> signUserOut(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.terminate();
      await FirebaseFirestore.instance.clearPersistence();
      await _auth.signOut();
      return '1';
    } catch (e) {
      _snackBar.snackBarWithContent(content: e.toString(), context: context);
      return e.toString();
    }
  }

  /// Deletes the current user account
  Future<String> deleteUserAccount(BuildContext context) async {
    try {
      await _auth.currentUser?.delete();
      return '1'; // Success
    } catch (e) {
      _snackBar.snackBarWithContent(content: e.toString(), context: context);
      return e.toString(); // Return error message
    }
  }
}
