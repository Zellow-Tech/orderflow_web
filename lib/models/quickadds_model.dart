class QuickAddsModel {
  String itemName;
  double qty;
  double price;

  QuickAddsModel({
    required this.itemName,
    required this.price,
    required this.qty,
  });

  toJson() {
    return {
      'name': itemName,
      'price': price,
      'qty': qty,
    };
  }
}
