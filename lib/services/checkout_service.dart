import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:ofg_web/constants/urls/firebase_endpoints.dart';
import 'package:ofg_web/services/store_services.dart';
import 'package:ofg_web/utils/custom_widgets.dart';
import 'package:ofg_web/utils/tools.dart';

class CheckoutService {
  CheckoutService();

  final FirebaseFirestore _storeInstnace = FirebaseFirestore.instance;
  final FirebaseRoutes _firebaseRoutes = FirebaseRoutes();
  final StoreServices _storeServices = StoreServices();
  final CustomWidgets _customWidgets = CustomWidgets();
  final Tools _tools = Tools();

  // checkout bill registration
  Future<String> registerCheckoutToStore(
      {required BuildContext context,
      required Map<String, dynamic> dataMap}) async {
    try {
      await _storeInstnace
          .collection(_firebaseRoutes.checkoutRoot)
          .doc(_firebaseRoutes.fUid)
          .collection(_firebaseRoutes.checkoutDoc)
          .doc(dataMap['checkoutNo'])
          .set(dataMap);
      return '1';
    } catch (e) {
      // ignore: use_build_context_synchronously
      _customWidgets.snackBarWidget(
          content: _tools.errorTextHandling(e.toString()), context: context);
    }
    return 'Some error occured';
  }

  // update store data from dataMap
  Future<String> updateStoreItemQtyAfterCheckout(
      {required BuildContext context,
      required Map<String, dynamic> dataMap}) async {
    for (var item in dataMap['storeAddsItems']) {
      // use the update qty method to update the qty of the item
      try {
        await _storeServices.updateItemQty(
            context: context,
            productName: item['name'],
            newQty: item['storeQty'] - item['qty']);
      } catch (e) {
        // ignore: use_build_context_synchronously
        _customWidgets.snackBarWidget(
            content: _tools.errorTextHandling(e.toString()), context: context);
        return 'Something went wrong';
      }
    }
    return '1';
  }

  // get store bill data
  getAllCheckouts({required BuildContext context}) async {
    try {
      QuerySnapshot snap = await _storeInstnace
          .collection(_firebaseRoutes.checkoutRoot)
          .doc(_firebaseRoutes.fUid)
          .collection(_firebaseRoutes.checkoutDoc)
          .orderBy('billedDate')
          .get();

      dynamic parsedItemList = snap.docs.map(
        (doc) {
          return doc.data();
        },
      ).toList();
      return parsedItemList.isNotEmpty ? parsedItemList : [];
    } catch (e) {
      _customWidgets.snackBarWidget(
          content: _tools.errorTextHandling(e.toString()), context: context);
    }
  }

  // get limited checkouts
  getLimitedCheckouts(
      {required BuildContext context, required int limit}) async {
    try {
      QuerySnapshot snap = await _storeInstnace
          .collection(_firebaseRoutes.checkoutRoot)
          .doc(_firebaseRoutes.fUid)
          .collection(_firebaseRoutes.checkoutDoc)
          .orderBy('billedDate')
          .limit(limit)
          .get();

      dynamic parsedItemList = snap.docs.map(
        (doc) {
          return doc.data();
        },
      ).toList();
      return parsedItemList.isNotEmpty ? parsedItemList : [];
    } catch (e) {
      _customWidgets.snackBarWidget(
          content: _tools.errorTextHandling(e.toString()), context: context);
    }
  }
}
