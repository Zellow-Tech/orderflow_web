import 'package:ofg_web/models/payee_model.dart';

class CheckoutModel {
  String checkoutNo;
  List extraCharges; // Assuming this is for extra fees
  bool isInvoice;
  List<dynamic> storeAddsItems;
  List<dynamic> quickAddsItems;
  List<String> paymentMode;
  DateTime billedDate;
  DateTime? dueDate;
  Payee payee;

  CheckoutModel({
    required this.checkoutNo,
    required this.storeAddsItems,
    required this.quickAddsItems,
    required this.isInvoice,
    required this.billedDate,
    required this.extraCharges, // Fixed the parameter name
    required this.payee,
    this.dueDate, // Made the dueDate parameter optional
    this.paymentMode = const [], // Initialize paymentMode with an empty list
  });

  Map<String, dynamic> toJson() {
    return {
      'checkoutNo': checkoutNo,
      'extraCharges': extraCharges, // Fixed the field name
      'isInvoice': isInvoice,
      'storeAddsItems': storeAddsItems,
      'quickAddsItems': quickAddsItems,
      'paymentMode': paymentMode,
      'billedDate': billedDate.toIso8601String(),
      'payee': payee.toJson(),
      'dueDate': dueDate
    };
  }
}
