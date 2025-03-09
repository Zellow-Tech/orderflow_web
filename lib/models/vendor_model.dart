import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a vendor with details such as store name, contact info, and payment history.
class VendorModel {
  /// The Firebase UID of the vendor.
  String firebaseUid;

  /// Name of the vendor's store.
  String storeName;

  /// Name of the store owner.
  String ownerName;

  /// Email ID of the vendor.
  String emailId;

  /// Contact phone number.
  String phoneNumber;

  /// Address of the vendor.
  String address;

  /// Indicates whether the vendor is banned.
  bool isBanned;

  /// Indicates if the vendor is a premium vendor.
  bool isPremiumVendor;

  /// The next payment recharge date for premium vendors.
  DateTime paymentRechargeDate;

  /// List of past payment records.
  List<DateTime> pastPaymentDates;

  /// The currency used by the vendor for transactions.
  String currency;

  VendorModel({
    required this.firebaseUid,
    required this.storeName,
    required this.ownerName,
    required this.emailId,
    required this.phoneNumber,
    required this.address,
    required this.isBanned,
    required this.isPremiumVendor,
    required this.paymentRechargeDate,
    required this.pastPaymentDates,
    required this.currency,
  });

  /// Converts the VendorModel instance to a map for storage.
  Map<String, dynamic> toMap() {
    return {
      'firebaseUid': firebaseUid,
      'storeName': storeName,
      'ownerName': ownerName,
      'emailId': emailId,
      'phoneNumber': phoneNumber,
      'address': address,
      'isBanned': isBanned,
      'isPremiumVendor': isPremiumVendor,
      'paymentRechargeDate': paymentRechargeDate.toIso8601String(),
      'pastPaymentDates': pastPaymentDates,
      'currency': currency, // Added currency to the map
    };
  }

  /// Creates a VendorModel instance from a Firestore document snapshot.
  factory VendorModel.fromSnapshot(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>?;
    if (snap == null) {
      throw Exception("Snapshot data is null");
    }

    return VendorModel(
      firebaseUid: snap['firebaseUid'] ?? '',
      storeName: snap['storeName'] ?? '',
      ownerName: snap['ownerName'] ?? '',
      emailId: snap['emailId'] ?? '',
      phoneNumber: snap['phoneNumber'] ?? '',
      address: snap['address'] ?? '',
      isBanned: snap['isBanned'] ?? false,
      isPremiumVendor: snap['isPremiumVendor'] ?? false,
      paymentRechargeDate: DateTime.parse(
          snap['paymentRechargeDate'] ?? DateTime.now().toIso8601String()),
      pastPaymentDates: snap['pastPaymentDates'] as List<DateTime>? ?? [],
      currency: snap['currency'] ?? 'USD', // Default currency to 'USD'
    );
  }
}
