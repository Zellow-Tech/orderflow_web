class InvoicePdfModel {
  final String invoiceNumber;
  final String shopName;
  final String shopAddress;
  final String customerName;
  final String customerAddress;
  final String invoiceDate;
  final String paymentMethod;
  final List<InvoiceItem> items;
  final List<QuickAddItem> quickAddItems;
  final String extraCharge;
  final String discount;

  InvoicePdfModel({
    required this.invoiceNumber,
    required this.shopName,
    required this.shopAddress,
    required this.customerName,
    required this.customerAddress,
    required this.invoiceDate,
    required this.paymentMethod,
    required this.items,
    required this.quickAddItems,
    required this.extraCharge,
    required this.discount,
  });
}

class InvoiceItem {
  final String name;
  final String quantity;
  final String price;
  final String totalPrice;
  final String tax;
  final String discount;

  InvoiceItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.tax,
    required this.discount,
  });
}

class QuickAddItem {
  final String name;
  final String price;
  final String qty;

  QuickAddItem({
    required this.qty,
    required this.name,
    required this.price,
  });
}
