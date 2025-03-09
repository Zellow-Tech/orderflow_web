/// Represents a checkpoint for restocking an item.
/// Stores the date of restock, previous price, previous unit, and previous quantity.
class RestockCheckpoint {
  /// The date when the restock happened.
  DateTime date;

  /// The price of the item before the restock.
  double prevPrice;

  /// The unit of measurement before the restock.
  String prevUnit;

  /// The quantity of the item before the restock.
  double prevQty;

  RestockCheckpoint({
    required this.date,
    required this.prevPrice,
    required this.prevUnit,
    required this.prevQty,
  });

  /// Converts the RestockCheckpoint instance to a map for storage.
  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'prevPrice': prevPrice,
      'prevUnit': prevUnit,
      'prevQty': prevQty,
    };
  }

  /// Creates a RestockCheckpoint instance from a map.
  factory RestockCheckpoint.fromMap(Map<String, dynamic> snap) {
    return RestockCheckpoint(
      date: DateTime.parse(snap['date']),
      prevPrice: (snap['prevPrice'] ?? 0).toDouble(),
      prevUnit: snap['prevUnit'] ?? '',
      prevQty: (snap['prevQty'] ?? 0).toDouble(),
    );
  }
}
