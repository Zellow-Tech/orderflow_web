import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ofg_web/constants/urls/firebase_endpoints.dart';
import 'package:ofg_web/models/item_model.dart';
import 'package:ofg_web/utils/custom_widgets.dart';
import 'package:ofg_web/utils/tools.dart';

class StoreServices {
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  final FirebaseRoutes _firebaseRoutes = FirebaseRoutes();

  // get all the items listed in the store
  getStoreListings({required BuildContext context}) async {
    try {
      QuerySnapshot snap = await _firestoreInstance
          .collection(_firebaseRoutes.rootCollection)
          .doc(_firebaseRoutes.storeDoc)
          .collection(_firebaseRoutes.fUid)
          .get();

      dynamic parsedItemList = snap.docs.map(
        (doc) {
          return doc.data();
        },
      ).toList();
      return parsedItemList.isNotEmpty ? parsedItemList : [];
    } catch (e) {
      CustomWidgets().snackBarWidget(
          content: Tools().errorTextHandling(e.toString()), context: context);
    }
  }

  // adding a new item to store database
  addItemToStoreListings(
      {required BuildContext context, required StoreItem item}) {
    try {
      _firestoreInstance
          .collection(_firebaseRoutes.rootCollection)
          .doc(_firebaseRoutes.storeDoc)
          .collection(_firebaseRoutes.fUid)
          .doc(item.itemName)
          .set(item.toMap());
      return '1';
    } catch (e) {
      CustomWidgets().snackBarWidget(
          content: Tools().errorTextHandling(e.toString()), context: context);
    }
  }

  // sets the status of the product to live or not
  updateLiveStatus(
      {required BuildContext context,
      required String productName,
      required bool status}) async {
    try {
      _firestoreInstance
          .collection(_firebaseRoutes.rootCollection)
          .doc(_firebaseRoutes.storeDoc)
          .collection(_firebaseRoutes.fUid)
          .doc(productName)
          .update({'live': status});
    } catch (e) {
      CustomWidgets().snackBarWidget(
          content: Tools().errorTextHandling(e.toString()), context: context);
    }
  }

  // update specific item param
  updateItemQty(
      {required BuildContext context,
      required String productName,
      required double newQty}) async {
    try {
      _firestoreInstance
          .collection(_firebaseRoutes.rootCollection)
          .doc(_firebaseRoutes.storeDoc)
          .collection(_firebaseRoutes.fUid)
          .doc(productName)
          .update({'qty': newQty});
    } catch (e) {
      CustomWidgets().snackBarWidget(
          content: Tools().errorTextHandling(e.toString()), context: context);
    }
  }

  // deletes an item from store.
  deleteItemFromStore(
      {required BuildContext context, required String productName}) async {
    try {
      _firestoreInstance
          .collection(_firebaseRoutes.rootCollection)
          .doc(_firebaseRoutes.storeDoc)
          .collection(_firebaseRoutes.fUid)
          .doc(productName)
          .delete();
    } catch (e) {
      CustomWidgets().snackBarWidget(
          content: Tools().errorTextHandling(e.toString()), context: context);
    }
  }

  // updates the store item's details
  updateStoreItemDetails(
      {required BuildContext context, required StoreItem item}) async {
    try {
      _firestoreInstance
          .collection(_firebaseRoutes.rootCollection)
          .doc(_firebaseRoutes.storeDoc)
          .collection(_firebaseRoutes.fUid)
          .doc(item.itemName)
          .set(item.toMap());
      return '1';
    } catch (e) {
      CustomWidgets().snackBarWidget(
          content: Tools().errorTextHandling(e.toString()), context: context);
    }
  }
}
