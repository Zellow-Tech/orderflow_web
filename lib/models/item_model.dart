import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ofg/models/restock_checkpoint_model.dart';

/// Represents a store item with various attributes such as price, quantity, and restocking history.
class StoreItem {
  /// The name of the item.
  String itemName;

  /// List of image URLs for the item.
  List<String> itemUrls;

  /// Description of the item.
  String itemDescription;

  /// The unit of measurement for the item (e.g., kg, liter, piece).
  String unit;

  /// The current price of the item.
  double itemPrice;

  /// The current quantity available.
  double itemQty;

  /// The discount applied to the item.
  double itemDiscount;

  /// The tax applied to the item.
  double itemTax;

  /// Tags associated with the item for categorization.
  List<String> tags;

  /// Indicates if custom orders are allowed for this item.
  bool allowCustomOrders;

  /// Indicates if the item is returnable.
  bool returnable;

  /// Indicates if the item is currently available for sale.
  bool itemLive;

  /// List of restocking checkpoints for tracking inventory changes.
  List<RestockCheckpoint> restockCheckpoints;

  StoreItem({
    required this.itemName,
    required this.itemDescription,
    required this.itemLive,
    required this.itemPrice,
    required this.itemDiscount,
    required this.itemQty,
    required this.unit,
    required this.itemUrls,
    required this.tags,
    required this.returnable,
    required this.allowCustomOrders,
    required this.itemTax,
    required this.restockCheckpoints,
  });

  /// Converts the StoreItem instance to a map for storage.
  Map<String, dynamic> toMap() {
    return {
      'name': itemName,
      'desc': itemDescription,
      'urls': itemUrls,
      'qty': itemQty,
      'live': itemLive,
      'price': itemPrice,
      'discount': itemDiscount,
      'tax': itemTax,
      'unit': unit,
      'returnable': returnable,
      'tags': tags,
      'customOrders': allowCustomOrders,
      'restockCheckpoints': restockCheckpoints.map((e) => e.toMap()).toList(),
    };
  }

  /// Creates a StoreItem instance from a Firestore document snapshot.
  factory StoreItem.fromSnapshot(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>?;
    if (snap == null) {
      throw Exception("Snapshot data is null");
    }

    return StoreItem(
      itemName: snap['name'] ?? '',
      itemDescription: snap['desc'] ?? '',
      itemLive: snap['live'] ?? false,
      itemPrice: (snap['price'] ?? 0).toDouble(),
      itemDiscount: (snap['discount'] ?? 0).toDouble(),
      itemTax: (snap['tax'] ?? 0).toDouble(),
      unit: snap['unit'] ?? '',
      returnable: snap['returnable'] ?? false,
      allowCustomOrders: snap['customOrders'] ?? false,
      itemQty: (snap['qty'] ?? 0).toDouble(),
      itemUrls: List<String>.from(snap['urls'] ?? []),
      tags: List<String>.from(snap['tags'] ?? []),
      restockCheckpoints: (snap['restockCheckpoints'] as List<dynamic>? ?? [])
          .map((e) => RestockCheckpoint.fromMap(e))
          .toList(),
    );
  }
}
