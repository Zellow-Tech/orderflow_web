import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ofg_web/utils/custom_widgets.dart';

/// A class that handles authentication services.
class AuthServices {
  /// Instance of FirebaseAuth.
  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  /// Signs up a vendor with the given [email] and [password].
  ///
  /// Returns a string indicating the result of the operation.
  signVendorUp({required String email, required String password}) async {
    String result = 'Something went wrong';

    try {
      // Register the user in the authentication tab of Firebase.
      await _authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      result = '1';
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  /// Signs in a user with the given [email] and [password].
  ///
  /// Returns a list containing the result of the operation, the user type, and the verification status.
  signUserIn({required String email, required String password}) async {
    String result = 'Some error occurred';
    String type = '';
    String vStatus = '';
    try {
      // Sign in the user with the provided email and password.
      await _authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      result = '1';
    } catch (e) {
      result = e.toString();
    }
    return [result, type, vStatus];
  }

  /// Signs out the current user.
  ///
  /// Clears the Firestore persistence and signs out the user from FirebaseAuth.
  signUserOut(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.terminate();
      await FirebaseFirestore.instance.clearPersistence();
      await _authInstance.signOut();
    } catch (e) {
      // Display a snackbar with the error message.
      CustomWidgets().snackBarWidget(content: e.toString(), context: context);
    }
  }

  /// Deletes the current user's account.
  ///
  /// Returns a string indicating the result of the operation.
  deleteUserAccount() async {
    String result = 'Something went wrong';
    try {
      await _authInstance.currentUser!.delete();
    } catch (e) {
      result = e.toString();
    }
    return result;
  }
}
