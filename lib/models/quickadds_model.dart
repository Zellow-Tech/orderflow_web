class QuickAddsModel {
  String itemName;
  double qty;
  double price;
  bool customPrice;

  QuickAddsModel(
      {required this.itemName,
      required this.price,
      required this.customPrice,
      required this.qty});

  toJson() {
    return {
      'name': itemName,
      'price': price,
      'qty': qty,
      'customPrice': customPrice
    };
  }
}
