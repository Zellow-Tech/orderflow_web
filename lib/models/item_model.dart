import 'package:cloud_firestore/cloud_firestore.dart';

class StoreItem {
  String itemName;
  List itemUrls;
  String itemDescription;
  String unit;
  double itemPrice;
  double itemQty;
  double itemDiscount;
  double itemTax;

  List<String> tags;

  bool allowCustomOrders;
  bool returnable;
  bool itemLive;

  //
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
  });

  // to map func that is used before upld
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
    };
  }

  // doc snap parser function that returns an Item
  StoreItem fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> snap = (snapshot.data() as Map<String, dynamic>);

    return StoreItem(
      unit: snap['unit'],
      itemName: snap['name'],
      itemDescription: snap['desc'],
      itemLive: snap['live'],
      itemPrice: snap['price'],
      itemDiscount: snap['discount'],
      itemTax: snap['tax'],
      tags: snap['tags'],
      returnable: snap['returnable'],
      itemQty: snap['qty'],
      itemUrls: snap['urls'],
      allowCustomOrders: snap['customOrders'],
    );
  }
}
