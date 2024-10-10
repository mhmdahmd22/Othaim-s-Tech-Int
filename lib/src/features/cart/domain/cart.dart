import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../products/domain/products.dart';

/// Model class representing the shopping cart contents.
class Cart {
  const Cart({
    this.id = '',
    this.date,
    this.products = const [],
  });

  final String id;
  final DateTime? date;
  final List<ProductID> products;

  /// Convert Cart object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'products': json.encode(products),
    };
  }

  /// Create a Cart object from a Map
  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id']?.toString() ?? '',
      date: map['date'] != null
          ? DateTime.parse(map['date'])
          : null, // Parse date if it's not null
      products: map['products'] != null
          ? List<ProductID>.from(
              (json.decode(map['products']) as List<dynamic>)
                  .map((item) => Product.fromMap(item as Map<String, dynamic>)),
            )
          : [],
    );
  }

  /// Convert Cart object to JSON string
  String toJson() => json.encode(toMap());

  /// Create a Cart object from JSON string
  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Cart(id: $id, date: $date, products: $products)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cart &&
        other.id == id &&
        other.date == date &&
        listEquals(other.products, products);
  }

  @override
  int get hashCode {
    return id.hashCode ^ date.hashCode ^ products.hashCode;
  }
}
